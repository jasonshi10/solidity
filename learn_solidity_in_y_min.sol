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
