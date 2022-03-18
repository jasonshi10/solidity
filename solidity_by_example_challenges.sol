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


contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({text: _text, completed: false}));
    }

    function updateText(uint _index, string calldata _text) external {
        todos[_index].text = _text;
    }

    function toggleCompleted(uint _index) external {
        todos[_index].completed = !todos[_index].completed;
    }

    function get(uint _index) external view returns(string memory, bool) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }


}


contract IterableMapping {
    mapping(address => uint) public balances;
    // to keep track of the size of the mapping and if the key is inserted or not
    mapping(address => bool) public inserted;
    // you can't get the size of a mapping, so create an array to keep track of addresses (also as the keys to the mapping)
    address[] public keys;

    function set(address _addr, uint _bal) external {
        balances[_addr] = _bal;

        if (!inserted[_addr]) {
            inserted[_addr] = true;
            keys.push(_addr);
        }
    }

    function get(uint _index) external view returns (uint) {
        address key = keys[_index];
        return balances[key];
    }

    function first() external view returns (uint) {
        return balances[keys[0]];
    }

    function last() external view returns (uint) {
        return balances[keys[keys.length - 1]];
    }
}

// delete does not remove the element from the list (only reset it to 0),
// so use pop instead
contract ArrayShift {
    uint[] public arr = [1, 2, 3];

    function remove(uint _index) external {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[i + 1];
        }
        arr.pop();

    }
}


// more gas efficient way of shrinking an array,
// replace the index with the last element and pop the last element
contract ArrayReplaceLast {
    uint[] public arr = [1, 2, 3, 4];

    function remove(uint _index) external {
        arr[_index] = arr[arr.length - 1];
        arr.pop();
    }
}

/*
events allow smart contracts to log data to the blockchain without using state variables.
events are commonly used for debugging, monitoring and a cheap alternative to state variables for storing data.
only up to 3 parameters can be indexed
*/
contract Event {
    event Log(string message, uint val);
    // Up to 3 parameters can be indexed
    event IndexedLog(address indexed sender, uint val);

    function examples() external {
        emit Log("Foo", 123);
        emit IndexedLog(msg.sender, 123);
    }

    event Message(address indexed _from, address indexed _to, string _message);

    function sendMessage(address _addr, string calldata _message) external {
        emit Message(msg.sender, _addr, _message);
    }

}

/*
inheritance - override
contracts can inherit other contract by using the is keyword.
function that can be overridden by a child contract must declare virtual.
function that is overriding a parent function must declare override.
*/
contract A {
    // foo() can be overridden by child contract
    function foo() public pure virtual returns (string memory) {
        return "A";
    }

    function bar() public pure virtual returns (string memory) {
        return "A";
    }
}

// Inherit other contracts by using the keyword 'is'.
contract B is A {
    // Overrides A.foo()
    function foo() public pure override returns (string memory) {
        return "B";
    }

    function bar() public pure override returns (string memory) {
        return "B";
    }
}

/*
Solidity supports multiple inheritance.
Order of inheritance is important.
You must list the parent contracts in the order from “most base-like” to “most derived”.
*/
contract X {
    function foo() public pure virtual returns (string memory) {
        return "X";
    }

    function bar() public pure virtual returns (string memory) {
        return "X";
    }
}

contract Y is X {
    // Overrides X.foo
    // Also declared as virtual, this function can be overridden by child contract
    function foo() public pure virtual override returns (string memory) {
        return "Y";
    }

    function bar() public pure virtual override returns (string memory) {
        return "Y";
    }
}

// Order of inheritance - most base-lke to derived
contract Z is X, Y {
    // Overrides both X.foo and Y.foo
    function foo() public pure override(X, Y) returns (string memory) {
        return "Z";
    }

    function bar() public pure override(X, Y) returns (string memory) {
        return "Z";
    }
}

// Calling Parent Constructors
// There are 2 ways to pass parameters into parent constructors.
contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// 2 ways to call parent constructors
contract U is S("S"), T("T") {

}
// Order of execution, regardless the order of S or T in the constructor
// 1. S
// 2. T
// 3. V
contract V is S, T {
    // Pass the parameters here in the constructor,
    constructor(string memory _name, string memory _text) S(_name) T(_text) {}
}

// Order of execution
// 1. S
// 2. T
// 3. W
contract W is S("S"), T {
    constructor(string memory _text) T(_text) {}
}

/*
Calling Parent Functions
Parent contracts can be called directly, or by using the keyword super.
By using super, all immediate parent contracts will be called.
*/
contract E {
    // This event will be used to trace function calls.
    event Log(string message);

    function foo() public virtual {
        emit Log("E.foo");
    }

    function bar() public virtual {
        emit Log("E.bar");
    }
}

contract F is E {
    function foo() public virtual override {
        emit Log("F.foo");
        E.foo();
    }

    function bar() public virtual override {
        emit Log("F.bar");
        super.bar();
    }
}

contract G is E {
    function foo() public virtual override {
        emit Log("G.foo");
        E.foo();
    }

    function bar() public virtual override {
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F, G {
    function foo() public override(F, G) {
        // Calls G.foo() and then E.foo()
        super.foo();
    }

    function bar() public override(F, G) {
        super.bar();
    }
}

/*
Function Visibility

Functions and state variables must declare whether they are accessible by other contracts.

Fucntions can be declared as:

public - can be called by anyone and any contract
private - can only be called inside the contract
internal - can be called inside the contract and child contracts
external - can only be called from outside the contract

State variables can be declared as public, private, or internal but not external.
*/
contract VisibilityBase {
    // State variables can be one of private, internal or public.
    uint private x = 0;
    uint internal y = 1;
    uint public z = 2;

    // Private function can only be called
    // - inside this contract
    // Contracts that inherit this contract cannot call this function.
    function privateFunc() private pure returns (uint) {
        return 0;
    }

    // Internal function can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    function internalFunc() internal pure returns (uint) {
        return 100;
    }

    // Public functions can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    // - by other contracts and accounts
    function publicFunc() public pure returns (uint) {
        return 200;
    }

    // External functions can only be called
    // - by other contracts and accounts
    function externalFunc() external pure returns (uint) {
        return 300;
    }

    function examples() external view {
        // Access state variables
        x + y + z;

        // Call functions, cannot call externalFunc()
        privateFunc();
        internalFunc();
        publicFunc();

        // Actually you can call an external function with this syntax.
        // This is bad code.
        // Instead of making an internal call to the function, it does an
        // external call into this contract. Hence using more gas than necessary.
        this.externalFunc();
    }
}

contract VisibilityChild is VisibilityBase {
    function examples2() external view {
        // Access state variables (internal and public)
        y + z;

        // Call functions (internal and public)
        internalFunc();
        publicFunc();
    }

    function test() external view returns (uint) {
        return y + z + internalFunc() + publicFunc();
    }
}

/*
Immutable variables
Variables declared immutable are like constants, except their value can be set inside the constructor.
immutable is like constant except you can only initialize it once when the contract is deployed.
*/
contract Immutable {
    // Write your code here
    address public immutable owner;
    constructor() {
        owner = msg.sender;
    }
}

/*
Payable
Functions and addresses declared as payable can receive Ether.
*/
contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }
    // be able to sesnd eth when call this function
    function deposit() payable external {}
}

/*
fallback is a function that is called when a function to call does not exist.

For example, call doesNotExist(), this will trigger the fallback function.
Receive Ether

fallback function declared as external payable is commonly used to enable the contract to receive Ether.

There is a slight variation of the fallback called receive.

receive() external payable is called if msg.data is empty.
Which is called, fallback or receive?

Here is a graph summarizing which function is called:

Which function is called, fallback() or receive()?

    Ether is sent to contract
               |
        is msg.data empty?
              / \\
            yes  no
            /     \\
receive() exists?  fallback()
         /   \\
        yes   no
        /      \\
    receive()   fallback()
*/

contract Fallback {
    string[] public answers = ["receive", "fallback"];

    fallback() external payable {}

    receive() external payable {}
}

/*
Ether can be sent from a contract to another address in 3 ways, transfer, send and call.
How are transfer, send and call different?

transfer (forwards 2300 gas, throws error on failure)
send (forwards 2300 gas, returns bool)
call (forwards specified gas or defaults to all, returns bool and outputs in bytes)

call is the recommended method to use for security reasons.
*/
contract SendEther {
    // enable to contract to receive eth
    receive() external payable {}

    function sendViaTransfer(address payable _to) external payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) external payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) external payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }

    function sendEth(address payable _to, uint _amount) external {
        (bool sent, bytes memory data) = _to.call{value: _amount}("");
        require(sent, "failed to send ether");
    }
}

/*
A Contract Calling Another Contract
*/

import "./TestContract.sol";

contract CallTestContract {
    function setX(TestContract _test, uint _x) external {
        _test.setX(_x);
    }

    function setXfromAddress(address _addr, uint _x) external {
        TestContract test = TestContract(_addr);
        test.setX(_x);
    }

    function getX(address _addr) external view returns (uint) {
        uint x = TestContract(_addr).getX();
        return x;
    }

    function setXandSendEther(TestContract _test, uint _x) external payable {
        _test.setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(address _addr) external view returns (uint, uint) {
        (uint x, uint value) = TestContract(_addr).getXandValue();
        return (x, value);
    }

    function setXwithEther(address _addr) external payable {
        TestContract(_addr).setXtoValue{ value: msg.value }();
    }

    function getValue(address _addr) external view returns (uint) {
        return TestContract(_addr).getValue();
    }
}

/*
Interfaces enable a contract to call other contracts without having its code.
You know what functions you can call, so you define an interface to TestInterface.
*/

interface ITestInterface {
    function count() external view returns (uint);

    function inc() external;

    function dec() external;
}

// Contract that uses TestInterface interface to call TestInterface contract
contract CallInterface {
    function examples(address _test) external {
        ITestInterface(_test).inc();
        uint count = ITestInterface(_test).count();
    }

    function dec(address _test) external {
        ITestInterface(_test).dec();
    }
}

/*

*/
contract Call {
    function callFoo(address payable _addr) external payable {
        // You can send ether and specify a custom gas amount
        // returns 2 outputs (bool, bytes)
        // bool - whether function executed successfully or not (there was an error)
        // bytes - any output returned from calling the function
        (bool success, bytes memory data) = _addr.call{
            value: msg.value,
            gas: 5000
        }(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
        require(success, "tx failed");
    }

    // Calling a function that does not exist triggers the fallback function, if it exists.
    function callDoesNotExist(address _addr) external {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );
    }

    function callBar(address _addr) external {
        (bool success,) = _addr.call(
            abi.encodeWithSignature("bar(uint256,bool)", 123, true)
            );
        require(success, "tx failed");
    }
}

/*
delegatecall is like call, except the code of callee is executed inside the caller.

For example contract A calls delegatecall on contract B. Code inside B is executed using A's context such as storage, msg.sender and msg.value.
*/

// This is the contract that is called:
contract TestDelegateCall {
    // Storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }

    function setNum(uint _num) external {
        num = _num;
    }
}
// This is the delegatecall:
contract DelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        // This contract's storage is updated, TestDelegateCall's storage is not modified.
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        require(success, "tx failed");
    }

    function setNum(address _test, uint _num) external {
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        require(success, "tx failed");
    }
}
