
pragma solidity ^0.5.0;

import "./Ownable.sol";
import './Proxy/DexStorage.sol';


contract MainDex is Ownable, DexStorage {
   
  event updateTokenEvent(address to,uint256 tokenId, string uriT);
  event updateDiscount(uint256 amount);
  event CollectionsConfigured(address indexed xCollection, address factory);
  // event Offer(uint256 tokenId, address indexed from, uint256 currencyType, uint256 offer, uint256 index);
  address a;

  modifier onlyAdminMinter() {
      require(msg.sender==0x9b6D7b08460e3c2a1f4DFF3B2881a854b4f3b859);
      _;
  }
  function() external payable {}

  function init() public {
    require(!collectionConfig,"collections already configured");
    XNFT = INFT(0x2e001De15c7eCDBFE06988B48Ec041Ed8C0EFe13); 
    OldNFTDex = IERC20(0xc2F19E2be5c5a1AA7A998f44B759eb3360587ad1);
    ALIA = IERC20(0x8D8108A9cFA5a669300074A602f36AF3252B7533);
    collectionConfig = true;
    admin=0x9b6D7b08460e3c2a1f4DFF3B2881a854b4f3b859;
    LPAlia=LPInterface(0x52826ee949d3e1C3908F288B74b98742b262f3f1);
    LPBNB=LPInterface(0xe230E414f3AC65854772cF24C061776A58893aC2);
    nonCryptoNFTVault = 0x61598488ccD8cb5114Df579e3E0c5F19Fdd6b3Af;
    platform = 0xF0d2D73d09A04036F7587C16518f67cE622129Fd;
    authorVault = 0xF0d2D73d09A04036F7587C16518f67cE622129Fd;
    platformPerecentage = 25;
    countCopy = 0;
    ownerInit();
   factory = IFactory(0x31C863AD3049d4b9F89e12208e4097Ff4B5f603B);
   _supportNft[0xbFdbbe7Dcc62E9723EccBe670c3ED2932F8f251B] = true;
   emit CollectionsConfigured(0xbFdbbe7Dcc62E9723EccBe670c3ED2932F8f251B, 0x31C863AD3049d4b9F89e12208e4097Ff4B5f603B);
    BUSD = IERC20(0x8D8108A9cFA5a669300074A602f36AF3252B7533);
    BNB= IERC20(0x094616F0BdFB0b526bD735Bf66Eca0Ad254ca81F);
    _supportNft[address(this)] = true;
    
    a = 0x094616F0BdFB0b526bD735Bf66Eca0Ad254ca81F;
    
  }

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
  
//   function makeOffer(address nft_a, uint256 tokenId, uint256 currencyType, uint256 price) public {
//       require(price > 0, "126");
//       require(currencyType <= 1, "123");
        
//       IERC20 token = currencyType == 1 ? BUSD : ALIA;
//       token.transferFrom(msg.sender, address(this), price);
//       _offers[tokenId][nft_a].count++;
//       _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count] = offer(msg.sender, "", currencyType, price);
//       emit Offer(tokenId, msg.sender, currencyType, price, _offers[tokenId][nft_a].count);
//   }
//   function removeOffer(address nft_a,uint256 tokenId, uint256 index) public {
//       offer storage temp = _offers[tokenId][nft_a]._offer[index];
//       require(temp._address == msg.sender, "127");
//       require(temp.currencyType <= 1, "123");
//       IERC20 token = temp.currencyType == 1 ? BUSD : ALIA;
//       token.transfer(msg.sender, temp.price);
//       _offers[tokenId][nft_a]._offer[index] = _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//       delete _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//       _offers[tokenId][nft_a].count--;
//   }
//   function acceptOffer(address nft_a,uint256 tokenId, uint256 index) public {
//       require(INFT(nft_a).ownerOf(tokenId) == msg.sender || _saleTokens[tokenId][nft_a].seller == msg.sender, "101");
//       offer storage temp = _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//       require(temp._address == msg.sender, "127");
//       require(temp.currencyType <= 1, "123");
//       IERC20 token = temp.currencyType == 1 ? BUSD : ALIA;
//       token.transfer(msg.sender, temp.price);
//       _offers[tokenId][nft_a].count--;
//       delete _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//   }
//   function rejectOffer(address nft_a, uint256 tokenId, uint256 index) public {
//       require(INFT(nft_a).ownerOf(tokenId) == msg.sender || _saleTokens[tokenId][nft_a].seller == msg.sender , "101");
//       offer storage temp = _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//       require(temp._address == msg.sender, "127");
//       require(temp.currencyType <= 1, "123");
//       IERC20 token = temp.currencyType == 1 ? BUSD : ALIA;
//       token.transfer(temp._address, temp.price);
//       _offers[tokenId][nft_a]._offer[index] = _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//       delete _offers[tokenId][nft_a]._offer[_offers[tokenId][nft_a].count];
//       _offers[tokenId][nft_a].count--;
//   }

   function getAliaAddress () public view returns(address) {
      return address(ALIA);
  }

  // function getAllowedCurrencies(uint256 tokenId, address nft_a ) public view returns(uint256[] memory allowedCurrencies) {
  //   uint256[] storage temp;
  //   for(uint256 i = 0; i <=2 ; i++) {
  //     if( _allowedCurrencies[tokenId][nft_a][i]){
  //       temp.push(i);
  //     }     
  //     }
  //   allowedCurrencies = temp;
  // }

 
  
  function setAdminDiscount(uint256 _discount) onlyAdminMinter public {
    adminDiscount = _discount;
    emit updateDiscount(_discount);
  }
  // only xanalia collection i.e XNFT NFT's uri can be updated
   function updateTokenURI(uint256 tokenIdT, string memory uriT) public{
     // anyone can update tokenURI of NFTs owned by admin, is it intentional ??
        require(XNFT.getAuthor(tokenIdT) == admin,"102");
        // _tokenURIs[tokenIdT] = uriT;
        XNFT.updateTokenURI(tokenIdT, uriT);
        emit updateTokenEvent(msg.sender, tokenIdT, uriT);
  }

}
