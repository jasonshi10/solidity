//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

/// @dev use interface to interact with a deployed and ownable contract
interface ITestERC20 {
    function transferOwnership(address addr) external;

    function owner() external view returns (address);
}

/// @title Sell Your Contract Escrow Protocol

contract Escrow {
    // create a struct to group contract being sold, seller, buyer, and price together
    struct EscrowContracts {
        address contractBeingSold;
        address sellerAddress;
        uint256 sellPrice;
        address buyersAddress;
    }

    // create a struct for buyer information
    struct BuyersInfo {
        address contractBeingBought;
        address buyerAddress;
        uint256 sellPrice;
    }

    // creat a mapping to keep track of EscrowContracts struct
    mapping(address => EscrowContracts) public escrowDetails;

    // emit an event when seller is ready
    event SellerReady(EscrowContracts seller);

    // emit an event when the transaction is completed
    event TransactionCompleted(BuyersInfo buyer, EscrowContracts seller);

    /// @dev seller sends contract transaction details
    function setContractDetail(
         address contractBeingSold
        ,uint256 sellPrice
        ,address buyerAddress
    ) external {
        address sellerAddress = msg.sender;

        EscrowContracts memory mySellerInfo = EscrowContracts(
             contractBeingSold
            ,sellerAddress
            ,sellPrice
            ,buyerAddress
        );

        // check if contract is owned by escrow
        require(
            ITestERC20(mySellerInfo.contractBeingSold).owner() == address(this),
            "Seller has not transferred the ownership to the escrow"
        );

        // fill in escrow details
        escrowDetails[mySellerInfo.contractBeingSold] = mySellerInfo;

        // emit seller is ready
        emit SellerReady(mySellerInfo);
    }

    /// @dev buyer sends payment to the seller after seller provides contract transaction details and transferred ownership
    function buyerSendPay(address contractBeingBought, uint256 price)
        external
        payable
    {
        uint256 amount = price;
        address buyerAddress = msg.sender;

        // require buyer sends payment
        require(amount != 0, "Buyer did not send any payment");

        BuyersInfo memory myBuyersInfo = BuyersInfo(
            contractBeingBought,
            buyerAddress,
            amount
        );

        EscrowContracts memory mySellerInfo = escrowDetails[
            myBuyersInfo.contractBeingBought
        ];

        // check if the contract ownership has transferred to the escrow contract
        require(
            ITestERC20(contractBeingBought).owner() == address(this),
            "Seller has not transferred ownership to the escrow"
        );

        // check if the intended buyer address correct
        require(
            escrowDetails[contractBeingBought].buyersAddress == msg.sender,
            "Buyer address did not match seller"
        );

        // call goodToGo function after buyer sends payment
        goodToGo(mySellerInfo, myBuyersInfo);
    }

    /// @dev buyer sends payment to seller, escrow transfers the ownership to buyer
    function goodToGo(EscrowContracts memory seller, BuyersInfo memory buyer)
        internal
    {
        require(
            seller.sellPrice == buyer.sellPrice,
            "Sell price doesn't match buy price"
        );
        require(
            seller.contractBeingSold == buyer.contractBeingBought,
            "Contract sold and bought not the same"
        );

        // buyer sends payment to seller
        (bool sent, ) = seller.sellerAddress.call{value: buyer.sellPrice}("");
        require(sent, "Payment failed to send to seller address");

        // use interface to transferownership to buyer
        ITestERC20(seller.contractBeingSold).transferOwnership(
            buyer.buyerAddress
        );

        // emit an event when transaction is completed
        emit TransactionCompleted(buyer, seller);

        // delete stored contract transaction details
        delete escrowDetails[seller.contractBeingSold];
    }

    /// @dev only buyer can check the listed price of the contract
    function getSellerAmount(address myContract) public view returns (uint256) {
        EscrowContracts memory seller = escrowDetails[myContract];

        require(
            seller.buyersAddress == msg.sender,
            "Only buyer can see the price"
        );

        return seller.sellPrice;
    }
}
