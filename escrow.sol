// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./BED.sol";

contract escrow{

    // Declare state variables
    address payable public buyer;
    address payable public seller;
    address payable public broker;
    uint public price;
    bool public isBuyerIn;
    bool public isSellerIn;

    // Define a constructor
    constructor (
    address payable _buyer,
		address payable _seller,
    uint _price) {
		broker = payable(address(this));
		buyer = _buyer;
		seller = _seller;
        price = _price;
		currState = State.idle;
	}

  	// Define a enumerator 'State'
  	enum State {
          idle, await_payment, await_delivery, buyer_paid, ownership_transferred_to_escrow, complete
  	}

  	// Declare the object of the enumerator
  	State public currState;

  	// Define function modifier 'instate'
  	modifier instate(State expected_state){
  		require(currState == expected_state);
  		_;
  	}

      // Define function modifier 'onlyBuyer'
  	modifier onlyBuyer(){
  		require(msg.sender == buyer, "Only buyer can call this method.");
  		_;
  	}

  	// Define function modifier 'onlySeller'
  	modifier onlySeller(){
  		require(msg.sender == seller, "Only seller can call this method.");
  		_;
  	}

      // Define function modifier 'onlyBroker'
      // modifier onlyBroker(){
  	// 	require(msg.sender == broker, "Only broker can call this method.");
  	// 	_;
  	// }

      // Define function modifier 'escrowIdle'
      modifier escrowIdle(){
  		require(currState == State.idle);
  		_;
  	}

    function initializeEscrow() escrowIdle public {
          if (buyer != address(0)) {
              isBuyerIn = true;
          }
          if (seller != address(0)) {
              isSellerIn = true;
          }
          if (isBuyerIn && isSellerIn) {
              currState = State.await_payment;
          }
      }

    function pay(uint price) onlyBuyer payable public {
          require(currState == State.buyer_paid, "Already paid");
          // require(msg.value == price, "Wrong deposit amount");
          (bool sent, ) = address(this).call{value: price}("");
          require(sent, "Failed to send Ether");
          currState = State.buyer_paid;
      }

    function transferOwnership() onlySeller instate(
  	    State.buyer_paid) public {
          require(address(this) != address(0), "Invalid escrow address");
          BED.transferOwnership(seller, broker);
          currState = State.ownership_transferred_to_escrow;
    }

    function goodToSettle() instate(
          State.ownership_transferred_to_escrow) public {
          // transfer ownership to seller
  		// transfer the fund to buyer
  	}

    function getBalance() public view returns (uint256) {
          return address(this).balance;
  	}

  	receive() external payable {}
