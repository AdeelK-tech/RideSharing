const { ethers } = require("hardhat");

async function main() {
  const driver = await ethers.getContractFactory("Driver");
  const driverContract = await driver.deploy();
  const rider = await ethers.getContractFactory("Rider");
  const riderContract = await rider.deploy();
  const rideSharing = await ethers.getContractFactory("RideSharing");
  const rideSharingCon = await rideSharing.deploy();
  console.log("driver address:", driverContract.address);
  console.log("rider address:", riderContract.address);
  console.log("ridesharing address:", rideSharingCon.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
