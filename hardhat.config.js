require("@nomiclabs/hardhat-waffle");
ALCHEMY_API_KEY = "7R-Kjv7qdzXJ4wRJSwFWvcfrqCXbzd6Z";
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
};
