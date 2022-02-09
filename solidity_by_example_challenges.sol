// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    string public greet = "Hello World";
}

contract ValueTypes {
    bool public b = true;
    uint public u = 123; //uint = uint256 0 to 2^256 - 1, positive number only
    int public i = -123; // int = int256 -2^255 to 2^255 - 1
    int public minInt = type(int).min;
    int public maxInt = type(int).max;
    address public addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    bytes32 public b32 = 0x89c58ced8a9078bdef2bb60f22e58eeff7dbfed6c2dff3e7c508b629295926fa;


}

contract FunctionIntro {
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }

    function sub(uint x, uint y) external pure returns (uint) {
        return x - y;
    }
}

contract StateVariables {
    uint public num;

    function setNum(uint _num) external {
        num = _num;
    }

    function resetNum() external {
        num = 0;
    }

    // What is "view"?
    // "view" tells Solidity that this is a read-only function.
    // It does not make any updates to the blockchain.
    function getNumPlusOne() external view returns (uint) {
        return num + 1;
    }
}

contract LocalVariables {

    function mul() external pure returns (uint) {
        uint x = 123456;
        return x * x;
    }
}

contract GlobalVariables {

    // view function is similar to pure but it can read from state and global variables
    // msg.sender is a global variables stores the address that called the function
    // block.timestamp is current timestamp, type is uint
    // block.number is current block num, type is uint
    function returnSender() external view returns(address) {
        return msg.sender;
    }
    function globalVars() external {
        // address that called this function
        address sender = msg.sender;
        // timestamp (in seconds) of current block
        uint timeStamp = block.timestamp;
        // current block number
        uint blockNum = block.number;
        // hash of given block
        // here we get the hash of the current block
        // WARNING: only works for 256 recent blocks
        bytes32 blockHash = blockhash(block.number);
    }
}

/*
Functions that do not write anything to blockchain can be declared as view or pure.

What's the difference between view and pure?

view functions can read state and global variables.

pure functions cannot read neither state nor global variables.
*/
