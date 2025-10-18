const PRIVATE_KEY = process.env.PRIVATE_KEY || "824ab816921f0769d5cdc63ff91dfb0aae4f3f848b6aad401e94e38f0bcf8f92";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    planq: {
      url: "https://evm-rpc-atlas.planq.network",
      chainId: 7077,
      accounts: [PRIVATE_KEY],
      gasPrice: 8000000000,
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
  },
  paths: {
    sources: "./contracts-solidity",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
