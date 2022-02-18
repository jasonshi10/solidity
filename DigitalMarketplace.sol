// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol"; // accecss counter utility that makes it easy to create a number and increment the number for each function call
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

/*
 * @title Digital Marketplace
 */

 // contract named NFT inherited from ERC721URIStorage
contract NFT is ERC721URIStorage {

}
