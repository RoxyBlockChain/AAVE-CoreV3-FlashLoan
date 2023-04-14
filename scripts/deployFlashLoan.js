const hre = require("hardhat");

async function main() {
  
const FlashLoan = await hre.ethers.getContractAt("FlashLoan");
const flashLoan = await FlashLoan.deploy(
  "0x5E52dEc931FFb32f609681B8438A51c675cc232d"
);  
// during deployent of the contract, need to pass the Arguments of Constractor

await flashLoan.deployed();

console.log(" Aave Flash Loan contract Deployed on Address:", flashLoan.address)
  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
