// scripts/deploy.js

const hre = require("hardhat");

async function main() {
  const ImovelMarketplace = await hre.ethers.getContractFactory("ImovelMarketplace");
  const imovelMarketplace = await ImovelMarketplace.deploy();

  await imovelMarketplace.deployed();

  await hre.run("verify:verify", {
    address: imovelMarketplace.address,
    constructorArguments: [],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
