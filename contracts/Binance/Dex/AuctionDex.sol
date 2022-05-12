
pragma solidity ^0.5.0;

import "./Ownable.sol";
import './Proxy/DexStorage.sol';


contract AuctionDex is Ownable, DexStorage {
   
  event CancelSell(address indexed from, address nftContract, uint256 tokenId);
  event UpdatePrice(address indexed from, uint256 tokenId, uint256 newPrice, bool isDollar, address nftContract, uint256 baseCurrency, uint256[] allowedCurrencies);
  event OnAuction(address indexed seller, address nftContract, uint256 indexed tokenId, uint256 startPrice, uint256 endTime, uint256 baseCurrency);
  event Bid(address indexed bidder, address nftContract, uint256 tokenId, uint256 amount);
  event Claim(address indexed bidder, address nftContract, uint256 tokenId, uint256 amount, address seller, uint256 baseCurrency);
  event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);

  
  function() external payable {}
  
   // modifier to check if given collection is supported by DEX
  modifier isValid( address collection_) {
    require(_supportNft[collection_],"unsupported collection");
    _;
  }

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
  //mint & sell own/xanalia collection only
 function MintAndAuctionNFT(address to, string memory tokenURI, address _contract, uint256 _minPrice, string memory ownerId, uint256 _endTime, uint256 royality, uint256 baseCurrency) public {
    
    require(_contract == address(XNFT), "MintAndAuctionNFT function only supports non-user defined collection");
    uint256 _tokenId;
    _tokenId = XNFT.mintWithTokenURI(to, string(abi.encodePacked("https://ipfs.infura.io:5001/api/v0/cat?arg=", tokenURI)));
     emit MintWithTokenURI(address(XNFT), _tokenId, msg.sender, tokenURI);
    _tokenAuthors[_tokenId][address(XNFT)].ownerId = ownerId;
    setOnAuction(_contract, _tokenId, _minPrice, baseCurrency, _endTime);
    if(royality > 0) {
      _tokenAuthors[_tokenId][address(XNFT)].royalty = royality;
    }else {
      _tokenAuthors[_tokenId][address(XNFT)].royalty = 25;
    }
  }

  function onAuctionOrNot(uint256 tokenId, address _contract) public view returns (bool){
     if(_auctionTokens[tokenId][_contract].seller!=address(0)) return true;
     else return false;
    }

  // added _contract param in function to support generalization
  function placeBid(address _contract, uint256 _tokenId, uint256 _amount, bool awardType, address from) isValid(_contract) public{
    auctionSell storage temp = _auctionTokens[_tokenId][_contract];

    require(temp.endTime >= now,"103");
    require(temp.minPrice <= _amount, "105");
    require(temp.bidAmount < _amount,"106");
    ALIA.transferFrom(msg.sender, address(this), _amount);  
    temp.bidAmount > 0 && ALIA.transfer(temp.bidder, temp.bidAmount);
    temp.bidder = from;
    temp.bidAmount = _amount; 
    emit Bid(from, temp.nftContract, _tokenId, _amount);
  }


 // added _contract param in function to support generalization
  function claimAuction(address _contract, uint256 _tokenId, bool awardType, string memory ownerId, address from) isValid(_contract) public {
    auctionSell storage temp = _auctionTokens[_tokenId][_contract];
    require(temp.endTime < now,"103");
    require(temp.minPrice > 0,"104");
    require(msg.sender==temp.bidder,"107");
    INFT(temp.nftContract).transferFrom(address(this), temp.bidder, _tokenId);
    (uint256 mainPerecentage, uint256 authorPercentage, address blindRAddress) = getPercentages(_tokenId, _contract);
    if(blindRAddress == address(0x0)){
    ALIA.transfer( platform, (temp.bidAmount  / 1000) * platformPerecentage);
    }
    if(_contract == address(XNFT)){ // currently only supporting royality for non-user defined collection
    ALIA.transfer( blindRAddress, (temp.bidAmount  / 1000) * authorPercentage);
    }
    ALIA.transfer(temp.seller, (temp.bidAmount  / 1000) * mainPerecentage);    
      // in case of user-defined collection, sell will receive amount =  bidAmount - platformPerecentage amount
      // author will get nothing as royality not tracking for user-defined collections
    emit Claim(temp.bidder, temp.nftContract, _tokenId, temp.bidAmount, temp.seller, temp.currencyType);
    delete _auctionTokens[_tokenId][_contract];
  }



 // added nftContract param in function to support generalization
  function cancelSell(address nftContract, uint256 tokenId) isValid(nftContract) public{
        require(_saleTokens[tokenId][nftContract].seller == msg.sender || _auctionTokens[tokenId][nftContract].seller == msg.sender, "101");
    if(_saleTokens[tokenId][nftContract].seller != address(0)){
        // _transferFrom(address(this), _saleTokens[tokenId].seller, tokenId);
        INFT(nftContract).transferFrom(address(this), _saleTokens[tokenId][nftContract].seller, tokenId);
         delete _saleTokens[tokenId][nftContract];
    }else {
        require(_auctionTokens[tokenId][nftContract].bidder == address(0),"109");
        INFT(nftContract).transferFrom(address(this), msg.sender, tokenId);
        delete _auctionTokens[tokenId][nftContract];
    }
   
    emit CancelSell(msg.sender, nftContract, tokenId);      
  }

 // added nftContract param in function to support generalization
  function getSellDetail(address nftContract, uint256 tokenId) public view returns (address, uint256, uint256, address, uint256, uint256, bool, uint256) {
  fixedSell storage abc = _saleTokens[tokenId][nftContract];
  auctionSell storage def = _auctionTokens[tokenId][nftContract];
      if(abc.seller != address(0)){
        uint256 salePrice = abc.price;
        return (abc.seller, salePrice , abc.timestamp, address(0), 0, 0,abc.isDollar, abc.currencyType);
      }else{
          return (def.seller, def.bidAmount, def.endTime, def.bidder, def.minPrice,  def.startTime, def.isDollar, def.currencyType);
      }
  }
//  added nftContract param in function to support generalization
  function updatePrice(address nftContract, uint256 tokenId, uint256 newPrice, uint256 baseCurrency, uint256[] memory allowedCurrencies) isValid(nftContract)  public{
    require(msg.sender == _saleTokens[tokenId][nftContract].seller || _auctionTokens[tokenId][nftContract].seller == msg.sender, "110");
    require(newPrice > 0 ,"111");
    if(_saleTokens[tokenId][nftContract].seller != address(0)){
    require(newPrice > 0,"121");
    bool isValid = true;
    _allowedCurrencies[tokenId][nftContract][0]=false;
    _allowedCurrencies[tokenId][nftContract][1]=false;
    _allowedCurrencies[tokenId][nftContract][2]=false;
    for(uint256 i = 0; i< allowedCurrencies.length; i++){
      if(allowedCurrencies[i] > 2){
        isValid = false;
      }
      _allowedCurrencies[tokenId][nftContract][allowedCurrencies[i]] = true;
    }
    require(isValid,"122");
        _saleTokens[tokenId][nftContract].price = newPrice;
        _saleTokens[tokenId][nftContract].currencyType = baseCurrency;
      }else{
        _auctionTokens[tokenId][nftContract].minPrice = newPrice;
        _auctionTokens[tokenId][nftContract].currencyType = baseCurrency;
      }
    emit UpdatePrice(msg.sender, tokenId, newPrice, false, nftContract, baseCurrency, allowedCurrencies); // added nftContract here as well
  }
  function calculatePrice(uint256 _price, uint256 base, uint256 currencyType, uint256 tokenId, address seller, address nft_a) public view returns(uint256 price) {
    price = _price;
     (uint112 _reserve0, uint112 _reserve1,) =LPBNB.getReserves();
      (uint112 reserve0, uint112 reserve1,) =LPAlia.getReserves();
    if(nft_a == address(XNFT) && _tokenAuthors[tokenId][address(XNFT)]._address == admin && adminOwner[seller] && adminDiscount > 0){ // getAuthor() can break generalization if isn't supported in Collection.sol. SOLUTION: royality isn't paying for user-defined collections
        price = _price- ((_price * adminDiscount) / 1000);
    }
    if(currencyType == 0 && base == 1){
      price = SafeMath.div(SafeMath.mul(SafeMath.mul(price,reserve1), _reserve1),SafeMath.mul(_reserve0,reserve0));
    } else if(currencyType == 1 && base == 0){
      
      price = SafeMath.div(SafeMath.mul(SafeMath.mul(price,reserve0), _reserve0),SafeMath.mul(_reserve1,reserve1));
      
    } else if (currencyType == 0 && base == 2) {
      price = SafeMath.div(SafeMath.mul(price,reserve0),reserve1);
      
    }else if (currencyType == 1 && base == 2) {
      price = SafeMath.div(SafeMath.mul(price,_reserve1),_reserve0);
    } else if (currencyType == 2 && base == 0) {
      price = SafeMath.div(SafeMath.mul(price,reserve1),reserve0);
    }else if (currencyType ==2 &&  base == 1) {
      price = SafeMath.div(SafeMath.mul(price,_reserve0),_reserve1);
    }
    
  }
  function getPercentages(uint256 tokenId, address nft_a) public view returns(uint256 mainPerecentage, uint256 authorPercentage, address blindRAddress) {
    if(_tokenAuthors[tokenId][nft_a].royalty > 0 && nft_a == address(XNFT)) { // royality for XNFT only (non-user defined collection)
          mainPerecentage = SafeMath.sub(SafeMath.sub(1000,_tokenAuthors[tokenId][nft_a].royalty),platformPerecentage); //50
          authorPercentage = _tokenAuthors[tokenId][nft_a].royalty;
        } else {
          mainPerecentage = SafeMath.sub(1000, platformPerecentage);
        }
     blindRAddress = revenueAddressBlindBox[boxNameByToken[tokenId]];
    if(blindRAddress != address(0x0)){
          mainPerecentage = 865;
          authorPercentage =135;    
    }
  }
}
