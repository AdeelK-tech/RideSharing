const { ethers } = require("hardhat");
require("@nomiclabs/hardhat-etherscan");
async function main() {
  const rideSharing = await ethers.getContractFactory("RideSharing");
  const gasPrice = await rideSharing.signer.getGasPrice();
  console.log(`Current gas price: ${gasPrice}`);
  const estimatedGas = await rideSharing.signer.estimateGas(
    rideSharing.getDeployTransaction()
  );
  console.log(`Estimated gas: ${estimatedGas}`);
  const deploymentPrice = gasPrice.mul(estimatedGas);
  const deployerBalance = await rideSharing.signer.getBalance();
  console.log(
    `Deployer balance:  ${ethers.utils.formatEther(deployerBalance)}`
  );
  console.log(
    `Deployment price:  ${ethers.utils.formatEther(deploymentPrice)}`
  );
  if (deployerBalance.lt(deploymentPrice)) {
    throw new Error(
      `Insufficient funds. Top up your account balance by ${ethers.utils.formatEther(
        deploymentPrice.sub(deployerBalance)
      )}`
    );
  }

  const rideSharingCon = await rideSharing.deploy();
  await rideSharingCon.deployed();

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
