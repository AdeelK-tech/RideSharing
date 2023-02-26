require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
ALCHEMY_API_KEY = "yVoCNnVuTu2dcUMio5Ax0K2Ecuv1eSCr";
PRIVATE_KEY =
  "8dd9a1413df575220c56e07aa6954e21de61129d9ebc5a89816513cc86fa0167";
module.exports = {
  solidity: "0.8.4",
  networks: {
    goerli: {
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: "DBKWC8YZ91UC2CCEXT6K5669WU84IJJIJ2",
  },
};
