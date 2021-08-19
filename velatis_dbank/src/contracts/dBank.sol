// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  //assign Token contract to variable
  Token private token;

  //add mappings
  mapping(address => uint) public etherBalanceOf;
  mapping(address => uint) public depositStart;
  mapping(address => uint) public collateralEther;

  mapping(address => bool) public isDeposited;
  mapping(address => bool) public isBorrowed;

  //add events
  event Deposit(address indexed user, uint etherAmount, uint timeStart);
  event Withdraw(address indexed user, uint etherAmount, uint depositTime, uint interest);
  event Borrow(address indexed user, uint collateralEtherAmount, uint borrowedTokenAmount);
  event Payoff(address indexed user, uint fee);

  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    //assign token deployed contract to variable
    token = _token;
  }

  function deposit() payable public {
    //check if msg.sender didn't already deposited funds
    require(isDeposited[msg.sender] == false, 'Error, deposit already active');

    //check if msg.value is >= than 0.01 ETH
    require(msg.value >= 1e16, 'Error, deposit must be >= 0.01 ETH');

    //increase msg.sender ether deposit balance
    etherBalanceOf[msg.sender] = etherBalanceOf[msg.sender] + msg.value;

    //start msg.sender hodling time
    depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

    //set msg.sender deposit status to true
    isDeposited[msg.sender] = true;

    //emit Deposit event
    emit Deposit(msg.sender, msg.value, block.timestamp);
  }

  function withdraw() public {
    //check if msg.sender deposit status is true
    require(isDeposited[msg.sender] == true, 'Error, no previous deposit');

    //assign msg.sender ether deposit balance to variable for event
    uint userBalance = etherBalanceOf[msg.sender];

    //check user's hodl time
    uint depositTime = block.timestamp - depositStart[msg.sender];

    //calc interest per second with 10% APY
    uint interestPerSecond = 31668017 * (userBalance / 1e16);

    //calc accrued interest
    uint interest = interestPerSecond * depositTime;

    //send eth to user
    msg.sender.transfer(userBalance);

    //send interest in tokens to user
    token.mint(msg.sender, interest);

    //reset depositer data
    depositStart[msg.sender] = 0;
    etherBalanceOf[msg.sender] = 0;
    isDeposited[msg.sender] = false;

    //emit event
    emit Withdraw(msg.sender, userBalance, depositTime, interest);
  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    require(msg.value >- 1e16, 'Error, collateral amount must be >= 0.01 ETH');

    //check if user doesn't have active loan
    require(isBorrowed[msg.sender] == false, 'Error, loan is already active');

    //add msg.value to ether collateral
    collateralEther[msg.sender] = collateralEther[msg.sender] + msg.value;

    //calc tokens amount to mint, 50% of msg.value
    uint tokensToMint = collateralEther[msg.sender] / 2;

    //mint&send tokens to user
    token.mint(msg.sender, tokensToMint);

    //activate borrower's loan status
    isBorrowed[msg.sender] = true;

    //emit event
    emit Borrow(msg.sender, collateralEther[msg.sender], tokensToMint);
  }

  function payOff() public {
    //check if loan is active
    require(isBorrowed[msg.sender] == true, 'Error, user does not have an active loan');

    //transfer tokens from user back to the contract
    require(token.transferFrom(msg.sender, address(this), collateralEther[msg.sender] / 2), 'Error, cannot receive tokens');

    //calc 10% fee
    uint fee = collateralEther[msg.sender] * 0.1;

    //send user's collateral minus fee
    msg.sender.transfer(collateralEther[msg.sender] - fee);

    //reset borrower's data
    isBorrowed[msg.sender] = false;
    collateralEther[msg.sender] = 0;

    //emit event
    emit Payoff(msg.sender, fee);
  }
}
