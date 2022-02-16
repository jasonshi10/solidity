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
        /// @dev create unique ID for tokens
        _tokenIds.increment();
        /// @dev new var setting new tokenID UID for tokens
        uint256 newItemId = _tokenIds.current();
        /// @dev mint the token
        _mint(msg.sender, newItemId);
        /// @dev use new tokenID and passing in URI
        _setTokenURI(newItemId, tokenURI);
        /// @dev allow us to have access to this token and our other contract so that transfer tokens btw parties
        setApprovalForAll(contractAddress, true);
        /// @dev need tokenId to transfer etc.
        return newItemId;
    }
}

/*
ReentrancyGuard adds non-reentrance modifier that prevents re-entry attacks.
when you call a contract from another you often open the contract up for recursive calls
meaning that before that other function has resolved, someone may call the function again
to drain funds etc.
*/
contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    /// @ dev keep track of how many items sold. we can also get how many remaining to be sold
    Counters.Counter private _itemsSold;

    address payable owner;
    uint256 listingPrice = 10 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
    }
    /// @dev this mapping allows us to retrive metadata of the item based on itemId
    mapping(uint256 => MarketItem) private idToMarketItem;

    /// @dev emit an event when someone purchases a nft
    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );
    /// @dev once create the item we want to keep track of the id and price
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) public payable nonReentrant {
      require(price > 0, "Price must be at least 1 wei");
      require(msg.value == listingPrice, "Price must be equal to listing price");

      _itemIds.increment();
      uint256 itemId = _itemIds.current();
    /// @dev store the metadata into the mapping
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

        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

        idToMarketItem[itemId].seller.transfer(msg.value);

        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        /// @dev set the owner to msg.sender after sale
        idToMarketItem[itemId].owner = payable(msg.sender);
        /// @dev keep track of the number of items sold
        _itemsSold.increment();
        /// @dev transfer the amount of listing price to the owner when sold
        payable(owner).transfer(listingPrice);
    }

    /// @dev a function to return the items for sale, exclude items sold
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        /// @dev total number of items created so far
        uint itemCount = _itemIds.current();
        /// @dev unsold number of items
        uint unsoldItemCount = itemCount - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {
            if (idToMarketItem[i + 1].owner == address(0)) {
                uint currentId = idToMarketItem[i + 1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    /// @dev a function to return my NFT collections
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint i = 0; i <= totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i +1].owner == msg.sender) {
                uint currentId = idToMarketItem[i + 1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

}
