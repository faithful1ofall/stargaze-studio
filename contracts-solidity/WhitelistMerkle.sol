// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract WhitelistMerkle is Ownable {
    bytes32 public merkleRoot;
    mapping(address => bool) public hasClaimed;
    
    event MerkleRootUpdated(bytes32 indexed newRoot);
    event Claimed(address indexed account);

    constructor(bytes32 _merkleRoot) Ownable(msg.sender) {
        merkleRoot = _merkleRoot;
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
        emit MerkleRootUpdated(_merkleRoot);
    }

    function verify(bytes32[] calldata proof, address account) public view returns (bool) {
        bytes32 leaf = keccak256(abi.encodePacked(account));
        return MerkleProof.verify(proof, merkleRoot, leaf);
    }

    function claim(bytes32[] calldata proof) external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(verify(proof, msg.sender), "Invalid proof");
        
        hasClaimed[msg.sender] = true;
        emit Claimed(msg.sender);
    }

    function isWhitelisted(bytes32[] calldata proof, address account) external view returns (bool) {
        return verify(proof, account);
    }
}
