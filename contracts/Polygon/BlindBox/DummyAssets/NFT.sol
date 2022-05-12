// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import './Ownable.sol';
/**
> Collection
@notice this contract is standard ERC721 to used as xanalia user's collection managing his NFTs
 */
contract NFT is ERC721URIStorage, Ownable {
using Counters for Counters.Counter;

Counters.Counter tokenIds;

/**
@notice contructor to initialize ERC721 contract and transfer its ownership to given address
 @param name_ name of the NFT collection
 @param symbol_ symbol of the NFTs
 @param owner_ address of the owner of this contract, xanaliaDex generally
 */
  constructor(string memory name_, string memory symbol_, address owner_) ERC721(name_, symbol_) {
      _setOwner(owner_);
  }

/**
@notice function resposible of minting new NFTs of the collection.
 @param to_ address of account to whom newely created NFT's ownership to be passed
 @param tokenURI_ URI of newely created NFT
 Note only owner can mint NFT
 */
  function mintWithTokenURI(address to_, string memory tokenURI_) onlyOwner public returns (uint256) {
      tokenIds.increment();
      _safeMint(to_, tokenIds.current());
      _setTokenURI(tokenIds.current(), tokenURI_);

      return tokenIds.current();
  }
}