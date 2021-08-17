//SPDX-License-Identifier:MIT
pragma solidity ^0.8.6;

// create a ERC20 token that is allowed to be traded on DEXs like Uniswap
contract Token {
    //public means the variable can be read outside the smart contract
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public totalSupply;

    //mapping keeps track of key (address) and value
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // constructor executes when smartcontract is created
    constructor(string memory _name, string memory _symbol, uint _decimals, uint _totalSupply) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        //msg.sender corresponds who called the function. when we create the contract we will have all the tokens as the sender
        balanceOf[msg.sender] = totalSupply;
    }

    // internal function transfer can only be called by this contract
    function _transfer(address _from, address _to, uint256 _value) internal {
        // Ensure sending is to valid address! 0x0 address cane be used to burn()
        require(_to != address(0));
        balanceOf[_from] = balanceOf[_from] - (_value);
        balanceOf[_to] = balanceOf[_to] + (_value);
        emit Transfer(_from, _to, _value);
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        _transfer(msg.sender, _to, _value);
        return true;
    }

    // allow _spender to spend up to _value on your behalf
    function approve(address _spender, uint256 _value) external returns (bool) {
        require(_spender != address(0));
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // allow _spender to spend up to _value on your behalf
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - (_value);
        _transfer(_from, _to, _value);
        return true;
    }
}
