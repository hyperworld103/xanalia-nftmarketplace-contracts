pragma solidity ^0.5.0;

import "./Ownable.sol";
import './Proxy/DexStorage.sol';


contract BlindBoxDex is Ownable, DexStorage {

  address a;

  event MintWithTokenURINonCrypto(address indexed from, string to, string tokenURI, address collection);
  event TransferPackNonCrypto(address indexed from, string to, uint256 tokenId);
  event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);

  modifier onlyAdminMinter() {
      require(msg.sender==0x9b6D7b08460e3c2a1f4DFF3B2881a854b4f3b859);
      _;
  }
  modifier blindBoxAdd{
   require(msg.sender == 0x313Df3fE7c83d927D633b9a75e8A9580F59ae79B, "not authorized");
   _;
   }
  function() external payable {}

  function updateSellDetail(uint256 tokenId) internal {
    (address seller, uint256 price, uint256 endTime, address bidder, uint256 minPrice, uint256 startTime, uint256 isDollar) = OldNFTDex.getSellDetail(tokenId);
    if(minPrice == 0){
      _saleTokens[tokenId][address(XNFT)].seller = seller;
      _saleTokens[tokenId][address(XNFT)].price = price;
      _saleTokens[tokenId][address(XNFT)].timestamp = endTime;
      if(isDollar == 1){
        _saleTokens[tokenId][address(XNFT)].isDollar = true;
      }
      _allowedCurrencies[tokenId][address(XNFT)][isDollar] = true;
      if(seller == nonCryptoNFTVault){
        string memory ownerId = OldNFTDex.getNonCryptoOwner(tokenId);
        _nonCryptoOwners[tokenId][address(XNFT)] = ownerId;
        _nonCryptoWallet[ownerId].Alia = OldNFTDex.getNonCryptoWallet(ownerId);
      }
    } else {
      _auctionTokens[tokenId][address(XNFT)].seller = seller;
      _auctionTokens[tokenId][address(XNFT)].nftContract = address(this);
      _auctionTokens[tokenId][address(XNFT)].minPrice = minPrice;
      _auctionTokens[tokenId][address(XNFT)].startTime = startTime;
      _auctionTokens[tokenId][address(XNFT)].endTime = endTime;
      _auctionTokens[tokenId][address(XNFT)].bidder = bidder;
      _auctionTokens[tokenId][address(XNFT)].bidAmount = price;
      if(seller == nonCryptoNFTVault ){
         string memory ownerId = OldNFTDex.getNonCryptoOwner(tokenId);
        _nonCryptoOwners[tokenId][address(XNFT)] = ownerId;
        _nonCryptoWallet[ownerId].Alia = OldNFTDex.getNonCryptoWallet(ownerId);
        _auctionTokens[tokenId][address(XNFT)].isDollar = true;
      }
    }
  }

  function mintAdmin(uint256 index) public {
    require(msg.sender == admin,"Not authorized");
    for(uint256 i=1; i<=index; i++){
      countCopy++; 
    // string memory uri = string(abi.encodePacked("https://ipfs.infura.io:5001/api/v0/object/get?arg=", OldNFTDex.tokenURI(countCopy)));
    string memory uri = OldNFTDex.tokenURI(countCopy);
    address to = OldNFTDex.ownerOf(countCopy);
    // OldNFTDex.burn(countCopy);
    if(to == 0xc2F19E2be5c5a1AA7A998f44B759eb3360587ad1) {
      XNFT.mintWithTokenURI(address(this),uri);
      updateSellDetail(countCopy);
    } else {
      XNFT.mintWithTokenURI(to, uri);
      adminOwner[to] = OldNFTDex.adminOwner(to);
      if(to == nonCryptoNFTVault){
         string memory ownerId = OldNFTDex.getNonCryptoOwner(countCopy);
        _nonCryptoOwners[countCopy][address(XNFT)] = ownerId;
        _nonCryptoWallet[ownerId].Alia = OldNFTDex.getNonCryptoWallet(ownerId);
      }
      setAuthor(countCopy);
    }
    }
  }
  function mintTokenAdmin(address to, string memory tokenURI) public {
     require(msg.sender == admin,"Not authorized");
      countCopy++;
      XNFT.mintWithTokenURI(to, tokenURI);
      setAuthor(countCopy);
  }

  function setAuthor(uint256 tokenId) internal{
    address author = OldNFTDex.getAuthor(tokenId);
    _tokenAuthors[tokenId][address(XNFT)]._address = author;
    _tokenAuthors[tokenId][address(XNFT)].royalty = OldNFTDex._royality(tokenId);
  }
  
  function blindBoxDetails(uint256 tokenId) internal {
    string memory test = OldNFTDex.getboxNameByToken(tokenId);
    address rAddress = OldNFTDex.getrevenueAddressBlindBox(test);
    boxNameByToken[tokenId] = test;
    revenueAddressBlindBox[test] = rAddress ;
    
  }

  // modifier to check if given collection is supported by DEX
  modifier isValid( address collection_) {
    require(_supportNft[collection_],"unsupported collection");
    _;
  }

function getAuthor(uint256 tokenId) public view returns(address _address, string memory ownerId) {
  _address = _tokenAuthors[tokenId][address(XNFT)]._address;
  ownerId = _tokenAuthors[tokenId][address(XNFT)].ownerId;
}

// blindboxes only can be created on XNFT, no generalization required.
   function blindBox(address seller, string calldata tokenURI, bool flag, address to, string calldata ownerId, string calldata boxName) blindBoxAdd external returns(uint256){
   uint256 tokenId;
  
   tokenId = XNFT.mintWithTokenURI(seller, tokenURI); // removed parameters flag, quantity#1 as signature of mintWithTokenURI changed from accepting 4 params to 2.
   boxNameByToken[tokenId] = boxName;
   // tokenSellTimeBlindbox[boxName] = blindTokenTime;
       if(to == nonCryptoNFTVault){
       // emit MintWithTokenURINonCrypto(msg.sender, ownerId, tokenURI, 1, flag);
       emit TransferPackNonCrypto(msg.sender, ownerId, tokenId);
         _nonCryptoOwners[tokenId][address(this)] = ownerId;
       }
       XNFT.transferFrom(seller, to, tokenId);
       return tokenId;
   }

  function mintAliaForNonCrypto(uint256 price,address from) blindBoxAdd external returns (bool){
      if(from == nonCryptoNFTVault) ALIA.mint(nonCryptoNFTVault, price);
      return true;
  }
  
  function registerAddressBlindbox(address _address, string calldata name) blindBoxAdd external returns(bool) {
    revenueAddressBlindBox[name] = _address;
  }

  // Getter functions to read init() set values
    function getXNFT() public view returns(address){
   
    return address(XNFT);
  }
  function getOldNFTDex() public view returns(address){
   
    return address(OldNFTDex);
  }
  function getAlia() public view returns(address){
   
    return address(ALIA);
  } 
  function getCollectionConfig() public view returns(bool){
   
    return collectionConfig;
  }
  function getAdmin() public view returns(address){
   
    return admin;
  }
  function getLPAlia() public view returns(address){
   
    return address(LPAlia);
  }
  function getLPBNB() public view returns(address){
   
    return address(LPBNB);
  }
  function getNonCryptoNFTVault() public view returns(address){
   
    return nonCryptoNFTVault;
  }
  function getPlatform() public view returns(address){
   
    return platform;
  }
  function getAuthorVault() public view returns(address){
   
    return authorVault;
  }
  function getPlatformPerecentage() public view returns(uint256){
   
    return platformPerecentage;
  }
  function getCountCopy() public view returns(uint256){
   
    return countCopy;
  }
  function getFactory() public view returns(address){
   
    return address(factory);
  }
  function getSupportNft(address addr) public view returns(bool){
   
    return _supportNft[addr];
  }
  function getBUSD() public view returns(address){
   
    return address(BUSD);
  }
  function getBNB() public view returns(address){
   
    return address(BNB);
  }
  function getA() public view returns(address){
   
    return a;
  }


}
