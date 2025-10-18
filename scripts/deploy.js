const { ethers } = require("ethers");
const fs = require("fs");

async function main() {
  console.log("Deploying contracts to Planq Atlas Testnet...");

  // Setup provider and wallet
  const provider = new ethers.JsonRpcProvider("https://evm-rpc-atlas.planq.network");
  const privateKey = process.env.PRIVATE_KEY || "824ab816921f0769d5cdc63ff91dfb0aae4f3f848b6aad401e94e38f0bcf8f92";
  const wallet = new ethers.Wallet(privateKey, provider);
  
  console.log("Deploying from address:", wallet.address);

  // Load compiled contracts
  const NFTFactoryArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts-solidity/NFTFactory.sol/NFTFactory.json"));
  const RoyaltyRegistryArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts-solidity/RoyaltyRegistry.sol/RoyaltyRegistry.json"));
  const BadgeHubArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts-solidity/BadgeHub.sol/BadgeHub.json"));
  const WhitelistMerkleArtifact = JSON.parse(fs.readFileSync("./artifacts/contracts-solidity/WhitelistMerkle.sol/WhitelistMerkle.json"));

  // Deploy NFT Factory
  const NFTFactory = new ethers.ContractFactory(NFTFactoryArtifact.abi, NFTFactoryArtifact.bytecode, wallet);
  const nftFactory = await NFTFactory.deploy();
  await nftFactory.waitForDeployment();
  const nftFactoryAddress = await nftFactory.getAddress();
  console.log("NFTFactory deployed to:", nftFactoryAddress);

  // Deploy Royalty Registry
  const RoyaltyRegistry = new ethers.ContractFactory(RoyaltyRegistryArtifact.abi, RoyaltyRegistryArtifact.bytecode, wallet);
  const royaltyRegistry = await RoyaltyRegistry.deploy();
  await royaltyRegistry.waitForDeployment();
  const royaltyRegistryAddress = await royaltyRegistry.getAddress();
  console.log("RoyaltyRegistry deployed to:", royaltyRegistryAddress);

  // Deploy Badge Hub
  const BadgeHub = new ethers.ContractFactory(BadgeHubArtifact.abi, BadgeHubArtifact.bytecode, wallet);
  const badgeHub = await BadgeHub.deploy();
  await badgeHub.waitForDeployment();
  const badgeHubAddress = await badgeHub.getAddress();
  console.log("BadgeHub deployed to:", badgeHubAddress);

  // Deploy Whitelist Merkle (with dummy root)
  const dummyRoot = "0x0000000000000000000000000000000000000000000000000000000000000000";
  const WhitelistMerkle = new ethers.ContractFactory(WhitelistMerkleArtifact.abi, WhitelistMerkleArtifact.bytecode, wallet);
  const whitelistMerkle = await WhitelistMerkle.deploy(dummyRoot);
  await whitelistMerkle.waitForDeployment();
  const whitelistMerkleAddress = await whitelistMerkle.getAddress();
  console.log("WhitelistMerkle deployed to:", whitelistMerkleAddress);

  console.log("\n=== Deployment Summary ===");
  console.log("NFTFactory:", nftFactoryAddress);
  console.log("RoyaltyRegistry:", royaltyRegistryAddress);
  console.log("BadgeHub:", badgeHubAddress);
  console.log("WhitelistMerkle:", whitelistMerkleAddress);

  // Save deployment addresses
  const deploymentInfo = {
    network: "planq-atlas-testnet",
    chainId: 7077,
    contracts: {
      NFTFactory: nftFactoryAddress,
      RoyaltyRegistry: royaltyRegistryAddress,
      BadgeHub: badgeHubAddress,
      WhitelistMerkle: whitelistMerkleAddress,
    },
    timestamp: new Date().toISOString(),
  };

  fs.writeFileSync(
    "./deployment-addresses.json",
    JSON.stringify(deploymentInfo, null, 2)
  );
  console.log("\nDeployment addresses saved to deployment-addresses.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
