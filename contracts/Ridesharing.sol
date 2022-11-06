//SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RideSharing {
    using Counters for Counters.Counter;
    Counters.Counter private driverId;
    Counters.Counter private RideId;
    Counters.Counter private RiderId;
    mapping(address => bool) public driverIsRegistered;
    mapping(address => bool) public riderIsRegistered;
    mapping(uint => driver) public idToDriver;
    mapping(uint => Rider) public idToRider;
    mapping(address => driver) public addressToDriver;
    mapping(address => Rider) public addressToRider;
    mapping(uint => uint) public RideIDTodriverId;
    mapping(uint => Ride) public idToRide;
    mapping(uint => uint) public riderIdtorideId;
    mapping(uint => Rider) RideIdToRider;
    struct driver {
        uint driverURIId;
        uint Id;
        string name;
        string nic;
        string email;
        string cellno;
        bool isRegistered;
        Car car;
    }
    struct Rider {
        uint driverURIId;
        uint Id;
        string name;
        string email;
        string cellno;
    }
    struct Car {
        string regNum;
        string modelName;
    }
    struct Ride {
        uint rideId;
        address creator;
        string startPoint;
        string destination;
    }
    event registered(string name, string nic, string regNum);
    modifier driverIsRegisteredModifier() {
        require(driverIsRegistered[msg.sender] == true);
        _;
    }
    modifier riderIsRegisteredModifier() {
        require(riderIsRegistered[msg.sender] == true);
        _;
    }

    function getDriverByAddress(address _driver) public view returns (uint) {
        driver storage _d = addressToDriver[_driver];

        return _d.Id;
    }

    function registerForDriver(
        uint driverURI_Id,
        string memory _name,
        string memory _nic,
        string memory _email,
        string memory _cellno,
        string memory _regNum,
        string memory _modelName
    ) public {
        Car memory c = Car(_regNum, _modelName);
        driverId.increment();
        uint _driverId = driverId.current();
        driver memory d = driver(
            driverURI_Id,
            _driverId,
            _name,
            _nic,
            _email,
            _cellno,
            true,
            c
        );
        driverIsRegistered[msg.sender] = true;
        idToDriver[_driverId] = d;
        addressToDriver[msg.sender] = d;
        console.log(msg.sender);
        emit registered(_name, _nic, _regNum);
    }

    function registerForRider(
        uint riderURI_Id,
        string memory _name,
        string memory _email,
        string memory _cellno
    ) public {
        RiderId.increment();
        uint _RiderId = RiderId.current();
        Rider memory r = Rider(riderURI_Id, _RiderId, _name, _email, _cellno); // Continue From here
        riderIsRegistered[msg.sender] = true;
        idToRider[_RiderId] = r;
        addressToRider[msg.sender] = r;
        console.log(msg.sender);
        emit registered(_name, _email, _cellno);
    }

    function createRide(string memory startPoint, string memory destination)
        public
        driverIsRegisteredModifier
    {
        uint _driverId = getDriverByAddress(msg.sender);
        RideId.increment();
        uint _rideId = RideId.current();
        Ride memory _ride = Ride(_rideId, msg.sender, startPoint, destination);
        idToRide[_rideId] = _ride;
        RideIDTodriverId[_rideId] = _driverId;
    }

    function joinRide(uint rideId, uint riderId) public {
        riderIdtorideId[riderId] = rideId;
        Rider memory r = idToRider[riderId];
        RideIdToRider[rideId] = r;
    }

    function getRidersByRideId(uint rideId)
        public
        view
        returns (Rider[] memory)
    {
        uint ridesCount;
        uint j;
        for (uint i = 1; i <= RideId.current(); i++) {
            if (riderIdtorideId[i] == rideId) {
                ridesCount++;
            }
        }
        Rider[] memory ridersAtARide = new Rider[](ridesCount);
        for (uint i = 1; i <= ridesCount; i++) {
            if (riderIdtorideId[i] == rideId) {
                ridersAtARide[j] = RideIdToRider[i];
            }
        }
        return ridersAtARide;
    }
}
