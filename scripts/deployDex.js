const hre = require("hardhat");

async function main() {
  
const Dex = await hre.ethers.getContractAt("Dex");
const dex = await Dex.deploy();  
// during deployent of the contract, need to pass the Arguments of Constractor

await dex.deployed();

console.log(" dex contract Deployed on Address:", dex.address)
  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
