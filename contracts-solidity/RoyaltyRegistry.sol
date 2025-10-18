// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RoyaltyRegistry is Ownable {
    struct RoyaltyInfo {
        address receiver;
        uint96 percentage; // basis points (e.g., 500 = 5%)
    }

    mapping(address => RoyaltyInfo) public collectionRoyalties;
    
    event RoyaltySet(address indexed collection, address indexed receiver, uint96 percentage);

    constructor() Ownable(msg.sender) {}

    function setRoyalty(
        address collection,
        address receiver,
        uint96 percentage
    ) external {
        require(percentage <= 10000, "Percentage too high");
        require(
            msg.sender == owner() || msg.sender == collection,
            "Not authorized"
        );

        collectionRoyalties[collection] = RoyaltyInfo(receiver, percentage);
        emit RoyaltySet(collection, receiver, percentage);
    }

    function getRoyalty(address collection, uint256 salePrice) 
        external 
        view 
        returns (address receiver, uint256 royaltyAmount) 
    {
        RoyaltyInfo memory info = collectionRoyalties[collection];
        royaltyAmount = (salePrice * info.percentage) / 10000;
        return (info.receiver, royaltyAmount);
    }

    function getRoyaltyInfo(address collection) 
        external 
        view 
        returns (address receiver, uint96 percentage) 
    {
        RoyaltyInfo memory info = collectionRoyalties[collection];
        return (info.receiver, info.percentage);
    }
}
