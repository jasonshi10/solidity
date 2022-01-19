// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;
// a simple bank contract
// allows deposits, withdrawals, and balance checks
contract SimpleBank {
    // declare state variables outside function. persist through life of contract

    // dictionary that maps addresses to balances
    // always be careful about overflow attacks with numbers
    mapping (address => uint) private balances;

    // private means that other contracts can't directly query balances
    // but data is still viewable to other parties on blockchain

    address public owner;
    // public makes externally readable (not writeable) by users or contracts

    // events - publicize actions to external listeners
    event LogDepositMade(address accountAddress, uint amount);

    // constructor, can receive one or many variables here; only one allowed
    constructor() public {
        // msg provides detals about the message that's sent to the contract
        // msg.sender is contract caller (address of contract creator)
        owner = msg.sender;
    }

    /// @notice deposit ether into bank
    /// @return the balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        // use 'require' to test user inputs, 'assert' for internal invariants
        // here we are making sure that there isn't an overflow issue
        require((balances[msg.sender] + msg.value) >= balances[msg.sender]);

        balances[msg.sender] += msg.value;
        // no "this." or "self." required with state variable
        // all values set to data type's initial value by default

        emit LogDepositMade(msg.sender, msg.value); // fire event

        return balances[msg.sender];
    }

    /// @notice withdraw ether from bank
    /// @dev this does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return remainingBal
    function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
        require(withdrawAmount <= balances[msg.sender]);

        // note the way we deduct the balance right away, before sending
        // every .transfer/.send from this contract can call an external function
        // this may allow the caller to request an amount greater
        // than their balance using a recursive call
        // aim to commit state before calling external functions, including .transfer/.send
        balances[msg.sender] -= withdrawAmount;

        // this automatically throws on a failure, which means the updated balance is reverted
        msg.sender.transfer(withdrawAmount);

        return balances[msg.sender];
    }

    /// @notice get balance
    /// @return the balance of the user
    // 'view' (ex: constant) prevents function from editing state variables
    // allows function to run locally/off blockchain
    function balance() view public returns (uint) {
        return balances[msg.sender];
    }

}
