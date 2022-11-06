// SPDX-License-Identifier:MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Rider is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private RiderId;

    constructor() ERC721("", "") {}

    function createRider(string memory _driverUri) public returns (uint) {
        RiderId.increment();
        uint _RiderId = RiderId.current();
        _setTokenURI(_RiderId, _driverUri);
        return _RiderId;
    }
}
