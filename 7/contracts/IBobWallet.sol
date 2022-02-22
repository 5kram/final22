// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

interface BobWallet {
    function pay(address dest, uint amount) external payable;
}
