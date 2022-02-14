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

contract FunctionOutputs {
    // Functions can return multiple outputs.
    function returnMany() public pure returns (uint, bool) {
        return (1, true);
    }

    // Outputs can be named.
    function named() public pure returns (uint x, bool b) {
        return (1, true);
    }

    // Outputs can be assigned to their name.
    // In this case the return statement can be omitted.
    function assigned() public pure returns (uint x, bool b) {
        x = 1;
        b = true;
    }

    // Use destructuring assignment when calling another
    // function that returns multiple outputs.
    function destructuringAssigments() public pure {
        (uint i, bool b) = returnMany();

        // Outputs can be left out.
        (, bool bb) = returnMany();
    }

    function myFunc() external view returns(address, bool) {
        return (msg.sender, false);
    }
}

/*
Arrays can have fixed or dynamic size. Fixed size arrays can be initialized in memory.

Arrays have several functionalities.

push - Push new element to the end of the array.
pop - Remove last element from the end of the array, shrink array length by 1.
length - Current length of array.
*/
contract ArrayBasic {
    // Several ways to initialize an array
    uint[] public arr;
    uint[] public arr2 = [1, 2, 3];
    // Fixed sized array, all elements initialize to 0
    uint[3] public arrFixedSize;

    // Insert, read, update and delete
    function examples() external {
        // Insert - add new element to end of array
        arr.push(1);
        // Read
        uint first = arr[0];
        // Update
        arr[0] = 123;
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[0];

        // pop removes last element
        arr.push(1);
        arr.push(2);
        // 2 is removed
        arr.pop();

        // Get length of array
        uint len = arr.length;

        // Fixed size array can be created in memory
        uint[] memory a = new uint[](3);
        // push and pop are not available
        // a.push(1);
        // a.pop(1);
        a[0] = 1;
    }

    function get(uint i) external view returns (uint) {
        return arr[i];
    }

    function push(uint x) external {
        arr.push(x);
    }

    function remove(uint i) external {
        delete arr[i];
    }

    function getLength() external view returns(uint) {
        return arr.length;
    }
}

// Mappings are like hash tables or dictionary in Python, they are useful for fast efficient lookups.
contract MappingBasic {
    // Mapping from address to uint used to store balance of addresses
    mapping(address => uint) public balances;

    // Nested mapping from address to address to bool
    // used to store if first address is a friend of second address
    mapping(address => mapping(address => bool)) public isFriend;

    function examples() external {
        // Insert
        balances[msg.sender] = 123;
        // Read
        uint bal = balances[msg.sender];
        // Update
        balances[msg.sender] += 456;
        // Delete
        delete balances[msg.sender];

        // msg.sender is a friend of this contract
        isFriend[msg.sender][address(this)] = true;
    }

    function get(address _addr) external view returns (uint) {
        return balances[_addr];
    }

    function set(address _addr, uint _val) external {
        balances[_addr] = _val;
    }

    function remove(address _addr) external {
        delete balances[_addr];
    }
}

// Structs allow data to be grouped together.
contract StructExamples {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car[] public cars;

    function examples() external {
        // 3 ways to initialize a struct
        Car memory toyota = Car("Toyota", 1980, msg.sender);
        Car memory lambo = Car({
            model: "Lamborghini",
            year: 1999,
            owner: msg.sender
        });
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2020;
        tesla.owner = msg.sender;

        // Push to array
        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);
        // Initialize and push in single line of code
        // it is the same as initialize Car Ferrari in memory first
        cars.push(Car("Ferrari", 2000, msg.sender));

        // Get reference to Car struct stored in the array cars at index 0
        Car storage car = cars[0];
        // Update
        car.year = 1988;
        // delete
        delete car.year;

        delete cars[1];
    }

    function register(string memory _model, uint _year) external {
        cars.push(Car({model: _model, year: _year, owner: msg.sender}));
    }

    function get(uint _index)
        external
        view
        returns (
            string memory model,
            uint year,
            address owner
        )
    {
        Car memory car = cars[_index];
        return (car.model, car.year, car.owner);
    }

    function transfer(uint _index, address _owner) external {
        cars[_index].owner = _owner;
    }
}

// Solidity supports enumerables and they are useful to model choice and to keep track of state.
contract EnumExamples {
    // Enum representing shipping status
    enum Status {
        // No shipping request
        None,
        Pending,
        Shipped,
        // Accepted by receiver
        Completed,
        // Rejected by receiver (damaged, wrong item, etc...)
        Rejected,
        // Canceled before shipped
        Canceled
    }

    Status public status;

    struct Order {
        address buyer;
        Status status;
    }

    Order[] public orders;

    // Returns uint
    // None      - 0
    // Pending   - 1
    // Shipped   - 2
    // Completed - 3
    // Rejected  - 4
    // Canceled  - 5
    function get() external view returns (Status) {
        return status;
    }

    // Update
    function set(Status _status) external {
        status = _status;
    }

    // Update to a specific enum
    function cancel() external {
        status = Status.Canceled;
    }

    // Reset enum to it's default value, 0
    function reset() public {
        delete status;
    }

    function ship() public {
        status = Status.Shipped;
    }
}

/*
Data locations
Variables are stored in one of three places.

storage - variable is a state variable (store on blockchain).
memory - variable is in memory and it exists temporary during a function call
calldata - special data location that contains function arguments

use storage for dynamic data you will update.
use memory if you only need to read data or modify it without saving it on the blockchain
use calldata for function inputs, saves gas by avoiding copies

Difference between memory and calldata

calldata is like memory but not modifiable. calldata saves gas.
*/
contract DataLocations {
    // Data locations of state variables are storage
    uint public x;
    uint public arr;

    struct MyStruct {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;

    // Example of calldata inputs, memory output
    function examples(uint[] calldata y, string calldata s)
        external
        returns (uint[] memory)
    {
        // Store a new MyStruct into storage
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        // Get reference of MyStruct stored in storage.
        MyStruct storage myStruct = myStructs[msg.sender];
        // Edit myStruct
        myStruct.text = "baz";

        // Initialize array of length 3 in memory
        uint[] memory memArr = new uint[](3);
        memArr[1] = 123;
        return memArr;
    }

    function set(address _addr, string calldata _text) external {
        MyStruct storage myStruct = myStructs[_addr];
        myStruct.text = _text;
    }

    function get(address _addr) external view returns (string memory) {
        return myStructs[_addr].text;
    }
}
