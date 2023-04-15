require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.10",
  networks:{
    sepoila:{
      url: process.env.INFURA_API_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY],
    },    
  },
};
