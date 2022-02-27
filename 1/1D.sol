contract MovieToken {
    address owner; // record the producer’s address
    mapping (address => uint256) balances; // investor balances
    uint256 totalSupply; // total supply in contract
    uint256 lastWithdrawDate; // last withdrawal time
    uint256 balance;
    
    function MovieToken() { // Constructor
        owner = msg.sender;
        balances[owner] = msg.value; // The producer may fund the movie
        totalSupply = balances[owner];
        balance = msg.value;
    }

    function withdraw(uint256 amount) { // note: function is not payable
        if (msg.sender != owner) { throw; } // Only the producer may withdraw funds
        if (amount == 0 || amount > balance) { throw; }
        if (now < lastWithdrawDate + (1 months)) { throw; } // Only once per month
        lastWithdrawDate = now;
        // Withdraw schedule: only withdraw 1 more ether than has ever
        // been withdrawn.
        uint256 maxAmount = (totalSupply - balance + (1 ether));
        if (amount > maxAmount) { throw; }
        if (!owner.send(amount)) { throw; } // send the funds to the producer
        balance -= amount;
    }

    // Fallback function: record a fund-raise contribution
    function () payable {
        balances[msg.sender] += msg.value; // transfer tokens to investor
        totalSupply += msg.value; // record amount
        balance += msg.value
    }
}