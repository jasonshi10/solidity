// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

/// @title NFT Marketplace
/// @notice Build and deploy NFT tokens
contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    constructor(address marketplaceAddress) ERC721("MagicDAO", "MAGIC") {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns (uint) {
        // create unique ID for tokens
        _tokenIds.increment();
        // new var setting new tokenID UID for tokens
        uint256 newItemId = _tokenIds.current();
        // mint the token
        _mint(msg.sender, newItemId);
        // use new tokenID and passing in URI
        _setTokenURI(newItemId, tokenURI);
        // allow us to have access to this token and our other contract so that transfer tokens btw parties
        setApprovalForAll(contractAddress, true);
        // need tokenId to transfer etc.
        return newItemId;
    }
}

/*
ReentrancyGuard allows us to add non-reentrance modifier that prevents re-entry attacks.
when you call a contract from another you often open the contract up for recursive calls
meaning that before that other function has resolved then maybe someone will call the function again
to drain funds etc.
*/
contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    // keep track of how many items sold. we can also get how many remaining to be sold
    Counters.Counter private _itemsSold;

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
    }
    // this mapping allows us to retrive metadata of the item based on itemId
    mapping(uint256 => MarketItem) private idToMarketItem;

    // emit an event when someone purchases a nft
    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );
    // once create the item we want to keep track of the id and price
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
      require(price > 0, "Price must be at least 1 wei");

      _itemIds.increment();
      uint256 itemId = _itemIds.current();
    // store the metadata into the mapping
      idToMarketItem[itemId] = MarketItem(
          itemId,
          nftContract,
          tokenId,
          payable(msg.sender),
          payable(address(0)),
          price
      );

      IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

      emit MarketItemCreated(
          itemId,
          nftContract,
          tokenId,
          msg.sender,
          address(0),
          price
      );
    }

    function createMarketSale(
        address nftContract,
        uint256 itemId
    ) public payable nonReentrant {
        uint price = idToMarketItem[itemId].price;
        uint tokenId =idToMarketItem[itemId].tokenId;
        // @dev have to submit a value of the price
        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

    }

}
