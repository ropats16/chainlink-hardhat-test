const { version } = require("chai");

require("@nomiclabs/hardhat-waffle")
require("@nomiclabs/hardhat-ethers")
require("hardhat-deploy");
require("./tasks");
require("dotenv").config();


const defaultNetwork = "hardhat";

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.4.24",
      },
      {
        version: "0.8.7",
      }
    ],
  },
  defaultNetwork,
  //configuring network chain Ids for the deploy script
  networks: {
    hardhat: {
      chainId: 31337
    },
    rinkeby: {
      chainId: 4,
      url: process.env.RINKEBY_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      gas: 2100000, 
      gasPrice: 8000000000,
    },
  },
  // when we get fake accounts, deployer is always at index 0
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
};
