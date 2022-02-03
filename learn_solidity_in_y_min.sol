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
// pure does not read anything from the blockchain whereas view can read data from blockchain
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

// prefer loops to recursion (max call stack depth is 1024)
// also, don't set up loops that you haven't bounded, as this can hit the gas limit

// b. events
// events are notify external parties; easy to search and access events from
// outside blockchain (with lightweight clients)
// typically declare after contract parameters

// typically, capitalized - and add log in front to be explicit and prevent confusion with a function call

// declare
event LogSent(address indexed from, address indexed to, uint amount); // note capital first letter

// call
LogSent(from, to, amount);

/**

for an external party (a contract or external entity), to watch using the web3 js library:

// The following is Javascript code, not Solidity code
Coin.LogSent().watch({}, '', function(error, result) {
    if (!error) {
        console.log("Coin transfer: " + result.args.amount +
            " coins were sent from " + result.args.from +
            " to " + result.args.to + ".");
        console.log("Balances now:\n" +
            "Sender: " + Coin.balances.call(result.args.from) +
            "Receiver: " + Coin.balances.call(result.args.to));
    }
}
**/

// common paradigm for one contract to depend on another (e.g. a contract that
// depends on current exchange rate provided by another

// c. modifiers
// modifiers validate inputs to functions such as minimal balance or user auth;
// similar to guard clause in other languages

// '_'(underscore) often included as last line in body, and indicates function being called should be placed there
modifier onlyAfter(uint _time) {
    require (now >= _time);
    _;
    }
modifier onlyOwner {
    require(msg.sender == owner);
    _;
}
modifier onlyIfStateA (State currState) {
    require(currState == State.A);
    _;
}

// append right after function declaration
function changeOwner(newOwner)
onlyAfter(someTime)
onlyOwner()
onlyIfState(State.A)
{
    owner = newOwner;
}

// underscore can be included before end of body
// but explicitly returning will skip, so use carefully
modifier checkValue(uint amount) {
    _;
    if (msg.value > amount) {
        uint amountToRefund = amount = msg.value;
        msg.sender.transfer(amountToRefund);
    }
}

// 6. branching and loops
// all basic logic blocks work - including if/else, for, while, break, continue
// return - but no switch

// syntax same as javascript, but no type conversion from non-boolean
// to boolean (comparison operators must be used to get the boolean val)

// for loops that are determined by user behavior, be careful - as contracts have
// a maximal amount of gas for a block of code - and will fail if that is exceeded
// for example:
for (uint x = 0; x < refundAddressList.length; x++) {
    refundAddressList[x].transfer(SOME_AMOUNT);
}

// two errors above:
// 1. a failure on transfer stops the loop from completing, tying up money
// 2. this loop could be arbitrarily long (based on the amount of users who need refunds), and
// therefore may always fail as it exceeds the max gas for a block
// instead, you should let people withdraw individually from their subaccount, and mark withdrawn
// e.g. favor pull payments over push payments

// 7. objects/contracts
// a. calling external contract
contract InfoFeed {
    function info() payable returns (uint ret) {
        return 42;
    }
}

contract Consumer {
    InfoFeed feed; // points to contract on blockchain

    // set feed to existing contract instance
    function setFeed (address addr) {
        feed = InfoFeed(addr);
    }

    // set feed to new instance of contract
    function createNewFeed() {
        feed = new InfoFeed(); // new instance created; constructor called
    }

    function callFeed() {
        // final parentheses call contract, can optionally add
        // custom ether value or gas
        feed.info.value(10).gas(800)();
    }
}

// b. inheritance

// order matters, last inherited contract (i.e., 'def')
// can override parts of previously inherited contracts
contract MyContract is abc, def("a custom argument to def") {

    // override function
    function z() {
        if (msg.sender == owner) {
            def.z(); // call overridden function from def
            super.z(); // call immediate parent overridden function
        }
    }
}

// abstract function
function someAbstractFunction(uint x);
// cannot be compiled, so used in base/abstract contracts
// that are then implemented

// c. import
import "filename";
import "github.com/ethereum/dapp-bin/library/iterable_mapping.sol";

// 8. other keywords

// a. selfdestruct
// selfdestruct current contract, sending funds to address (often creator)
selfdestruct(some_address);

// remove storage/code from current/future blocks
// helps think clients, but previous data persists in blockchain

// common pattern, lets owner end the contract and receive remaining funds
function remove() {
    if(msg.sender == creator) { // only let the contract creator do this
        selfdestruct(creator); // makes contract inactive, returns funds
    }
}

// may want to deactivate contract manually, rather than selfdestruct
// (ether sent to selfdestructed contract is lost)

// 9. contract design notes

// a. obfuscation
// all variables are publicly viewable on blockchain, so anything
// that is private needs to be obfuscated (e.g. hashed w/ secret)

// step 1: 1. commit to something, 2. reveal commitment
keccak256("some_bid_amnt", "some secret") // commit

// call contract's reveal function in the future
// showing bid plus secret that hashes to SHA3
reveal(100, "mySecret");

// b. storage optimization
// writing to blockchain can be expensive, as data stored forever; encourages
// smart ways tpo use memory (eventually, compilation will be better, but for now
// benefits to planning data structures - and storing min amount in blockchain)

// cost can often be high for items like multidimensional arrays
// (cost is for storing data - not declaring unfilled variables)

// c. data access in blockchain
// cannot restrict human or computer from reading contents of transaction or trasaction's state

// while 'private' prevents other *contracts* from reading data directly
// any other party can still read data in blockchain

// all data to start of time is stored in blockchain, so
// anyone can observe all previous data and changes

// e. Oracles and External Data
// Oracles are ways to interact with your smart contracts outside the blockchain.
// They are used to get data from the real world, send post requests, to the real world
// or vise versa.

// Time-based implementations of contracts are also done through oracles, as
// contracts need to be directly called and can not "subscribe" to a time.
// Due to smart contracts being decentralized, you also want to get your data
// in a decentralized manner, other your run into the centralized risk that
// smart contract design matter prevents.

// To easiest way get and use pre-boxed decentralized data is with Chainlink Data Feeds
// https://docs.chain.link/docs/get-the-latest-price
// We can reference on-chain reference points that have already been aggregated by
// multiple sources and delivered on-chain, and we can use it as a "data bank"
// of sources.

// You can see other examples making API calls here:
// https://docs.chain.link/docs/make-a-http-get-request

// And you can of course build your own oracle network, just be sure to know
// how centralized vs decentralized your application is.

// Setting up oracle networks yourself

// d. Cron Job
// Contracts must be manually called to handle time-based scheduling; can create external
// code to regularly ping, or provide incentives (ether) for others to
//

// E. Observer Pattern
// An Observer Pattern lets you register as a subscriber and
// register a function which is called by the oracle (note, the oracle pays
// for this action to be run)
// Some similarities to subscription in Pub/sub

// This is an abstract contract, both client and server classes import
// the client should implement
contract SomeOracleCallback {
    function oracleCallback(int _value, uint _time, bytes32 info) external;
}

contract SomeOracle {
    SomeOracleCallback[] callbacks; // array of all subscribers


    // register subscriber
    function addSubscriber(SomeOracleCallback a) {
        callbacks.push(a);
    }

    function notify(value, time, info) private {
        for (uint i = 0; i< callbacks.length; i++) {
            // all called subscribers must implement the oracleCallback
            callbacks[i].oracleCallback(value, time, info);
        }
    }

    function doSomething() public {
        // code to do something

        // notify all subscribers
        notify(_value, _time, _info);
    }
}

// now, your client contract can addSubscriber by importing SomeOracleCallback
// and registering with Some Oracle

// f. State machines
// see crowdfunding example for State enum and inState modifier

// 10. other native functions
// currency units
// currency is defined using wei, smallest uint of ether
uint minAmount = 1 wei;
uint a = 1 finney; // 1 ether == 1000 finney

// time units
1 == 1 second
1 minutes == 60 seconds

// can multiply a variable times unit, as units are not stored in a variable
uint x = 5;
(x * 1 days); // 5 days

// careful about leap seconds/years with equality statements for time
// (instead, prefer greater than/less than)

// cryptography
// all strings passed are concatenated before hash action
sha3("ab", "cd");
ripemd160("abc");
sha256("def");

// 11. SECURITY

// Bugs can be disastrous in Ethereum contracts - and even popular patterns in Solidity,
// may be found to be antipatterns

// See security links at the end of this doc

// 12. LOW LEVEL FUNCTIONS
// call - low level, not often used, does not provide type safety
successBoolean = someContractAddress.call('function_name', 'arg1', 'arg2');

// callcode - Code at target address executed in *context* of calling contract
// provides library functionality
someContractAddress.callcode('function_name');


// 13. STYLE NOTES
// Based on Python's PEP8 style guide
// Full Style guide: http://solidity.readthedocs.io/en/develop/style-guide.html

// Quick summary:
// 4 spaces for indentation
// Two lines separate contract declarations (and other top level declarations)
// Avoid extraneous spaces in parentheses
// Can omit curly braces for one line statement (if, for, etc)
// else should be placed on own line


// 14. NATSPEC COMMENTS
// used for documentation, commenting, and external UIs

// Contract natspec - always above contract definition
/// @title Contract title
/// @author Author name

// Function natspec
/// @notice information about what function does; shown when function to execute
/// @dev Function documentation for developer

// Function parameter/return value natspec
/// @param someParam Some description of what the param does
/// @return Description of the return value
