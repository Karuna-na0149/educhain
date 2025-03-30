const hre = require("hardhat");

async function main() {
  console.log("Deploying EduChain contract...");

  // ✅ Get contract factory
  const EduChain = await hre.ethers.getContractFactory("EduChain");

  // ✅ Deploy contract & wait for deployment
  const eduChain = await EduChain.deploy();
  await eduChain.waitForDeployment(); // Ensures contract is fully deployed

  // ✅ Retrieve and log the contract address
  console.log(`✅ EduChain deployed to: ${await eduChain.getAddress()}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
