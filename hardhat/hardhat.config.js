require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });


const GOERLI_URL = process.env.GOERLI_URL;
const PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "goerli",
  networks:{
    goerli:{
      url: GOERLI_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
    }
  }
}
