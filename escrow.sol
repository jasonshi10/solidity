//SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeERC20 {
    function transferOwnership(address addy) external;
    function getOwner() external;
}

contract Escrow is Ownable {
    address payable internal ownerOfContract;

    struct EscrowContracts {
        address contractBeingSold;
        address sellerAddress;
        uint256 sellPrice;
        address buyersAddress;
    }

    struct BuyersInfo {
        address contractBeingBought;
        address buyerAddress;
        uint256 sellPrice;
    }

    mapping(address => EscrowContracts) public escrowDetails;

    event SellerReady(EscrowContracts seller);
    event TransactionCompleted(BuyersInfo buyer, EscrowContracts seller);

    constructor() {
        ownerOfContract = payable(msg.sender);
    }

    function setBuyersInfo(address contractBeingBought) external payable {
        uint256 amount = msg.value; //amount sent
        address buyerAddress = msg.sender; //buyer address

        require(amount != 0, "Buyer did not send any amount");

        BuyersInfo memory myBuyersInfo = BuyersInfo(
            contractBeingBought,
            buyerAddress,
            amount
        );

        // verify sellers information matches buyers information, seller must go first
        require(
            escrowDetails[contractBeingBought].buyersAddress == msg.sender,
            "Seller address did not match buyer"
        );

        buyerSendPay(myBuyersInfo);
    }

    function buyerSendPay(BuyersInfo memory myBuyersInfo) public payable {
        EscrowContracts memory mySellerInfo = escrowDetails[
            myBuyersInfo.contractBeingBought
        ]; // Sellers Info

        goodToGo(mySellerInfo, myBuyersInfo);
    }

    function setContractDetail(
        address contractBeingSold,
        uint256 sellPrice,
        address buyerAddress
    ) external {
        address sellerAddress = msg.sender;

        EscrowContracts memory mySellerInfo = EscrowContracts(
            contractBeingSold,
            sellerAddress,
            sellPrice,
            buyerAddress
        ); // Buyers Information

        sellerSendContract(mySellerInfo);
    }

    function sellerSendContract(EscrowContracts memory mySellerInfo) internal {
        // TODO:
        // call other contract and change manager ERC20
        // revert if error
        // IFakeERC20(mySellerInfo.contractBeingSold).transferOwner(
        //     ownerOfContract
        // );

        IFakeERC20 contractBeingSoldIF = IFakeERC20(mySellerInfo.contractBeingSold);
        contractBeingSoldIF.transferOwnership(address(this));

        escrowDetails[mySellerInfo.contractBeingSold] = mySellerInfo;
        emit SellerReady(mySellerInfo);
    }

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
        // good to go send values
        // transfer
        (bool success, ) = payable(seller.sellerAddress).call{
            value: buyer.sellPrice
        }("");
        require(success, "Payment Failed to seller address");

        // TODO:
        // transfer ERC 20 contract ownership to buyer
        IFakeERC20 contractBeingSoldIF = IFakeERC20(seller.contractBeingSold);
        contractBeingSoldIF.transferOwnership(buyer.buyerAddress);

        emit TransactionCompleted(buyer, seller);
        delete escrowDetails[seller.contractBeingSold];
    }

    function getSellerAmount(address myContract) public view returns (uint256) {
        EscrowContracts memory seller = escrowDetails[myContract];
        require(
            seller.buyersAddress == msg.sender,
            "Only buyer can see amount"
        );
        return seller.sellPrice;
    }
    receive() external payable {}
}
