// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.6;
// a simple Bank contract
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


}
