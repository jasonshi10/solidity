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

contract ViewAndPureFunctions {
    uint public num;

    // This is a view function. It reads the state variable "num"
    function viewFunc() external view returns (uint) {
        return num;
    }

    // This is a pure function. It does not read any state or global variables.
    function pureFunc() external pure returns (uint) {
        return 1;
    }

    function addToNum(uint x) external view returns (uint) {
        return num + x;
    }

    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }
}

contract Counter {
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}

contract DefaultValues {
    int public i; // 0
    bytes32 public b32; // 0x0000000000000000000000000000000000000000000000000000000000000000 64 0s after 0x
    address public addr; // 0x0000000000000000000000000000000000000000 40 0s after 0x
    uint public u;
    bool public b;
}

/*
State variables can be declared as constant. Value of constant variables must be set before compilation and it cannot be modified after the contract is compiled.
Why use constants?

Compared to state variables, constant variables use less gas.

Style guide: Following convention, constants should be named with all capital letters with underscore separating words.
*/

contract Constants {
    // declare state variables as constant
    address public constant MY_ADDR =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint public constant MY_UINT = 123;
}

contract IfElse {
    function ifElse(uint _x) external pure returns (uint) {
        if (_x < 10) {
            return 1;
        } else if (_x < 20) {
            return 2;
        } else {
            return 3;
        }
    }

    function ternaryOperator(uint _x) external pure returns (uint) {
        // condition ? value to return if true : value to return if false
        return _x > 1 ? 10 : 20;
    }

    function exercise_1(uint _x) external pure returns (uint) {
        if (_x > 0) {
            return 1;
        }
        return 0;
    }

    function exercise_2(uint _x) external pure returns (uint) {
        return _x > 0 ? 1 : 0;
    }
}

contract ForAndWhileLoops {
    function loop() external pure {
        // for loop
        for (uint i = 0; i < 10; i++) {
            if (i == 3) {
                // Skip to next iteration with continue
                continue;
            }
            if (i == 5) {
                // Exit loop with break
                break;
            }
        }

        // while loop
        uint j;
        while (j < 10) {
            j++;
        }
    }

    function sum(uint _n) external pure returns (uint) {
        uint s;
        for (uint i = 1; i <= _n; i++) {
            s += i;
        }
        return s;
    }
}

/*
Solidity has 3 ways to throw an error, require, revert and assert.

require is used to validate inputs and check conditions before and after execution.
revert is like require but more handy when the condition to check is nested in several if statements.
assert is used to check invariants, code that should never be false. Failing assertion probably means that there is a bug.

An error will undo all changes made during a transaction.
*/
contract ErrorHandling {
    function testRequire(uint _i) external pure {
        // Require should be used to validate conditions such as:
        // - inputs
        // - conditions before execution
        // - return values from calls to other functions
        require(_i <= 10, "i > 10");
    }

    function testRevert(uint _i) external pure {
        // Revert is useful when the condition to check is complex
        // Use revert when there are multiple if statements
        // This code does the exact same thing as the example above
        if (_i > 10) {
            revert("i > 10");
        }
    }

    uint num;

    function testAssert() external view {
        // Assert should only be used to test for internal errors,
        // and to check invariants.

        // Here we assert that num is always equal to 0
        // since it is impossible to update the value of num
        assert(num == 0);
    }

    function div(uint x, uint y) external pure returns (uint) {
        require( y > 0, 'div by 0');
        return x / y;
    }
}

/*
Function modifiers are reuseable code that can be run before and / or after a function call.

Here are some examples of how they are used.

1. Restrict access
2. Validate inputs
3. Check states right before and after a function call

*/
contract FunctionModifier {
    bool public paused;
    uint public count;

    // Modifire to check if not paused
    modifier whenNotPaused() {
        require(!paused, "paused");
        // Underscore is a special character only used inside
        // a function modifier and it tells Solidity to
        // execute the rest of the code.
        _;
    }

    function setPause(bool _paused) external {
        paused = _paused;
    }

    // This function will throw an error if paused
    function inc() external whenNotPaused {
        count += 1;
    }

    function dec() external whenNotPaused {
        count -= 1;
    }

    modifier whenPaused() {
        require(paused, "not paused");
        _;
    }

    function reset() external whenPaused {
        count = 0;
    }

    // Modifiers can take inputs.
    // Here is an example to check that x is < 10
    modifier cap(uint _x) {
        require(_x < 10, "x >= 10");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x) {
        count += _x;
    }

    // Modifiers can execute code before and after the function.
    modifier sandwich() {
        // code here
        _;
        // more code here
    }
}

/*
constructor is a special function that is called only once when the contract is deployed.
constructor is only called once and when the contract is deployed. You can set value in Deploy() tab in metamask.
The main purpose of the the constructor is to set state variables to some initial state.
*/

contract ConstructorIntro {
    address public owner;
    uint public x;

    constructor(uint _x) {
        // Here the owner is set to the caller
        owner = msg.sender;
        x = _x;
    }
}

/*
Create a contract that has an owner and only the owner can assign a new owner.
*/

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "not owner");
        _;
    }

    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "new owner = zero address");
        owner = _newOwner;
    }
}
