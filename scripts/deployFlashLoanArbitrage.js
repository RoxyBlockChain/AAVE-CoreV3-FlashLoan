const hre = require("hardhat");

async function main() {
  
const FlashLoanArbitrage = await hre.ethers.getContractAt("FlashLoanArbitrage");
const flashLoanArbitrage = await FlashLoanArbitrage.deploy("0xc4dCB5126a3AfEd129BC3668Ea19285A9f56D15D");  
// during deployent of the contract, need to pass the Arguments of Constractor

await flashLoanArbitrage.deployed();

console.log(" Aave Flash Loan contract Deployed on Address:", flashLoanArbitrage.address)
  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
