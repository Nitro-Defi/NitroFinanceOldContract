/** @type import('hardhat/config').HardhatUserConfig */

require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-deploy");
require("solidity-coverage");
require("hardhat-gas-reporter");
require("hardhat-contract-sizer");
require("dotenv").config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RINKEBY_URL = process.env.RINKEBY_RUL;
const GOERLI_URL = process.env.GOERLI_URL;
const ETHERSCAN = process.env.ETHERSCAN;
const COINMARTCAP = process.env.COINMARTCAP;
const MAINNET = process.env.MAINNET_URL;

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      blockCon: 1,
      forking: {
        url: MAINNET,
      },
    },
    rinkeby: {
      chainId: 4,
      blockCon: 6,
      url: RINKEBY_URL,
      accounts: [PRIVATE_KEY],
    },
    goerli: {
      chainId: 5,
      blockCon: 1,
      url: GOERLI_URL,
      accounts: [PRIVATE_KEY],
    },
  },
  solidity: {
    // settings: {
    //   optimizer: {
    //     enabled: true,
    //     runs: 50,
    //     details: {
    //       yul: true,
    //       yulDetails: {
    //         stackAllocation: true,
    //         optimizerSteps: "dhfoDgvulfnTUtnIf",
    //       },
    //     },
    //   },
    // },

    compilers: [
      {
        version: "0.8.7",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
            details: { yul: true },
          },
        },
      },
      { version: "0.6.0" },
      { version: "0.6.12" },
      { version: "0.7.6" },
    ],

    // setting: {
    //   optimizer: {
    //     enabled: true,
    //     runs: 1000,
    //   },
    // },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
  contractSizer: {
    //alphaSort: true,
    runOnCompile: true,
    //disambiguatePaths: false,
  },
  etherscan: {
    // yarn hardhat verify --network <NETWORK> <CONTRACT_ADDRESS> <CONSTRUCTOR_PARAMETERS>
    apiKey: {
      goerli: ETHERSCAN,
    },
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    coinmarketcap: COINMARTCAP,
    //token: "MATIC",
  },
  // mocha: {
  //   timeout: 500000, // 500 seconds max for running tests
  // },
};
