// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

contract MovieToken {
    address payable public owner; // record the producer’s address
    mapping (address => uint256) public balances; // investor balances
    uint256 public totalSupply; // total supply in contract
    uint256 public lastWithdrawDate; // last withdrawal time
    
    constructor()  payable { // Constructor
        owner = payable(msg.sender);
        balances[owner] = msg.value; // The producer may fund the movie
        totalSupply = balances[owner];
    }

    function withdraw(uint256 amount) external { // note: function is not payable
        require(msg.sender == owner, "caller is not the owner"); // Only the producer may withdraw funds
        require(amount > 0 && amount <= address(this).balance, "amount can not be withdrawn");
        require(block.timestamp > lastWithdrawDate + (30 days), "owner can not withdraw more than once in a month"); // Only once per month
        lastWithdrawDate = block.timestamp;
        // Withdraw schedule: only withdraw 1 more ether than has ever
        // been withdrawn.
        uint256 maxAmount = (totalSupply - address(this).balance + (1 ether));
        require(amount <= maxAmount, "amount exceeds max amount to be withdrawn");
        (bool sent, ) = owner.call{value: amount}(""); // send the funds to the producer
        require(sent, "payment failed");
    }

    // Fallback function: record a fund-raise contribution
    receive() external payable {
        balances[msg.sender] += msg.value; // transfer tokens to investor
        totalSupply += msg.value; // record amount
    }
}