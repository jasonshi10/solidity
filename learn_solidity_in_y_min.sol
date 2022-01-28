// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;
// now, the basics of solidity

// 1. data types and associated methods
// uint used for currency amount (there are no doubles or floats) and for dates (in unix time)
uint x;

// int of 256 bits, cannot be changed after instantiation
int constant a = 8;
int256 constant a = 8; // same effect as line above, here the 256 is explicit
uint constant VERSION_ID = 0x123A1; // a hex constant
// with 'constant', compiler replaces each occurrence with actual value, save gas

// all state variables (those outside a function)
// are by default 'internal' and accessible inside contract
// and in all contracts that inherit ONLY
// need to explicitly set to 'public' to allow external contracts to access
int256 public a = 8;

// for int and uint, can explicitly set space in steps of 8 up to 256
// e.g. int8, int16, int24
uint8 b;
int64 c;
uint248 e;

// becareful that you don't overflow, and protect against attacks that do
// for example, for an addition, you'd do:
uint256 c = a + b;
assert(c >= a); // assert tests for internal invariants; require is used for user inputs

// type casting
int x = int(b);

bool b = true; // or do 'var b = true' for inferred typing

// addresses - holds 20 byte/160 bit ethereum addresses
// no arithmetic allowed
address public owner;

// types of accounts:
// contract account: address set on create (func of creator address, num transactions set)
// external account: (person/external entity): address created from public key
// and 'public' field to indicate publicly/externally accessible
// a getter is automatically created, but not a setter

// all addresses can be sent ether
owner.transfer(SOME_BALANCE); // fails and reverts on failure

// can also do a lower level .send call, which returns a false if it failed
if (owner.send) {} // REMEMBER: wrap send in 'if' as contract addresses have
// functions executed on send and these can fail
// also, make sure to deduct balances BEFORE attempting a send, as there is a risk of a recursive
// call that can drain the contract

// can check balance
owner.balance; // the balance of the owner (user or contract)

// bytes available from 1 to 32
byte a; // byte is same as bytes1
bytes2 b;
bytes32 c;

// dynamically sized bytes
bytes m; // a special array, same as byte[] array (but packed tightly)
// more expensive than byte1-byte32, so use those when possible

// same as bytes, but does not allow length or index access (for now)
string n = "hello"; // stored in UTF8, note double quotes, not single
// string utility functions to be added in future
// prefer bytes32/bytes, as UTF8 uses more storage

// type inference
// var does inferred typing based on first assignment,
// can't be used in functions parameters
var a = true;
// use carefully, inference may provide wrong type
// e.g. an int8, when a counter needs to be int16

// var can be used to assign function to variable
function a(uint x) returns (uint) {
    return x * 2;
}
var f = a;
f(22); // call

// by default, all values are set to 0 on instantiation

// delete can be called on most types
// (does not destroy value, but sets value to 0, the initial value)
uint x = 5;

// destructuring/tuples
(x, y) = (2, 7); // assign/swap multiple values

// 2. data structures
// arrays
bytes32[5] nicknames; // static array
bytes32[] names; // dynamic array
uint newLength = names.push("John"); // adding returns new length of the array
// Length
names.length;  // get length
names.length = 1; // lengths can be set (for dynamic arrays in storage only)

// multidimensional array
uint[][5] x; // arr with 5 dynamic array elements (opp order of most languages)

// dictionaries (any type to any other type)
mapping (string => uint) public balances;
balances["charles"] = 1;
// balances["ada"] result is 0, all non-set key values return zeroes
// 'public' allows following from another contract
contractName.balances("charles"); // returns 1
// 'public' created a getter (but not setter) like the following:
function balances(string _account) returns (uint balance) {
    return balances[_account];
}

// nested mappings
mapping (address => mapping (address => uint)) public custodians;

// to delete
delete balances["John"];
delete balances; // sets all elements to 0

// unlike other languages, cannot iterate thru all elements in mapping
// without knowing source keys - can build data structure on top to do this

// Structs
struct Bank {
    address owner;
    uint balance;
}
Bank b = Bank({
    owner: msg.sender,
    balance: 5
});
// or
Bank c = Bank(msg.sender, 5);

c.balance = 5; // set to new value
delete b;
// sets to initial value, set all variables in struct to 0, except mappings

// enums
enum State { Created, Locked, Inactive }; // often used for state machine
State public state; // declare variable from enum
state = State.Created;
// enums can be explicitly converted to ints
uint createdState = uint(State.Created); // 0

/*
data locations: memory vs storage vs calldata - all complex types
(arrays, structs) have a data location.
memory does not persist, storage does.
default is storage for local and state variables, memory for func params
stack holds small local variables.
for most types, can explicitly set which data location to use.

3. simple operators
comparisons, bit operators and arithmetic operators are provided
exponentiation: **
*/

// 4. global variables of note
// ** this **
this; // address of contract
// often used at end of contract life to transfer remaining balance to party
this.balance;
this.someFunction(); // calls func externally via call, not via internal jump

// ** msg - current message received by the contract ** **
msg.sender; // address of sender
msg.value; // amount of ether provided to this contract in wei, the function should be marked "payable"
msg.data; // bytes, complete call data
msg.gas; // remaining gas

// ** tx - this transaction **
tx.origin; // address of sender of the trx
tx.gasprice; // gas price of the trx

// ** block - information about current block **
now; // current time (approximately), alias for block.timestamp (uses unix time)
// note that this can be manipulated by miners, so use carefully

block.number; // current block number
block.difficulty; // current block difficulty
block.blockhash(1); // returns bytes32, only works for most recent 256 blocks
block.gasLimit();

// ** storage - persistent storage hash **
storage['abc'] = 'def'; // maps 256 bit words to 256 bit words

// 4. functions and more
// A. functions
// simple function
function increment(uint x) returns (uint) {
    x += 1;
    return x;
}

// functions can return many arguments, and by specifying returned arguments
// name don't need to explicitly return
function increment(uint x, uint y) returns (uint x, uint y) {
    x += 1;
    y += 1;
}
// call previous function
uint (a,b) = increment(1,1);

// 'view' (alias for 'constant')
// indicates that function does not/cannot change persistent vars
// view function execute locally, not on blockchain
// notes: constant keyword will soon be deprecated.
uint y = 1;

function increment(uint x) view returns (uint x) {
    x += 1;
    y += 1;
    // y is a state variable, and cannot be changed in a view function
}

// 'pure' is more strict than 'view' and does not even allow reading of state variables
// the exact rules are more complicated so see the link here http://solidity.readthedocs.io/en/develop/contracts.html#view-functions

// function visibility specifiers
// these can be placed where 'view' is, including:
// public - visible external and internally (default for function)
// external - only visible externally (including a call made with this)
// private - only visible in the current contract
// internal - only visible in cureent contract, and those deriving from it

// generally, a good idea to mark each function explicitly

// functions hoisted - and can assign a function to a variable
function a() {
    var z = b;
    b();
}

function b() {

}

// all functions that receive ether must be marked 'payable'
function depositEther() public payable {
    balances[msg.sender] += msg.value;
}
