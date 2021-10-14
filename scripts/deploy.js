
const hre = require("hardhat");
async function main() {
  const TOKENVESTING = await hre.ethers.getContractFactory("MeshaToken");
  const token = await TOKENVESTING.deploy();

  await token.deployed();

  console.log("TokenVesting deployed address:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});


// deployed contract address on rinkeby 0xAC6b75140F7C8b7B70148e44829214Da8D64e686