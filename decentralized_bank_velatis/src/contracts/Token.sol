// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// total supply starts with 0. create new tokens as users earn interests in the bank
// earn token as the interests like APY

contract Token is ERC20 {
  //add minter variable
  address public minter;
  //add minter changed event
  event MinterChanged(address indexed from, address to);

  constructor() public payable ERC20('Velatis', 'VLT') {
    //asign initial minter
    minter = msg.sender;
  }

  function passMinterRole(address dBank) public returns (bool) {
  	require(msg.sender == minter, 'Error, only owner can change pass minter role');
  	minter = dBank;
    emit MinterChanged(msg.sender, dBank);
    return true;
  }

  function mint(address account, uint256 amount) public {
    //check if msg.sender have minter role
    require(msg.sender == minter, 'Error, msg.sender has to be the minter');
		_mint(account, amount);
	}
}
