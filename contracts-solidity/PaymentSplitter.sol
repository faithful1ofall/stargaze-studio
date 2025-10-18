// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract MiniutopiaPaymentSplitter is Ownable, ReentrancyGuard {
    string public name;
    
    address[] private _payees;
    mapping(address => uint256) private _shares;
    mapping(address => uint256) private _released;
    uint256 private _totalShares;
    uint256 private _totalReleased;
    
    event PaymentReleased(address indexed to, uint256 amount);
    event PaymentReceived(address indexed from, uint256 amount);
    event SplitterCreated(string name, address[] payees, uint256[] shares);

    constructor(
        string memory _name,
        address[] memory payees,
        uint256[] memory shares_
    ) Ownable(msg.sender) {
        require(payees.length == shares_.length, "Payees and shares length mismatch");
        require(payees.length > 0, "No payees");

        name = _name;

        for (uint256 i = 0; i < payees.length; i++) {
            require(payees[i] != address(0), "Invalid payee");
            require(shares_[i] > 0, "Shares must be > 0");
            require(_shares[payees[i]] == 0, "Duplicate payee");

            _payees.push(payees[i]);
            _shares[payees[i]] = shares_[i];
            _totalShares += shares_[i];
        }

        emit SplitterCreated(_name, payees, shares_);
    }

    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    function release(address payable account) external nonReentrant {
        require(_shares[account] > 0, "Account has no shares");

        uint256 payment = releasable(account);
        require(payment > 0, "Account is not due payment");

        _released[account] += payment;
        _totalReleased += payment;

        account.transfer(payment);
        emit PaymentReleased(account, payment);
    }

    function releasable(address account) public view returns (uint256) {
        uint256 totalReceived = address(this).balance + _totalReleased;
        return (totalReceived * _shares[account]) / _totalShares - _released[account];
    }

    function shares(address account) external view returns (uint256) {
        return _shares[account];
    }

    function released(address account) external view returns (uint256) {
        return _released[account];
    }

    function totalShares() external view returns (uint256) {
        return _totalShares;
    }

    function totalReleased() external view returns (uint256) {
        return _totalReleased;
    }

    function payees() external view returns (address[] memory) {
        return _payees;
    }
}
