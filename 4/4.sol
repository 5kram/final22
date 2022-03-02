// SPDX-License-Identifier: MIT

pragma solidity ^0.4.0;

contract TicTacToe {
    // game configuration
    address[2] _playerAddress; // address of both players
    uint32 _turnLength; // max time for each turn
    // nonce material used to pick the first player
    bytes32 _p1Commitment;
    uint8 _p2Nonce;
    // game state
    uint8[9] _board; // serialized 3x3 array
    uint8 _currentPlayer; // 0 or 1, indicating whose turn it is
    uint256 _turnDeadline; // deadline for submitting the next move

    // Create a new game, challenging a named opponent.
    // The value passed in is the stake which the opponent must match.
    // The challenger commits to its nonce used to determine first mover.
    function TicTacToe(address opponent, uint32 turnLength, bytes32 p1Commitment) {
        _playerAddress[0] = msg.sender;
        _playerAddress[1] = opponent;
        _turnLength = turnLength;
        _p1Commitment = p1Commitment;
    }

    // Join a game as the second player.
    function joinGame(uint8 p2Nonce) {
        // only the specified opponent may join
        if (msg.sender != _playerAddress[1]) throw;
        // must match player 1's stake.
        if (msg.value < this.balance) throw;
        _p2Nonce = p2Nonce;
    }

    // Start the game by revealing player 1's nonce to choose who goes first.
    function startGame(uint8 p1Nonce) {
        // must open the original commitment
        if (sha3(p1Nonce) != _p1Commitment) throw;
        // XOR both nonces and take the last bit to pick the first player
        _currentPlayer = (p1Nonce ^ _p2Nonce) & 0x01;
        // start the clock for the next move
        _turnDeadline = block.number + _turnLength;
    }

    // Submit a move
    function playMove(uint8 squareToPlay) {
        // make sure correct player is submitting a move
        if (msg.sender != _playerAddress[_currentPlayer]) throw;
        // claim this square for the current player.
        _board[squareToPlay] = _currentPlayer;
        // If the game is won, send the pot to the winner
        if (checkGameOver())
        suicide(msg.sender);
        // Flip the current player
        _currentPlayer ^= 0x1;
        // start the clock for the next move
        _turnDeadline = block.number + _turnLength;
    }

    // Default the game if a player takes too long to submit a move
    function defaultGame() {
        if (block.number > _turnDeadline)
        suicide(msg.sender);
    }
}