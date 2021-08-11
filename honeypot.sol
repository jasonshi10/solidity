pragma solidity ^0.4.0;

contract Lottery {
    uint luckyNumber = 52;
    struct Guess {
        address player;
        uint number;
    }

    Guess[] public guessHistory;
    function guess(uint _num) public payable {
        Guess newGuess;
        newGuess.player = msg.sender;
        newGuess.number = _num;
        guessHistory.push(newGuess);
        if(_num == luckyNumber) {
            msg.sender.transfer(msg.value * 2);
        }
    }

    function() public payable{}
}
