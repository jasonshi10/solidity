// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract HelloWorld {
    string public greet = "Hello World! I'm Jason and I'm a Solidity Developer.";
}

contract Counter {
    uint public count;

    // Function to get the current count
    function get() public view returns (uint) {
        return count;
    }

    //Function to increment count by 1
    function inc() public {
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        count -= 1;
    }
}

contract Primitives {
    bool public boo = true;
    /*
    uint stands for unsigned integer, meaning non negative integers
    different sizes are available
        uint8 ranges from 0 to 2 ** 8 - 1
        uint16 ranges from 0 to 2 ** 16 - 1
        uint256 ranges from 0 to 2 ** 256 - 1
    */
    uint8 public u8 = 1;
    uint public u256 = 456;
    uint public u = 123;

    /*
    negative numbers are allowed for int types.
    like uint, different ranges are available from int8 to int256
    int256 ranges from -2 ** 255 to 2 ** 255 -1
    int128 ranges from -2 ** 127 to 2 ** 127 -1
    */

    int8 public i8 = -1;
    int public i256 = 456;
    int public i = -123; // int is same as int256

    // minimum and maximum of int
    int public minInt = type(int).min;
    int public maxInt = type(int).max;

    address public addr = 0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c;

    /*
    in solidity, the data type byte represent a sequence of bytes.
    solidity presents two types of bytes types:
    - fixed sized byte arrays
    - dynamically sized byte arrays

    the term bytes in solidity represents a dynamic array of bytes.
    it's a shorthand for byte[].
    */
    bytes1 a = 0xb5; // [10110101]
    bytes1 b = 0x56; // [01010110]

    // Default values
    // unassigned variables have a default value
    bool public defaultBoo;
    uint public defaultUint;
    int public defaultInt;
    address public defaultAddr;
}

/*
there are 3 types of variables in solidity
- local
-- declared inside a function
-- not stored on blockchain

- state
-- declared outside a function
-- stored on blockchain

- global
-- provides info about blockchain
*/
contract Variables {
    // state variables are stored on the blockchain
    string public text = "hello";
    uint public num = 42069;

    function doSomething() public {
        // local variables are not saved to the blockchain
        //uint i = 456;

        // here are some global variables
        //uint timestamp = block.timestamp; // current block timestamp
        //address sender = msg.sender; // address of the caller
    }
}

/*
constants are variables that cannot be modified.
their value is hard coded and using constants can SAVE GAS COST!
*/
contract Constants {
    // coding convention to uppercase constant variables
    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
    uint public constant MY_UINT = 1108;
}

/*
immutable variables are like constants.
values of immutable variables can be set inside the constructor but cannot be modified afterwards.
*/
contract Immutable {
    // coding convention to uppercase constant variables
    address public immutable MY_ADDRESS;
    uint public immutable MY_UINT;

    constructor(uint _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }
}

/*
to write or update a state variable you need to send a transaction.
on the other hand, you can read state variables, for free, without any transaction fee.
*/
contract UpdateStateVariable {
    // state variable to store a number
    uint public num;

    // you need to send a transaction to write to a state variable
    function set(uint _num) public {
        num = _num;
    }

    // you can read from a state variable without sending a transaction.
    function get() public view returns (uint) {
        return num;
    }
}

/*
transactions are paid with ether.
similar to how one dollar is equal to 100 cent, one ther is equal to 10^18 wei.
*/
contract EtherUnits {
    uint public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = 1 wei == 1;

    uint public oneEther = 1 ether;
    // 1 ether is equal to 10^18 wei
    bool public isOneEther = 1 ether == 1e18;
}

/*
how much gas do you need to pay for a trx?
you pay gas spent * gas price amount of ether, where
- gas is a unit of computation
- gas spent is the total amount of gas used in a trx
- gas price is how much ether you are willing to pay per gas
trx with higher gas price have higher priority to be included in a block
unspent gas will be refunded

gas limit
there are 2 upper bounds to the amount of gas you can spend
- gas limit (max amount of gas you're willing to use for your trx, set by you)
- block gas limit (max amount of gas allowed in a block, set by the network)
*/

contract Gas {
    uint public i = 0;

    // using up all of the gas that you send causes your trx to fail.
    // state changes are undone.
    // gas spent are not refunded.

    function forever() public {
        // here we run a loop until all of the gas are spent
        // and the trx fails
        while (true) {
            i += 1;
        }
    }
}

contract IfElse {
    function foo(uint x) public pure returns (uint) {
    if (x < 10) {
        return 0;
    } else if (x < 20) {
        return 1;
    } else {
        return 2;
    }
    }

    function ternary(uint _x) public pure returns (uint) {
        // if (_x < 10) {
        //     return 1;
        // }
        // return 2;

        //shorthand way
        return _x < 10 ? 1: 2;
    }
}

/*
Maps are created with the syntax mapping(keyType => valueType).
keyType can be value types such as uint, address or bytes.
valueType can be any type including another mapping or an array.
Mappings are not iterable.
*/

contract Mapping {
    // mapping from address to uint
    mapping(address => uint) public myMap;

    function get(address _addr) public view returns (uint) {
    // mapping always returns a value.
    // if the value was never set, it will return the default value.
    return myMap[_addr];
    }

    function set(address _addr, uint _i) public {
        // update the value at this address
        myMap[_addr] = _i;
    }

    function remove(address _addr) public {
        // reset the value to the default value.
        delete myMap[_addr];
    }

}

contract NestedMapping {
    // nested mapping (mapping from address to another mapping)
    mapping(address => mapping(uint => bool)) public nested;

    function get(address _addr1, uint _i) public view returns (bool) {
        // you can get values from a nested mapping
        // even when it is not initialized
        return nested[_addr1][_i];
    }

    function set(
        address _addr1,
        uint _i,
        bool _boo
    ) public {
        nested[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint _i) public {
        delete nested[_addr1][_i];
    }

}

/*
array can have a compile-time fixed size or a dynamic size
*/

contract Array {
    // several ways to initialize an array
    uint[] public arr;
    uint[] public arr2 = [1, 2, 3];

    // fixed sized array, all elements initialize to 0
    uint[10] public myFixedSizeArr;

    function get(uint i) public view returns (uint) {
        return arr[i];
    }

    // solidity can return the entire array.
    // but this function should be avoided for
    // arrays that can grow indefinitely in length.
    function getArr() public view returns (uint[] memory) {
        return arr;
    }

    function push(uint i) public {
        // append to array
        // this will increase the array length by 1
        arr.push(i);
    }

    function pop() public {
        // remove the last element, decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint) {
        return arr.length;
    }

    function remove(uint index) public {
        // delete does not change the array length.
        // it resets the value at index to its default value
        // in this case 0
        delete arr[index];
    }

//     function examples() external {
//         // create array in memory, only fixed size can be created
//         uint[] memory a = new uint[](5);
//     }
}

/*
examples of removing array element
remove array element by shifting elements from right to left
*/

contract ArrayRemoveByShifting {
    // [1, 2, 3] -- remove(1) --> [1, 3, 3] --> [1, 3]
    // [1, 2, 3, 4, 5, 6] -- remove(2) --> [1, 2, 4, 5, 6, 6] --> [1, 2, 4, 5, 6]
    // [1, 2, 3, 4, 5, 6] -- remove(0) --> [2, 3, 4, 5, 6, 6] --> [2, 3, 4, 5, 6]
    // [1] -- remove(0) --> [1] --> []
    uint [] public arr;

    function remove(uint _index) public {
        require(_index < arr.length, "index out of bound");

        for (uint i = _index; i < arr.length - 1; i++) {
            arr[i] = arr[ i + 1 ];
        }
        arr.pop();
    }

    function test() external {
        arr = [1, 2, 3, 4, 5];
        remove(2);
        // [1,2,4,5]
        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);

        arr = [1];
        remove(0);
        // []
        assert(arr.length == 0);
    }
}

/*
Enum
solidity supports enumerables and they are useful to model choice and keep track of state.
enums can be declared outside of a contract
*/

contract Enum {
    // enum representing shipping status
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    // default value is the first elemenet listed in
    // definition of the type, in this case "pending"
    Status public status;

    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4

    function get() public view returns (Status) {
        return status;
    }

    // update status by passing uint into input
    function set(Status _status) public {
        status = _status;
    }

    // you can update to a specific enum like this
    function cancel() public {
        status = Status.Canceled;
    }

    // delete resets the enum to its first value, 0
    function reset() public {
        delete status;
    }
}

/*
Structs
you can define your own type by creating a struct.
they are useful for grouping together related data.
Structs can be declared outside of a contract and imported in another contract.
*/

contract Todos {
    struct Todo {
        string text;
        bool completed;
    }

    // an array of 'todo' Structs
    Todo[] public todos;

    function create(string memory _text) public {
        // 3 ways to initialize a struct
        // - calling it like a function
        todos.push(Todo(_text, false));

        // key value mapping
        todos.push(Todo({text: _text, completed: false}));

        // initialize an empty struct and then update it
        Todo memory todo;
        todo.text = _text;

        // todo.completed initialized to false
        todos.push(todo);
    }

    // solidity automatically created a getter for 'todos'
    // so you don't actually need this function.
    function get(uint _index) public view returns (string memory text, bool completed) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // update text
    function update(uint _index, string memory _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completed
    function toggleCompleted(uint _index) public {
        Todo storage todo = todos[_index];
        todo.completed = ! todo.completed;
    }
}

/*
Data Locations - storage, memory and call data
variables are declared as either storage, memory or calldata to explicitly specify
the location of the data
- storage - variable is a state variable (store on blockchain)
- memory - variable is in memory and it exists while a function is being called
- calldata - special data location that contains function arguments, only available for external functions
*/

contract DataLocations {
    uint[] public arr;
    mapping(uint => address) map;
    struct MyStruct {
        uint foo;
    }
    mapping(uint => MyStruct) myStructs;
}

/*
Function
There are several ways to return outputs from a function:
public functions cannot accept certain data types as inputs or outputs
*/

contract Function {
    function returnMany()
        public
        pure
        returns (
            uint,
            bool,
            uint
        )
        {
            return (1, true, 2);
        }

        // Return values can be named.
        function named()
            public
            pure
            returns (
                uint x,
                bool b,
                uint y
            )
        {
            return (1, true, 2);
        }

        // return values can be assigned to their name.
        // In this case the return statement can be omitted.
        function assigned() public pure returns (uint x, bool b, uint y) {
            x = 1;
            b = true;
            y = 2;
        }

        // use destructing assignment when calling another
        // function that returns multiple values.
        function destructingAssigments() public pure returns (uint, bool, uint, uint, uint){
            (uint i, bool b, uint j) = returnMany();

            // values can be left out
            (uint x, , uint y) = (4, 5, 6);
            return (i, b, j, x, y);
        }

        // cannot use map for neither input nor output
        // can use array for input
        function arrayInput(uint[] memory _arr) public {}

        // can use array for output
        uint[] public arr;

        function arrayOutput() public view returns (uint[] memory) {
            return arr;
        }

}

/*
View and Pure functions
Getter functions can be declared view or pure.
View function declares that no state will be changed.
Pure function declares that no state variable will be changed or read.
*/

contract ViewAndPure {
    uint public x = 1;

    // promise not to modify the state.
    function addToX(uint y) public view returns (uint) {
        return x + y;
    }

    // promise not to modify or read from the state
    function add(uint i, uint j) public pure returns (uint) {
        return i + j;
    }
}

/*
Error
An error will undo all changes made to the state during a transaction.
You can throw an error by calling require, revert, or assert.
- require is used to validate inputs and conditions before execution.
- revert is similar to require. see code for details.
- assert is used to check for code that should never be false. falling assertion probably means that there's a bug.
Use custom error to save gas.
*/

contract Error {
    function testRequire(uint _i) public pure {
        // require should be used to validate conditions such as:
        // - inputs
        // - conditions before execution
        // - return values from calls to other functions
        require(_i > 10, "input must be greater than 10.");
    }

    function testRevert(uint _i) public pure {
    // revert is useful when the condition to check is complex.
    // this code does the exact same thing as the example above
    if (_i <= 10) {
        revert("input must be greater than 10");
        }
    }

    uint public num;

    function testAssert() public view {
        // assert should only be used to test for internal errors,
        // and to check invariants
        // here we assert that num is always equal to 0
        // since it is impossible to update the value of num
        assert(num == 0);
    }

    // custom error
    error InsufficientBalance(uint balance, uint withdrawAmount);

    function testCustomError(uint _withdrawAmount) public view {
        uint bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert InsufficientBalance({balance: bal, withdrawAmount: _withdrawAmount});
        }
    }
}

contract Account {
    uint public balance;
    uint public constant MAX_UINT = 2**256 - 1;

    function deposit(uint _amount) public {
        uint oldBalance = balance;
        uint newBalance = balance + _amount;

        // balance + _amount does not overflow if balance + _amount >= balance
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;

        assert(balance >= oldBalance);
    }

    function withdraw(uint _amount) public {
        uint oldBalance = balance;

        // balance - _amount does not underflow if balance >= _amount
        require(balance >= _amount, "Underflow");

        if (balance < _amount) {
            revert("Underflow");
        }

        balance -= _amount;

        assert(balance <= oldBalance);
    }
}

/*
Function Modifier

Modifiers are code that can be run before and / or after function call.
Modifiers can be used to:
- restrict access
- validate inputs
- guard against reentrancy hack
*/

contract FunctionModifier {
    // we will use these variables to demonstrate how to use
    // modifiers.

    address public owner;
    uint public x = 10;
    bool public locked;

    constructor() {
        // set the transaction sender as the owner of the contract.
        owner = msg.sender;
    }

    // modifier to check that the caller is the owner of the contract.
    modifier onlyOwner() {
        // set the transaction sender as the owner of the contract.
        require(msg.sender == owner, "Not owner");
        // underscore is a special character only used inside
        // a function modifier and it tells Solidity to execute the rest of the code.
        //when solidity finds -; it will execute the function. it is like a placeholder for functions execution.
        _;
    }

    // modifiers can take inputs. this modifier checks that the address passed in is not the zero address.
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner validAddress(_newOwner) {
        owner = _newOwner;
    }

    // modifiers can be called before and / or after a function.
    // this modifier prevents a function from being called while it is still executing.
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }

    function decrement(uint i) public noReentrancy {
        x -= i;

        if (i > 1) {
            decrement(i - 1);
        }
    }

}

/*
Events
Events allow logging to the ethereum blockchain. some use cases for events are:
- listening for events and updating user interface
- a cheap form of storage
*/
contract Event {
    // event declaration
    // up to 3 parameters can be indexed
    // indexed parameters helps you filter the logs by the indexed parameter
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello world");
        emit Log(msg.sender, "Hello EVM");
        emit AnotherLog();
    }
}

/*
Constructor
A constructor is an optional function that is executed upon contract creation
here are examples of how to pass arguments to constructors.
*/

// base contract X
contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// base contract y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// there are 2 ways to initialize parent contract with parameters.
// pass the parameters here in the inheritance list.
contract BXY is X("input to X"), Y("input to Y") {

}

contract CXY is X, Y {
    // pass the parameters here in the constructor,
    // similar to function modifiers.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// parent constructors are always called in the order of inheritance regardless of the order of inheritance
// regardless of the order of parent contracts listed in the constructor of the child contract.

// order of constructors called:
// 1. X
// 2. Y
// 3. DXY
contract DXY is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// order of constructors called:
// 1. X
// 2. Y
// 3. EXY
contract EXY is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}

/*
Inheritance
Solidity supports multiple inheritance. contracts can inherit other contract by using
'is' keyword. function that is going to be overridden by a child contract must be declared
as virtual. function that is going to override a parent function must use the keyword override.
order of inheritance is important.
you have to list the parent contract in the order from 'most base-like' to 'most derived'.
*/

/* Example Graph of inheritance
    A
   / \
  B   C
 / \ /
F  D,E

*/

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

// contracts inherit other contracts by using the keyword 'is'
contract B is A {
    // override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    // override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// contracts can inherit from multiple parent contracts.
// when a function is called that is defined multiple times in different contracts,
// parent contracts are searched from right to left, and in depth-first manner.

contract D is B, C {
    // D.fool() returns "C"
    // since C is the right most parent contract with function foo()
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

// inheritance must be ordered from "most base-like" to "most derived"
// swapping the order of A and B will throw a compilation error.

contract F is A, B {
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}

/*
Shadowing inherited state variables
unlike functions, state variables cannot be overridden by re-declaring it in the child contract.
let's learn how to correctly override inherited state variables.
*/
contract A_Inherit {
    string public name = "Contract A";

    function getName() public view returns (string memory) {
        return name;
    }
}

// shawdoing is disallowed in solidity 0.6
// this will not compile
// contract B is A {string public name = "Contract B"};
contract CA is A_Inherit {
    // this is the correct way to override inherited state variables.
    constructor() {
        name = "Contract C";
    }

    // CA.getName returns "Contract C"
}

/*
Calling parent contracts
parent contracts can be called directly, or by using the keyword super.
by using the keyword super, all of the immediate parent contracts will be called.

Inheritance tree
   AP
 /  \
BP   CP
 \ /
  DP
*/

contract AP {
    // this is called an event. you can emit events from your function
    // and they are logged into the transaction log
    // in our case, this will be useful for tracing function calls.
    event Log(string message);

    // Base functions can be overridden by inheriting contracts to change their behavior if they are marked as virtual.
    // The overriding function must then use the override keyword in the function header.

    function foo() public virtual {
        emit Log("AP.foo called");
    }

    function bar() public virtual {
        emit Log("AP.bar called");
    }
}

contract BP is AP {
    function foo() public virtual override {
        emit Log("BP.foo called");
        AP.foo();
    }
    //The super keyword in Solidity gives access to the immediate parent contract from which the current contract is derived.
    function bar() public virtual override {
        emit Log("BP.bar called");
        super.bar();
    }
}

contract CP is AP {
    function foo() public virtual override {
        emit Log("CP.fool called");
        AP.foo();
    }

    function bar() public virtual override {
        emit Log("CP.bar called");
        super.bar();
    }
}

contract DP is BP, CP {
    // try:
    // call DP.foo and check the transaction logs
    // although DP inherits AP BP and CP. it only called CP and then AP
    function foo() public override(BP, CP) {
        super.foo();
    }

    // try:
    // call DP.bar and check the transaction logs
    // DP called CP, then BP, and finally AP.
    // although super was called twice (by BP and CP) it only called A once.
    function bar() public override(BP, CP) {
        super.bar();
    }
}

/*
Visibility
functions and state variables have to declare whether they are accessible by other contracts.
Functions can be declared as
- public -> any contract and account can call
- private -> only inside the contract that defines the function
- internal -> only inside contract that inherits as an internal function
- external -> only other contracts and accounts can call
State variables can be declared as public, private, or internal but not external
*/
contract Base {
    // private function can only be called inside this contract
    // contracts that inherit this contract cannot call this function
    function privateFunc() private pure returns (string memory) {
        return "private function called";
    }

    function testPrivateFunc() public pure returns (string memory) {
        return privateFunc();
    }

    // internal function can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    function internalFunc() internal pure returns (string memory) {
        return "internal function called";
    }

    function testInternalFunc() public pure virtual returns (string memory) {
        return internalFunc();
    }

    // public function can be called
    // - inside this contract
    // - inside contracts that inherit this contract
    // - by other contracts and accounts
    function publicFunc() public pure returns (string memory) {
        return "public function called";
    }

    // external functions can only be called by other contracts and accounts
    function externalFunc() external pure returns (string memory) {
        return "external function called";
    }

    // this function will not compile since we're trying to call an external function here.
    // function testExternalFunc() public pure returns (string memory) { return externalFunc(); }

    // state variables
    string private privateVar = "my private variable";
    string internal internalVar = "my internal variable";
    string public publicVar = "my public variable";
    // state variables cannot be external so this code won't compile.
    // string external externalVar = "my external variable";
}

contract Child is Base {
    // inherited contracts do not have access to private functions and state variables
    // function testPrivateFunc() public pure returns (string memory) { return internalFunc(); }
    // internal function can be called inside child contracts.
    function testInternalFunc() public pure override returns (string memory) {
        return internalFunc();
    }
}

/*
Interface
you can interact with other contracts by declaring an Interface.
Interface
- cannot have any functions implemented
- can inherit from other interfaces
- all declared functions must be external
- cannot declare a constructor
- cannot declare state variables
*/
contract Counter_ {
    uint public count;

    function increment() external {
        count += 1;
    }
}

// declare an interface called ICounter
interface ICounter {
    function count() external view returns (uint);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}
// Uniswap example
interface UniswapV2Factory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface UniswapV2Pair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}

contract UniswapExample {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address private weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function getTokenReserves() external view returns (uint, uint) {
        address pair = UniswapV2Factory(factory).getPair(dai, weth);
        (uint reserve0, uint reserve1, ) = UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }
}

/*
Payable
functions and addresses declared payable can receive ether into the contract.
*/
contract Payable {
    // payable address can receive ether
    address payable public owner;

    // payable constructor can receive ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    // function to deposit ether into this contract.
    // call this function along with some ether.
    // the balance of this contract will be automatically updated.
    function deposit() public payable {}

    // call this function along with some Ether.
    // the function will throw an error since this function is not payable.
    function notPayable() public {}

    // function to withdraw all ether from this contract
    function withdraw() public {
    // get the amount of ether stored in this contract
    uint amount = address(this).balance;

    // send all ether to owner
    // owner can receive ether since the address of owner is payable
    (bool success, ) = owner.call{ value: amount }("");
    require(success, "failed to send ether");
    }

    // function to transfer ether from this contract to address from input
    function transfer(address payable _to, uint _amount) public {
        // note that "to" is declared as payable
        (bool success, ) = _to.call{value:_amount}("");
        require(success, "failed to send ether");
    }
}

/*
Sending Ether(transfer, send, call)
How to send ether?
you can send ether to other contracts by
- transfer (2300 gas, throws error)
- send (2300 gas, returns bool)
- call (foward all gas or set gas, returns bool)

How to receive ether?
a contract receiving ether must have at least one of the functions below
- receive() external payable
- fallback() external payable
receive() is called if msg.data is empty, otherwise fallback() is called.

Which method should you use?
call in combination with re-entrancy guard is the recommended method to use after Dec 2019
Guard against re-entrancy by
- making all state changes before calling other contracts
- using re-entrancy guard modifier
*/

contract ReceiveEther {
        /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // function to receive ether. msg.data must be empty
    receive() external payable {}

    // fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        // this function is no longer recommended for sending ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // send returns a boolean value indicating success or failure.
        // this function is not recommended for sending ether
        bool sent = _to.send(msg.value);
        require(sent, "failed to send ether");
    }

    function sendViaCall(address payable _to) public payable {
        // call returns a boolean value indicating success or failure.
        // this is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "failed to send ether");
    }
}

/*
Fallback
fallback is a function that does not take any arguments and does not return anything.
it is executed either when
- a function that does not exist is called or
- ether is sent directly to a contract but receive() does not exist or msg.data is not empty.
fallback has a 2300 gas limit when called by transfer or send.
*/
contract Fallback {
    event Log(uint gas);

    // fallback function must be declared as external
    fallback() external payable {
        // send / transfer (forward 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log(gasleft());
    }

    // helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.sender}("");
        require(sent, "faile to send ether);
    }
}
