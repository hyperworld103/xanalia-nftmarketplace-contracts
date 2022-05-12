// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

// import "./Proxy/BlindboxStorage.sol";
// import './DummyAssets/Ownable.sol';
// import '@openzeppelin/contracts/utils/math/SafeMath.sol';


// contract Getters is Ownable, BlindboxStorage{
//     //add new variable here 


//     struct TempSeries {
//         address collection;
//         string name;
//         string seriesURI;
//         string boxName;
//         string boxURI;
//         uint256 startTime;
//         uint256 endTime;
//         uint256 maxBoxes;
//         uint256 perBoxNftMint;
//         uint256 price; 
//         Counters.Counter boxId; // to track series's boxId (upto minted so far)
//         Counters.Counter attrId;
//         uint256[] _allowedCurrencies;
//         uint256 baseCurrency;
//     }
//     using SafeMath for uint256;

//     constructor() {
       

//     }

//     function init1() public {
//         a=address(dex);
//         b=address(USD);
//         c=address(MATIC);
//     }
//     function init2() public {
//        _setOwner(_msgSender());
//     }
   

//     function getNonGenSeries(uint256 seriesId) public view returns(TempSeries memory) {
//         NonGenSeries storage nonGen = nonGenSeries[seriesId];
//         TempSeries memory temp;
//          temp.collection= nonGen.collection;
//         temp.name= nonGen.name;
//         temp.seriesURI= nonGen.seriesURI;
//         temp.boxName=  nonGen.boxURI;
//         temp.boxURI= nonGen.boxURI;
//         temp.startTime= nonGen.startTime;
//         temp.endTime= nonGen.endTime;
//         temp.maxBoxes= nonGen.maxBoxes;
//         temp.perBoxNftMint= nonGen.perBoxNftMint;
//         temp.price=  nonGen.price;
//         temp.boxId= nonGen.boxId; // to track series's boxId (upto minted so far)
//         temp.attrId= nonGen.attrId;
//         temp._allowedCurrencies= _allowedCurrencies[seriesId];
//         temp.baseCurrency = baseCurrency[seriesId];
//         return temp;
//     }
//     function getDexAddress() public view returns(address){
//         return address(dex);
//     }
//     function getUSDT() public view returns(address) {
//         return address(USD);
//     }
//     function getChain() public view returns(address) {
//         return address(MATIC);
//     }
//     function getPlatform() public view returns(address) {
//         return platform;
//     }
//     function getNFT() public view returns(address) {
//         return address(nft);
//     }
//     function getBankAddressNonGen(uint256 seriesId) public view returns(address) {
//         return bankAddress[seriesId];
//     }
//     function getOwner() public view returns(address){
//         return owner();
//     } 
   
// }