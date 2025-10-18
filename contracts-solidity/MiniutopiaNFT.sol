// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MiniutopiaNFT is ERC721URIStorage, ERC721Enumerable, Ownable, ReentrancyGuard {
    uint256 private _tokenIds;

    string public collectionURI;
    uint256 public maxSupply;
    uint256 public mintPrice;
    bool public publicMintEnabled;
    address public royaltyReceiver;
    uint96 public royaltyPercentage; // basis points (e.g., 500 = 5%)

    mapping(address => bool) public whitelist;
    mapping(uint256 => string) private _tokenURIs;

    event Minted(address indexed to, uint256 indexed tokenId, string tokenURI);
    event WhitelistUpdated(address indexed account, bool status);
    event RoyaltyUpdated(address indexed receiver, uint96 percentage);

    constructor(
        string memory name,
        string memory symbol,
        string memory _collectionURI,
        uint256 _maxSupply,
        uint256 _mintPrice,
        address _royaltyReceiver,
        uint96 _royaltyPercentage
    ) ERC721(name, symbol) Ownable(msg.sender) {
        collectionURI = _collectionURI;
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        royaltyReceiver = _royaltyReceiver;
        royaltyPercentage = _royaltyPercentage;
        publicMintEnabled = false;
    }

    function mint(string memory tokenURI) external payable nonReentrant {
        require(publicMintEnabled || whitelist[msg.sender], "Minting not enabled");
        require(_tokenIds < maxSupply, "Max supply reached");
        require(msg.value >= mintPrice, "Insufficient payment");

        _tokenIds++;
        uint256 newTokenId = _tokenIds;

        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);

        emit Minted(msg.sender, newTokenId, tokenURI);
    }

    function batchMint(address to, string[] memory tokenURIs) external onlyOwner {
        require(_tokenIds + tokenURIs.length <= maxSupply, "Exceeds max supply");

        for (uint256 i = 0; i < tokenURIs.length; i++) {
            _tokenIds++;
            uint256 newTokenId = _tokenIds;
            _safeMint(to, newTokenId);
            _setTokenURI(newTokenId, tokenURIs[i]);
            emit Minted(to, newTokenId, tokenURIs[i]);
        }
    }

    function updateWhitelist(address[] calldata accounts, bool status) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            whitelist[accounts[i]] = status;
            emit WhitelistUpdated(accounts[i], status);
        }
    }

    function setPublicMintEnabled(bool enabled) external onlyOwner {
        publicMintEnabled = enabled;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function setRoyalty(address receiver, uint96 percentage) external onlyOwner {
        require(percentage <= 10000, "Percentage too high");
        royaltyReceiver = receiver;
        royaltyPercentage = percentage;
        emit RoyaltyUpdated(receiver, percentage);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }

    function royaltyInfo(uint256, uint256 salePrice) external view returns (address, uint256) {
        uint256 royaltyAmount = (salePrice * royaltyPercentage) / 10000;
        return (royaltyReceiver, royaltyAmount);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721URIStorage, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _update(address to, uint256 tokenId, address auth) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }
}
