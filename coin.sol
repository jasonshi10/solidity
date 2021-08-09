pragma solidity ^0.4.22;

contract Coin {
    mapping(address => uint) public balances;
    event Sent(address from, address to, uint amount);
    constructor(uint initialSupply) public {
        initialSupply = balances[msg.sender];
    }

    function send(address receiver, uint amount) public returns(bool success) {
        require(balances[msg.sender] >= amount);
        require(balances[receiver] + amount >= balances[receiver]);
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        return true;
        emit Sent(msg.sender, receiver, amount);
    }
}
