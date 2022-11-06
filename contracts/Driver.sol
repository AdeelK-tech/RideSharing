// SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Driver is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private driverId;

    constructor() ERC721("", "") {}

    function createDriver(string memory _driverUri) public returns (uint) {
        driverId.increment();
        uint _driverId = driverId.current();
        _setTokenURI(_driverId, _driverUri);
        return _driverId;
    }
}
