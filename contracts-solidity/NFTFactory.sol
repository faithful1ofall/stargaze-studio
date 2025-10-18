// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./MiniutopiaNFT.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTFactory is Ownable {
    address[] public collections;
    mapping(address => address[]) public creatorCollections;
    
    event CollectionCreated(
        address indexed collection,
        address indexed creator,
        string name,
        string symbol
    );

    constructor() Ownable(msg.sender) {}

    function createCollection(
        string memory name,
        string memory symbol,
        string memory collectionURI,
        uint256 maxSupply,
        uint256 mintPrice,
        address royaltyReceiver,
        uint96 royaltyPercentage
    ) external returns (address) {
        MiniutopiaNFT newCollection = new MiniutopiaNFT(
            name,
            symbol,
            collectionURI,
            maxSupply,
            mintPrice,
            royaltyReceiver,
            royaltyPercentage
        );

        address collectionAddress = address(newCollection);
        collections.push(collectionAddress);
        creatorCollections[msg.sender].push(collectionAddress);

        // Transfer ownership to creator
        newCollection.transferOwnership(msg.sender);

        emit CollectionCreated(collectionAddress, msg.sender, name, symbol);
        return collectionAddress;
    }

    function getCollections() external view returns (address[] memory) {
        return collections;
    }

    function getCreatorCollections(address creator) external view returns (address[] memory) {
        return creatorCollections[creator];
    }

    function getCollectionCount() external view returns (uint256) {
        return collections.length;
    }
}
