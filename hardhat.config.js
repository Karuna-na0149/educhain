require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/ed8b82cd2c434fb0a9df4c8f52ab520c", // Use Infura or Alchemy
      accounts: ["64ae5cbccfae21ca40fa76c0dfb81af932a7acded7f6637681a3d6d179c38261"], // Private key of your Sepolia account
    },
  },
  etherscan: {
    apiKey: {
      sepolia: "U7XJUY6CWTNAVB1ERNS5DSWNMJMQFPYC3K", // Etherscan API key for contract verification
    },
  },
};
