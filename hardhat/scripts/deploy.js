const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const{ WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require('../constants');


async function main(){
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  const metadataURL = METADATA_URL;

  const SimbiumDevsContract = await ethers.getContractFactory("SimbiumDev");

  const deployedSimbiumDevsContract = await SimbiumDevsContract.deploy(
    metadataURL,
    whitelistContract)

  console.log(
  "Simbium Devs Contract Address:",
  deployedSimbiumDevsContract.address
  );
}
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });