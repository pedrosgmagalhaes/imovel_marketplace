// hardhat.config.js
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

const { privateKey, etherscanApiKey, infuraProjectId } = require('./secrets.json');

module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {},
    goerli: {
      url: `https://goerli.infura.io/v3/${infuraProjectId}`,
      accounts: [privateKey]
    }
  },
  etherscan: {
    apiKey: etherscanApiKey
  }
};
