// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

contract BobWallet {
    address HardcodedBobAddress;

    constructor() payable {
        HardcodedBobAddress = msg.sender;
    }

    function pay(address dest, uint amount) external payable {
        if (tx.origin == HardcodedBobAddress) {
            (bool sent, ) = dest.call{value: amount}("");
            require(sent, "payment failed");
        }
    }

    function balanceOfBob() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}

}