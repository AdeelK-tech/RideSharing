//SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
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
    mapping(uint => Ride) public riderIdtoride;
    mapping(uint => Rider) RideIdToRider;
    mapping(uint => Ride) DriverIdToRide;
    mapping(uint => uint) RideIdToRiderId;
    struct driver {
        uint Id;
        string name;
        string nic;
        string email;
        string cellno;
        string LiscenceNo;
        bool isRegistered;
        Car car;
    }
    struct Rider {
        uint Id;
        string name;
        string email;
        string cellno;
    }
    struct Car {
        string regNum;
        string modelName;
    }
    enum state {
        created,
        running,
        completed
    }
    struct Ride {
        uint rideId;
        address payable creator;
        string StartTime;
        // uint seats;
        string location;
        string sourceLong;
        string sourceLat;
        string destLong;
        string destLat;
        state currState;
        bool isPayed;
        uint fair;
    }
    event registeredDriver(
        uint driverId,
        string name,
        string nic,
        string regNum
    );
    event registeredRider(
        uint RiderId,
        string name,
        string email,
        string cellno
    );
    event UserType(uint Type, uint id);
    event RideCreated(uint id);
    error AlreadyRegistered(string msg);
    error ridenotCompleted(string msg);
    error lessThanFair(string msg);
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
        string memory _name,
        string memory _nic,
        string memory _email,
        string memory _cellno,
        string memory _regNum,
        string memory _modelName,
        string memory _LiscenceNo
    ) public {
        if (driverIsRegistered[msg.sender] == true) {
            revert AlreadyRegistered("This Address is already Registered");
        }
        Car memory c = Car(_regNum, _modelName);
        driverId.increment();
        uint _driverId = driverId.current();
        driver memory d = driver(
            _driverId,
            _name,
            _nic,
            _email,
            _cellno,
            _LiscenceNo,
            true,
            c
        );
        driverIsRegistered[msg.sender] = true;
        idToDriver[_driverId] = d;
        addressToDriver[msg.sender] = d;

        emit registeredDriver(_driverId, _name, _nic, _regNum);
    }

    function registerForRider(
        string memory _name,
        string memory _email,
        string memory _cellno
    ) public {
        if (riderIsRegistered[msg.sender] == true) {
            revert AlreadyRegistered("This Address is already Registered");
        }
        RiderId.increment();
        uint _RiderId = RiderId.current();
        Rider memory r = Rider(_RiderId, _name, _email, _cellno); // Continue From here
        riderIsRegistered[msg.sender] = true;
        idToRider[_RiderId] = r;
        addressToRider[msg.sender] = r;

        emit registeredRider(_RiderId, _name, _email, _cellno);
    }

    function createRide(
        string memory location,
        string memory sourceLong,
        string memory sourceLat,
        string memory destLong,
        string memory destLat,
        string memory startTime
    )
        public
        // uint seats,
        // uint fair
        driverIsRegisteredModifier
    {
        uint _driverId = getDriverByAddress(msg.sender);
        RideId.increment();
        uint _rideId = RideId.current();
        Ride memory _ride = Ride(
            _rideId,
            payable(msg.sender),
            startTime,
            // seats,
            location,
            sourceLong,
            sourceLat,
            destLong,
            destLat,
            state.created,
            false,
            0
        );
        idToRide[_rideId] = _ride;
        RideIDTodriverId[_rideId] = _driverId;
        DriverIdToRide[_driverId] = _ride;
        emit RideCreated(_rideId);
    }

    function setFair(uint rideId, uint fair) public {
        Ride storage _ride = idToRide[rideId];
        _ride.fair = fair;
    }

    function joinRide(uint rideId, uint riderId) public {
        riderIdtorideId[riderId] = rideId;
        Rider memory r = idToRider[riderId];
        Ride memory _ride = idToRide[rideId];
        RideIdToRider[rideId] = r;
        RideIdToRiderId[rideId] = riderId;
        riderIdtoride[riderId] = _ride;
    }

    function getRidesByRiderId(
        uint riderId
    ) public view returns (Ride[] memory) {
        uint ridesCount;
        uint j;
        for (uint i = 1; i <= RideId.current(); i++) {
            if (RideIdToRiderId[i] == riderId) {
                ridesCount++;
            }
        }
        Ride[] memory ridesByRider = new Ride[](ridesCount);
        for (uint i = 1; i <= ridesCount; i++) {
            if (RideIdToRiderId[i] == riderId) {
                ridesByRider[j] = riderIdtoride[i];
                j++;
            }
        }
        return ridesByRider;
    }

    // function getRidersByRideId(
    //     uint rideId
    // ) public view returns (Rider[] memory) {
    //     uint ridesCount;
    //     uint j;
    //     for (uint i = 1; i <= RideId.current(); i++) {
    //         if (riderIdtorideId[i] == rideId) {
    //             ridesCount++;
    //         }
    //     }
    //     Rider[] memory ridersAtARide = new Rider[](ridesCount);
    //     for (uint i = 1; i <= ridesCount; i++) {
    //         if (riderIdtorideId[i] == rideId) {
    //             ridersAtARide[j] = RideIdToRider[i];
    //             j++;
    //         }
    //     }
    //     return ridersAtARide;
    // }

    function getRidesByDriverId(
        uint DriverId
    ) public view returns (Ride[] memory) {
        uint ridesCount;
        uint j;
        for (uint i = 1; i <= RideId.current(); i++) {
            if (RideIDTodriverId[i] == DriverId) {
                ridesCount++;
            }
        }
        Ride[] memory ridesByDriver = new Ride[](ridesCount);
        for (uint i = 1; i <= ridesCount; i++) {
            if (RideIDTodriverId[i] == DriverId) {
                ridesByDriver[j] = DriverIdToRide[DriverId];
                j++;
            }
        }
        return ridesByDriver;
    }

    function getUserType(address user) public view returns (uint, uint, uint) {
        uint userType;
        uint r_id;
        uint d_id;
        Rider memory r = addressToRider[user];
        driver memory d = addressToDriver[user];
        if (r.Id == 0 && d.Id != 0) {
            userType = 1;
            d_id = d.Id;
        } else if (r.Id != 0 && d.Id == 0) {
            userType = 2;
            r_id = r.Id;
        } else if (r.Id != 0 && d.Id != 0) {
            userType = 3;
            d_id = d.Id;
            r_id = r.Id;
        }
        return (userType, r_id, d_id);
    }

    function getAllRides() public view returns (Ride[] memory) {
        uint j;

        Ride[] memory rides = new Ride[](RideId.current());
        for (uint i = 1; i <= RideId.current(); i++) {
            rides[j] = idToRide[i];
            j++;
        }
        return rides;
    }

    function completeRide(uint rideId) public {
        Ride storage _ride = idToRide[rideId];
        _ride.currState = state.completed;
    }

    function startRide(uint rideId) public {
        Ride storage _ride = idToRide[rideId];

        _ride.currState = state.completed;
    }

    function payForRide(uint rideId) public payable {
        Ride memory _ride = idToRide[rideId];
        if (_ride.currState == state.running) {
            revert ridenotCompleted("ride is not completed");
        }
        address driverAddress = _ride.creator;
        if (msg.value < _ride.fair) {
            revert lessThanFair("value sent is less than fair");
        }
        bool sent = payable(driverAddress).send(msg.value);
        require(sent, "Failed to send Ether");
        _ride.isPayed = true;
    }
}
