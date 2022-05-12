// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Proxy/BlindboxStorage.sol";
import './UtilsContracts/Ownable.sol';
import './UtilsContracts/SafeMath.sol';


contract Utils is Ownable, BlindboxStorage{
    
    using SafeMath for uint256;

    constructor() {
       

    }
    function init() public {
        MATIC = IERC20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c); //for eth chain wrapped ethereum
        USD = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        platform = 0x9c427ea9cE5fd3101a273815Ff8530f2AC75Db37;
        nft = INFT(0x326Cae76A11d85b5c76E9Eb81346eFa5e4ea7593);
        dex = IDEX(0x4f23C2060fCaC2bA9BE1A4B8c96e7E1Cb646FF70);
        ALIA = IERC20(0x13861C017735d3b2F0678A546948D67AD51AC07B);
        //ETH = IERC20();
        LPAlia=LPInterface(0xD9E8a84Bb1CF583410bEd19af437DdD057053d17);
        //LPWETH=LPInterface();
        LPMATIC=LPInterface(0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16);
        _setOwner(_msgSender());
    }
    
  
  function calculatePrice(uint256 _price, uint256 base, uint256 currencyType) public view returns(uint256 price) {
    price = _price;
     (uint112 _reserve0, uint112 _reserve1,) =LPMATIC.getReserves();
      (uint112 reserve0, uint112 reserve1,) =LPAlia.getReserves();
    
    if(currencyType == 1 && base == 0){
      price = SafeMath.div(SafeMath.mul(SafeMath.mul(price,reserve1), _reserve1),SafeMath.mul(_reserve0,reserve0));
    } else if(currencyType == 0 && base == 1){
      
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

  function addWhiteListUsers(bytes32[] memory users, uint256 seriesId) public {
    for(uint256 i = 0; i<users.length; i++){
      _whitelisted[users[i]][seriesId] = true;
    }
  }

  function removeWhiteListUsers(bytes32[] memory users, uint256 seriesId) public {
      for(uint256 i = 0; i<users.length; i++){
      _whitelisted[users[i]][seriesId] = false;
    }
  }

  function isSeriesWhiteListed(uint256 seriesId) public view returns(bool) {
    return _isWhiteListed[seriesId];
  }
   function isUserWhiteListed(bytes32 user, uint256 seriesId) public view returns(bool) {
    return _whitelisted[user][seriesId];
  }

    // function setOnwerManually() public {
    //   require(owner() == address(0x0), "already set");
    //   _setOwner(_msgSender());
    // }
    
   

}