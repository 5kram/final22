// SPDX-License-Identifier: MIT

pragma solidity ^0.4.0;

contract TicketDepot {
    struct Event {
        address owner;
        uint64 ticketPrice;
        uint16 ticketsRemaining;
        mapping(uint16 => address) attendees;
    }

    struct Offering {
        address buyer;
        uint64 price;
        uint256 deadline;
    }

    uint16 numEvents;
    address owner;
    uint64 transactionFee;
    mapping(uint16 => Event) events;
    mapping(bytes32 => Offering) offerings;

    function ticketDepot(uint64 _transactionFee) {
        transactionFee = _transactionFee;
        owner = tx.origin;
    }

    function createEvent(uint64 _ticketPrice, uint16 _ticketsAvailable)
        returns (uint16 eventID)
    {
        numEvents++;
        events[numEvents].owner = tx.origin;
        events[numEvents].ticketPrice = _ticketPrice;
        events[numEvents].ticketsRemaining = _ticketsAvailable;
        return numEvents;
    }

    modifier ticketsAvailable(uint16 _eventID) {
        _;
        if (events[_eventID].ticketsRemaining <= 0) throw;
    }

    function buyNewTicket(uint16 _eventID, address _attendee)
        payable
        ticketsAvailable(_eventID)
        returns (uint16 ticketID)
    {
        if (
            msg.sender == events[_eventID].owner ||
            msg.value > events[_eventID].ticketPrice + transactionFee
        ) {
            ticketID = events[_eventID].ticketsRemaining--;
            events[_eventID].attendees[ticketID] = _attendee;
            events[_eventID].owner.send(msg.value - transactionFee);
            return ticketID;
        }
    }

    function offerTicket(
        uint16 _eventID,
        uint16 _ticketID,
        uint64 _price,
        address _buyer,
        uint16 _offerWindow
    ) {
        if (msg.value < transactionFee) throw;
        bytes32 offerID = sha3(_eventID + _ticketID);
        if (offerings[offerID] != 0) throw;
        offerings[offerID].buyer = _buyer;
        offerings[offerID].price = _price;
        offerings[offerID].deadline = block.number + _offerWindow;
    }

    function buyOfferedTicket(
        uint16 _eventID,
        uint16 _ticketID,
        address _newAttendee
    ) payable {
        bytes32 offerID = sha3(_eventID + _ticketID);

        if (
            msg.value > offerings[offerID].price &&
            block.number < offerings[offerID].deadline &&
            (msg.sender == offerings[offerID].buyer ||
                offerings[offerID].buyer == 0)
        ) {
            events[_eventID].attendees[_ticketID].send(
                offerings[offerID].price
            );
            events[_eventID].attendees[_ticketID] = _newAttendee;
            delete offerings[offerID];
        }
    }
}
