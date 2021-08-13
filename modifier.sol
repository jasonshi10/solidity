pragma solidity ^0.4.0;

contract Purchase {
    address public seller;
    constructor() public{
        seller = msg.sender;
    }
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call");
        _;
    }
    function abort() public view onlySeller returns(uint) {
        return 100;
    }
}
