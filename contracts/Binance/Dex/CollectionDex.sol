
pragma solidity ^0.5.0;

import "./Ownable.sol";
import './Proxy/DexStorage.sol';

contract CollectionDex is Ownable, DexStorage {
   
  event SellNFT(address indexed from, address nft_a, uint256 tokenId, address seller, uint256 price, uint256 royalty, uint256 baseCurrency, uint256[] allowedCurrencies);
  event OnAuction(address indexed seller, address nftContract, uint256 indexed tokenId, uint256 startPrice, uint256 endTime, uint256 baseCurrency);

  event Collection(address indexed creater, address collection, string name, string symbol);
  event CollectionsConfigured(address indexed xCollection, address factory);
  event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);


  function() external payable {}

  /***
* @dev function to create & deploy user-defined collection
* @param name_ - name of the collection
* @param symbol_ - symbol of collection
*
 */
  function createCollection(string memory name_, string memory symbol_) public {
    address col = factory.create(name_, symbol_, msg.sender);
    _supportNft[col] = true;
    emit Collection(msg.sender, col, name_, symbol_);
  }
  /***
* @dev function to mint NFTs on given user-defined collection
* @param collection - address of collection to whom NFT to be created/minted
* @param to - receiving account of minted NFT
* @param tokenURI - metadata URI link of NFT
*
 */
  function mintAndSellCollectionNFT(address collection, address to, string memory tokenURI, uint256 price, uint256 baseCurrency, uint256[] memory allowedCurrencies ) isValid(collection) public {
 
    address[] memory collections = factory.getCollections(msg.sender);
   
    bool flag;
    for (uint256 i = 0; i < collections.length; i++){
        if (collections[i] == collection){
          flag = true;
          break;
        }
    }
    require(flag, "unauthorized: invalid owner/collection");
    // for (uint256 j = 0; j < quantity; j++){
       uint256 tokenId =  INFT(collection).mint(to, string(abi.encodePacked("https://ipfs.infura.io:5001/api/v0/cat?arg=", tokenURI)));
        sellNFT(collection, tokenId, to, price, baseCurrency, allowedCurrencies);
    // }
    emit MintWithTokenURI(collection, tokenId, msg.sender, tokenURI);
  }
  function mintAndAuctionCollectionNFT(address collection, address to, string memory tokenURI, uint256 _minPrice, uint256 baseCurrency, uint256 _endTime ) isValid(collection) public {
 
    address[] memory collections = factory.getCollections(msg.sender);
   
    bool flag;
    for (uint256 i = 0; i < collections.length; i++){
        if (collections[i] == collection){
          flag = true;
          break;
        }
    }
    require(flag, "unauthorized: invalid owner/collection");
    // for (uint256 j = 0; j < quantity; j++){
       uint256 tokenId =  INFT(collection).mint(to, string(abi.encodePacked("https://ipfs.infura.io:5001/api/v0/cat?arg=", tokenURI)));
       setOnAuction(collection, tokenId, _minPrice, baseCurrency, _endTime);
    // }
       emit MintWithTokenURI(collection, tokenId, msg.sender, tokenURI);

  }
  /***
* @dev function to transfer ownership of user-defined collection
* @param collection - address of collection whose ownership to be transferred
* @param newOwner - new owner to whom ownerhsip to be transferred
* @notice only owner of DEX can invoke this function
*
 */
  function transferCollectionOwnership(address collection, address newOwner) onlyOwner isValid(collection) public {

    INFT(collection).transferOwnership(newOwner);
  }
  
  // modifier to check if given collection is supported by DEX
  modifier isValid( address collection_) {
    require(_supportNft[collection_],"unsupported collection");
    _;
  }
  
  function sellNFT(address nft_a,uint256 tokenId, address seller, uint256 price, uint256 baseCurrency, uint256[] memory allowedCurrencies) isValid(nft_a) public{
    require(msg.sender == admin || (msg.sender == seller && INFT(nft_a).ownerOf(tokenId) == seller), "101");
    // string storage boxName = boxNameByToken[tokenId];
    uint256 royality;
    require(baseCurrency <= 2, "121");
    // require(revenueAddressBlindBox[boxName] == address(0x0) || IERC20(0x313Df3fE7c83d927D633b9a75e8A9580F59ae79B).isSellable(boxName), "112");
    bool isValid = true;
    for(uint256 i = 0; i< allowedCurrencies.length; i++){
      if(allowedCurrencies[i] > 2){
        isValid = false;
      }
      _allowedCurrencies[tokenId][nft_a][allowedCurrencies[i]] = true;
    }
    require(isValid,"122");
    _saleTokens[tokenId][nft_a].seller = seller;
    _saleTokens[tokenId][nft_a].price = price;
    _saleTokens[tokenId][nft_a].timestamp = now;
    // _saleTokens[tokenId][nft_a].isDollar = isDollar;
    _saleTokens[tokenId][nft_a].currencyType = baseCurrency;
    // need to check if it voilates generalization
    // sellList.push(tokenId);
    // dealing special case of escrowing for xanalia collection i.e XNFT
    if(nft_a == address(XNFT)){
         msg.sender == admin ? XNFT.transferFromAdmin(seller, address(this), tokenId) : XNFT.transferFrom(seller, address(this), tokenId);        
          royality =  _tokenAuthors[tokenId][nft_a].royalty;
    } else {
      INFT(nft_a).transferFrom(seller, address(this), tokenId);
      royality =  0; // making it zero as not setting royality for user defined collection's NFT
    }
    
    emit SellNFT(msg.sender, nft_a, tokenId, seller, price, royality, baseCurrency, allowedCurrencies);
  }



 function setOnAuction(address _contract,uint256 _tokenId, uint256 _minPrice, uint256 baseCurrency, uint256 _endTime) isValid(_contract) public {
  require(INFT(_contract).ownerOf(_tokenId) == msg.sender, "102");
  string storage boxName = boxNameByToken[_tokenId];
  require(revenueAddressBlindBox[boxName] == address(0x0) || IERC20(0x313Df3fE7c83d927D633b9a75e8A9580F59ae79B).isSellable(boxName), "112");
  require(baseCurrency <= 2, "121");
    // require(revenueAddressBlindBox[boxName] == address(0x0) || IERC20(0x313Df3fE7c83d927D633b9a75e8A9580F59ae79B).isSellable(boxName), "112");
  _auctionTokens[_tokenId][_contract].seller = msg.sender;
      _auctionTokens[_tokenId][_contract].nftContract = _contract;
      _auctionTokens[_tokenId][_contract].minPrice = _minPrice;
      _auctionTokens[_tokenId][_contract].startTime = now;
      _auctionTokens[_tokenId][_contract].endTime = _endTime;
      _auctionTokens[_tokenId][_contract].currencyType = baseCurrency;
      INFT(_contract).transferFrom(msg.sender, address(this), _tokenId);
    emit OnAuction(msg.sender, _contract, _tokenId, _minPrice, _endTime, baseCurrency);
 }
}
