// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

contract MovieToken {
    address owner; // record the producer’s address
    mapping (address => uint256) balances; // investor balances
    uint256 totalSupply; // total supply in contract
    uint256 lastWithdrawDate; // last withdrawal time
    
    function MovieToken() { // Constructor
        owner = msg.sender;
        balances[owner] = msg.value; // The producer may fund the movie
        totalSupply = balances[owner];
    }

    function withdraw(uint256 amount) public { // note: function is not payable
        require(msg.sender == owner); // Only the producer may withdraw funds
        require(amount > 0 && amount <= address(this).balance);
        require(block.timestamp > lastWithdrawDate + (30 days)); // Only once per month
        lastWithdrawDate = block.timestamp;
        // Withdraw schedule: only withdraw 1 more ether than has ever
        // been withdrawn.
        uint256 maxAmount = (totalSupply - address(this).balance) + (1 ether));
        require(amount <= maxAmount);
        require(owner.send(amount)); // send the funds to the producer
    }

    // Fallback function: record a fund-raise contribution
    fallback () external payable {
        balances[msg.sender] += msg.value; // transfer tokens to investor
        totalSupply += msg.value; // record amount
    }
}