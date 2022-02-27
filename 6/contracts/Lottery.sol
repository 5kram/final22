// SPDX-License-Identifier: MIT

pragma solidity 0.8.12;

contract Lottery {
    address stateOfCali;
    uint256 ticketPrice = 0.1 ether;
    address[] participants;
    uint256 lotteryEpoch;

    modifier onlyState() {
        require(msg.sender == stateOfCali);
        _;
    }

    constructor() {
        stateOfCali = msg.sender;
        lotteryEpoch = block.timestamp + 7 days;
    }

    function buyTicket() external payable {
        require(msg.value == ticketPrice);
        participants.push(msg.sender);
    }

    function doLottery() external onlyState returns (bool) {
        require(block.timestamp > lotteryEpoch && block.timestamp < lotteryEpoch + 10 minutes);
        lotteryEpoch += 7 days;
        uint256 winnerId = uint256(blockhash(block.number)) % (2 * participants.length);
        
        if (winnerId >= participants.length) { 
            delete participants;
            return false;
        }
        
        uint256 amount = address(this).balance * 90 / 100;
        (bool sent, ) = participants[winnerId].call{value: amount}("");
        require(sent, "payment failed");
        
        delete participants;
        return true;
    }
}
