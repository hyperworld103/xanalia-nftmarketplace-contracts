
pragma solidity ^0.5.0;

import "./Ownable.sol";
import './Proxy/DexStorage.sol';

contract FixPriceDex is Ownable, DexStorage {
   
  event SellNFT(address indexed from, address nft_a, uint256 tokenId, address seller, uint256 price, uint256 royalty, uint256 baseCurrency, uint256[] allowedCurrencies);
  event BuyNFT(address indexed from, address nft_a, uint256 tokenId, address buyer, uint256 price, uint256 baseCurrency, uint256 calculated, uint256 currencyType);
  event CancelSell(address indexed from, address nftContract, uint256 tokenId);
  event UpdatePrice(address indexed from, uint256 tokenId, uint256 newPrice, bool isDollar, address nftContract, uint256 baseCurrency, uint256[] allowedCurrencies);
  event BuyNFTNonCrypto( address indexed from, address nft_a, uint256 tokenId, string buyer, uint256 price, uint256 baseCurrency, uint256 calculated, uint256 currencyType);
  event SellNFTNonCrypto( address indexed from, address nft_a, uint256 tokenId, string seller, uint256 price, uint256 baseCurrency, uint256[] allowedCurrencies);
  event MintWithTokenURINonCrypto(address indexed from, string to, string tokenURI, address collection);
  event TransferPackNonCrypto(address indexed from, string to, uint256 tokenId);
  event updateTokenEvent(address to,uint256 tokenId, string uriT);
  event updateDiscount(uint256 amount);
  event Collection(address indexed creater, address collection, string name, string symbol);
  event CollectionsConfigured(address indexed xCollection, address factory);
  event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);
//   event Offer(uint256 tokenId, address indexed from, uint256 currencyType, uint256 offer, uint256 index);


  modifier onlyAdminMinter() {
      require(msg.sender==0x9b6D7b08460e3c2a1f4DFF3B2881a854b4f3b859);
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

  //mint & sell own/xanalia collection only
  function MintAndSellNFT(address to, string memory tokenURI, uint256 price, string memory ownerId, uint256 royality, uint256 currencyType, uint256[] memory allowedCurrencies)  public { 
    uint256 tokenId;
     tokenId = XNFT.mintWithTokenURI(to,string(abi.encodePacked("https://ipfs.infura.io:5001/api/v0/cat?arg=", tokenURI)));
     emit MintWithTokenURI(address(XNFT), tokenId, msg.sender, tokenURI);
     if(royality > 0) _tokenAuthors[tokenId][address(XNFT)].royalty = royality;
     else _tokenAuthors[tokenId][address(XNFT)].royalty = 25;
     sellNFT(address(XNFT), tokenId, to, price, currencyType, allowedCurrencies);
     _tokenAuthors[tokenId][address(XNFT)]._address = msg.sender;
     if(msg.sender == admin) adminOwner[to] = true;
     if(msg.sender == nonCryptoNFTVault){
      emit MintWithTokenURINonCrypto(msg.sender, ownerId, tokenURI, address(XNFT));
      _nonCryptoOwners[tokenId][address(XNFT)] = ownerId;
      _tokenAuthors[tokenId][address(XNFT)].ownerId = ownerId;
      emit SellNFTNonCrypto(msg.sender, address(XNFT), tokenId, ownerId, price,  currencyType, allowedCurrencies);
    }
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
  function buyNFT(address nft_a,uint256 tokenId, string memory ownerId, uint256 currencyType) isValid(nft_a) public{
        fixedSell storage temp = _saleTokens[tokenId][nft_a];
        require(temp.price > 0, "108");
        require(_allowedCurrencies[tokenId][nft_a][currencyType] && currencyType != 2, "123");
        require(msg.sender != nonCryptoNFTVault || currencyType == 0, "124" );
        uint256 price = calculatePrice(temp.price, temp.currencyType, currencyType, tokenId, temp.seller, nft_a);
        (uint256 mainPerecentage, uint256 authorPercentage, address blindRAddress) = getPercentages(tokenId, nft_a);
         token = currencyType == 1 ? BUSD :  ALIA; //IERC20(address(ALIA));
        if(msg.sender == nonCryptoNFTVault) {
          token.mint(nonCryptoNFTVault, price);
          token.transferFrom(nonCryptoNFTVault, platform, (price * 5)/100); // transferring from nonCryptoNFTVault who isn't approved, is it intentional ?
          price= price - ((price * 5)/100);
            
        }
        if(blindRAddress == address(0x0)){
         blindRAddress = _tokenAuthors[tokenId][nft_a]._address;
          token.transferFrom(msg.sender, platform, (price  / 1000) * platformPerecentage);
        }
        if( nft_a == address(XNFT)) {
          token.transferFrom(msg.sender, blindRAddress, (price  / 1000) * authorPercentage);
        }
        
        token.transferFrom(msg.sender, temp.seller, (price  / 1000) * mainPerecentage);
        if(temp.seller == nonCryptoNFTVault) {
          if(currencyType == 0){
            _nonCryptoWallet[_nonCryptoOwners[tokenId][nft_a]].Alia += (price / 1000) * mainPerecentage;
          } else {
            _nonCryptoWallet[_nonCryptoOwners[tokenId][nft_a]].BUSD += (price / 1000) * mainPerecentage;

          }
          // updateAliaBalance(_nonCryptoOwners[tokenId], (price / 1000) * mainPerecentage);
          delete _nonCryptoOwners[tokenId][nft_a];
        }
        if(msg.sender == nonCryptoNFTVault) {
          _nonCryptoOwners[tokenId][nft_a] = ownerId;
        emit BuyNFTNonCrypto(msg.sender, address(this), tokenId, ownerId, temp.price, temp.currencyType, price, currencyType); 
        }
        clearMapping(tokenId, nft_a, temp.price, temp.currencyType, price, currencyType);
        // INFT(nft_a).transferFrom(address(this), msg.sender, tokenId);
        // delete _saleTokens[tokenId][nft_a];
        // _allowedCurrencies[tokenId][0] = false;
        // _allowedCurrencies[tokenId][1] = false;
        // _allowedCurrencies[tokenId][2] = false;
        // in first argument there should seller not buyer/msg.sender, is it intentional ??
        // emit BuyNFT(msg.sender, nft_a, tokenId, msg.sender, temp.price, temp.currencyType, price, currencyType);
  } 
  function buyNFTBnb(address nft_a,uint256 tokenId, string memory ownerId) isValid(nft_a) payable public{
        fixedSell storage temp = _saleTokens[tokenId][nft_a];
        // AuthorDetails storage author = _tokenAuthors[tokenId][address(XNFT)];
        require(_allowedCurrencies[tokenId][nft_a][2], "123");
        require(msg.sender != nonCryptoNFTVault, "125");
        require(temp.price > 0 , "108");
        uint256 price = calculatePrice(temp.price, temp.currencyType, 2, tokenId, temp.seller, nft_a);
        (uint256 mainPerecentage, uint256 authorPercentage, address blindRAddress) = getPercentages(tokenId, nft_a);
        uint256 before_bal = BNB.balanceOf(address(this));
        BNB.deposit.value(msg.value)();
        uint256 after_bal = BNB.balanceOf(address(this));
        require(price == (after_bal - before_bal), "NFT 108");
        if(blindRAddress == address(0x0)) {
         blindRAddress = _tokenAuthors[tokenId][nft_a]._address;
          bnbTransfer(platform, platformPerecentage, price);
        }
        if( nft_a == address(XNFT)) {
         bnbTransfer(blindRAddress, authorPercentage, price);
        }
        bnbTransfer(temp.seller, mainPerecentage, price);
        clearMapping(tokenId, nft_a, temp.price, temp.currencyType, price, 2 );
        // in first argument there should seller not buyer/msg.sender, is it intentional ??
        
  }  

  function clearMapping(uint256 tokenId, address nft_a, uint256 price, uint256 baseCurrency, uint256 calcultated, uint256 currencyType ) internal {
      INFT(nft_a).transferFrom(address(this), msg.sender, tokenId);
        delete _saleTokens[tokenId][nft_a];
        for(uint256 i = 0; i <=2 ; i++) {
            _allowedCurrencies[tokenId][nft_a][i] = false;
        }
        // _allowedCurrencies[tokenId][1] = false;
        // _allowedCurrencies[tokenId][2] = false;
        emit BuyNFT(msg.sender, nft_a, tokenId, msg.sender, price, baseCurrency, calcultated, currencyType);
  }
    function bnbTransfer(address _address, uint256 percentage, uint256 price) public {
      address payable newAddress = address(uint160(_address));
      uint256 initialBalance;
      uint256 newBalance;
      initialBalance = address(this).balance;
      BNB.withdraw((price / 1000) * percentage);
      newBalance = address(this).balance.sub(initialBalance);
      newAddress.transfer(newBalance);
  }

}
