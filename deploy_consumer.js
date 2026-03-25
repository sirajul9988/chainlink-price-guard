const hre = require("hardhat");

async function main() {
  // ETH / USD Feed on Mainnet
  const ETH_USD_FEED = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";
  const HEARTBEAT = 3600; // 1 hour

  const PriceConsumer = await hre.ethers.getContractFactory("PriceConsumer");
  const consumer = await PriceConsumer.deploy(ETH_USD_FEED, HEARTBEAT);

  await consumer.waitForDeployment();
  console.log(`PriceConsumer deployed to: ${await consumer.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
