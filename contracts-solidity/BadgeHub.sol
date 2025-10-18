// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BadgeHub is ERC721, Ownable {
    uint256 private _badgeIds;

    struct Badge {
        string name;
        string description;
        string imageURI;
        uint256 createdAt;
    }

    mapping(uint256 => Badge) public badges;
    mapping(address => uint256[]) public userBadges;
    mapping(address => bool) public managers;

    event BadgeCreated(uint256 indexed badgeId, string name);
    event BadgeAwarded(uint256 indexed badgeId, address indexed recipient);
    event ManagerUpdated(address indexed manager, bool status);

    modifier onlyManager() {
        require(managers[msg.sender] || msg.sender == owner(), "Not a manager");
        _;
    }

    constructor() ERC721("Miniutopia Badges", "MBADGE") Ownable(msg.sender) {
        managers[msg.sender] = true;
    }

    function createBadge(
        string memory name,
        string memory description,
        string memory imageURI
    ) external onlyManager returns (uint256) {
        _badgeIds++;
        uint256 newBadgeId = _badgeIds;

        badges[newBadgeId] = Badge({
            name: name,
            description: description,
            imageURI: imageURI,
            createdAt: block.timestamp
        });

        emit BadgeCreated(newBadgeId, name);
        return newBadgeId;
    }

    function awardBadge(uint256 badgeId, address recipient) external onlyManager {
        require(badges[badgeId].createdAt > 0, "Badge does not exist");
        require(balanceOf(recipient) == 0 || !_hasBadge(recipient, badgeId), "Already has badge");

        _safeMint(recipient, badgeId);
        userBadges[recipient].push(badgeId);

        emit BadgeAwarded(badgeId, recipient);
    }

    function batchAwardBadge(uint256 badgeId, address[] calldata recipients) external onlyManager {
        require(badges[badgeId].createdAt > 0, "Badge does not exist");

        for (uint256 i = 0; i < recipients.length; i++) {
            if (balanceOf(recipients[i]) == 0 || !_hasBadge(recipients[i], badgeId)) {
                _safeMint(recipients[i], badgeId);
                userBadges[recipients[i]].push(badgeId);
                emit BadgeAwarded(badgeId, recipients[i]);
            }
        }
    }

    function setManager(address manager, bool status) external onlyOwner {
        managers[manager] = status;
        emit ManagerUpdated(manager, status);
    }

    function getUserBadges(address user) external view returns (uint256[] memory) {
        return userBadges[user];
    }

    function getBadgeInfo(uint256 badgeId) external view returns (Badge memory) {
        return badges[badgeId];
    }

    function _hasBadge(address user, uint256 badgeId) internal view returns (bool) {
        uint256[] memory userBadgeList = userBadges[user];
        for (uint256 i = 0; i < userBadgeList.length; i++) {
            if (userBadgeList[i] == badgeId) {
                return true;
            }
        }
        return false;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(badges[tokenId].createdAt > 0, "Badge does not exist");
        return badges[tokenId].imageURI;
    }

    // Prevent transfers - badges are soulbound
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        require(from == address(0), "Badges are non-transferable");
        return super._update(to, tokenId, auth);
    }
}
