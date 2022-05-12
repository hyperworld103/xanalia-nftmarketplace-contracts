// /**
//  *Submitted for verification at polygonscan.com on 2021-12-13
// */

// /**
//  *Submitted for verification at polygonscan.com on 2021-12-02
// */

// /**
//  *Submitted for verification at polygonscan.com on 2021-11-09
// */

// /**
//  *Submitted for verification at polygonscan.com on 2021-11-08
// */

// /**
//  *Submitted for verification at polygonscan.com on 2021-11-05
// */

// /**
//  *Submitted for verification at BscScan.com on 2021-10-30
// */

// // File: contracts/Ownable.sol

// pragma solidity ^0.5.0;

// /**
//  * @dev Contract module which provides a basic access control mechanism, where
//  * there is an account (an owner) that can be granted exclusive access to
//  * specific functions.
//  *
//  * This module is used through inheritance. It will make available the modifier
//  * `onlyOwner`, which can be aplied to your functions to restrict their use to
//  * the owner.
//  */
// contract Ownable {
//     address internal _owner;

//     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

//     /**
//      * @dev Initializes the contract setting the deployer as the initial owner.
//      */
//     // constructor () internal {
//     //     _owner = msg.sender;
//     //     emit OwnershipTransferred(address(0), _owner);
//     // }
//     function ownerInit() internal {
//          _owner = msg.sender;
//         emit OwnershipTransferred(address(0), _owner);
//     }
//     /**
//      * @dev Returns the address of the current owner.
//      */
//     function owner() public view returns (address) {
//         return _owner;
//     }

//     /**
//      * @dev Throws if called by any account other than the owner.
//      */
//     modifier onlyOwner() {
//         require(isOwner(), "Ownable: caller is not the owner");
//         _;
//     }

//     /**
//      * @dev Returns true if the caller is the current owner.
//      */
//     function isOwner() public view returns (bool) {
//         return msg.sender == _owner;
//     }

//     /**
//      * @dev Leaves the contract without owner. It will not be possible to call
//      * `onlyOwner` functions anymore. Can only be called by the current owner.
//      *
//      * > Note: Renouncing ownership will leave the contract without an owner,
//      * thereby removing any functionality that is only available to the owner.
//      */
//     function renounceOwnership() public onlyOwner {
//         emit OwnershipTransferred(_owner, address(0));
//         _owner = address(0);
//     }

//     /**
//      * @dev Transfers ownership of the contract to a new account (`newOwner`).
//      * Can only be called by the current owner.
//      */
//     function transferOwnership(address newOwner) public onlyOwner {
//         _transferOwnership(newOwner);
//     }

//     /**
//      * @dev Transfers ownership of the contract to a new account (`newOwner`).
//      */
//     function _transferOwnership(address newOwner) internal {
//         require(newOwner != address(0), "Ownable: new owner is the zero address");
//         emit OwnershipTransferred(_owner, newOwner);
//         _owner = newOwner;
//     }
// }

// // File: contracts/IERC20.sol

// pragma solidity ^0.5.0;
// /**
//  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
//  * the optional functions; to access them see {ERC20Detailed}.
//  */
// interface IERC20 {
//     /**
//      * @dev Returns the amount of tokens in existence.
//      */
//     function totalSupply() external view returns (uint256);
//     /**
//      * @dev Returns the amount of tokens owned by `account`.
//      */
//     function balanceOf(address account) external view returns (uint256);
//     /**
//      * @dev Moves `amount` tokens from the caller's account to `recipient`.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transfer(address recipient, uint256 amount) external returns (bool);
//     /**
//      * @dev Returns the remaining number of tokens that `spender` will be
//      * allowed to spend on behalf of `owner` through {transferFrom}. This is
//      * zero by default.
//      *
//      * This value changes when {approve} or {transferFrom} are called.
//      */
//     function allowance(address owner, address spender) external view returns (uint256);
//     /**
//      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * IMPORTANT: Beware that changing an allowance with this method brings the risk
//      * that someone may use both the old and the new allowance by unfortunate
//      * transaction ordering. One possible solution to mitigate this race
//      * condition is to first reduce the spender's allowance to 0 and set the
//      * desired value afterwards:
//      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
//      *
//      * Emits an {Approval} event.
//      */
//     function approve(address spender, uint256 amount) external returns (bool);
//     /**
//      * @dev Moves `amount` tokens from `sender` to `recipient` using the
//      * allowance mechanism. `amount` is then deducted from the caller's
//      * allowance.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
//     function mint(address recipient, uint256 amount) external returns(bool);
//     /**
//      * @dev Emitted when `value` tokens are moved from one account (`from`) to
//      * another (`to`).
//      *
//      * Note that `value` may be zero.
//      */
//     event Transfer(address indexed from, address indexed to, uint256 value);
//     /**
//      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
//      * a call to {approve}. `value` is the new allowance.
//      */
//     event Approval(address indexed owner, address indexed spender, uint256 value);
//       function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
//     function blindBox(address seller, string calldata tokenURI, bool flag, address to, string calldata ownerId) external returns (uint256);
//     function mintAliaForNonCrypto(uint256 price, address from) external returns (bool);
//     function nonCryptoNFTVault() external returns(address);
//     function mainPerecentage() external returns(uint256);
//     function authorPercentage() external returns(uint256);
//     function platformPerecentage() external returns(uint256);
//     function updateAliaBalance(string calldata stringId, uint256 amount) external returns(bool);
//     function getSellDetail(uint256 tokenId) external view returns (address, uint256, uint256, address, uint256, uint256, uint256);
//     function getNonCryptoWallet(string calldata ownerId) external view returns(uint256);
//     function getNonCryptoOwner(uint256 tokenId) external view returns(string memory);
//     function adminOwner(address _address) external view returns(bool);
//      function getAuthor(uint256 tokenIdFunction) external view returns (address);
//      function _royality(uint256 tokenId) external view returns (uint256);
//      function getrevenueAddressBlindBox(string calldata info) external view returns(address);
//      function getboxNameByToken(uint256 token) external view returns(string memory);
//     //Revenue share
//     function addNonCryptoAuthor(string calldata artistId, uint256 tokenId, bool _isArtist) external returns(bool);
//     function transferAliaArtist(address buyer, uint256 price, address nftVaultAddress, uint256 tokenId ) external returns(bool);
//     function checkArtistOwner(string calldata artistId, uint256 tokenId) external returns(bool);
//     function checkTokenAuthorIsArtist(uint256 tokenId) external returns(bool);
//     function withdraw(uint) external;
//     function deposit() payable external;
//     // function approve(address spender, uint256 rawAmount) external;

//     // BlindBox ref:https://noborderz.slack.com/archives/C0236PBG601/p1633942033011800?thread_ts=1633941154.010300&cid=C0236PBG601
//     function isSellable (string calldata name) external view returns(bool);

//     function tokenURI(uint256 tokenId) external view returns (string memory);

//     function ownerOf(uint256 tokenId) external view returns (address);

//     function burn (uint256 tokenId) external;

// }

// // File: contracts/INFT.sol

// pragma solidity ^0.5.0;

// // import "../openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol";

// interface INFT {
//     function transferFromAdmin(address owner, address to, uint256 tokenId) external;
//     function mintWithTokenURI(address to, string calldata tokenURI) external returns (uint256);
//     function getAuthor(uint256 tokenIdFunction) external view returns (address);
//     function updateTokenURI(uint256 tokenIdT, string calldata uriT) external;
//     //
//     function mint(address to, string calldata tokenURI) external returns (uint256);
//     function transferOwnership(address newOwner) external;
//     function ownerOf(uint256 tokenId) external view returns(address);
//     function transferFrom(address owner, address to, uint256 tokenId) external;
// }

// // File: contracts/IFactory.sol

// pragma solidity ^0.5.0;


// contract IFactory {
//     function create(string calldata name_, string calldata symbol_, address owner_) external returns(address);
//     function getCollections(address owner_) external view returns(address [] memory);
// }

// // File: contracts/LPInterface.sol

// pragma solidity ^0.5.0;

// /**
//  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
//  * the optional functions; to access them see {ERC20Detailed}.
//  */
// interface LPInterface {
//     /**
//      * @dev Returns the amount of tokens in existence.
//      */
//     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

   
// }

// // File: openzeppelin-solidity/contracts/math/SafeMath.sol

// pragma solidity ^0.5.0;

// /**
//  * @dev Wrappers over Solidity's arithmetic operations with added overflow
//  * checks.
//  *
//  * Arithmetic operations in Solidity wrap on overflow. This can easily result
//  * in bugs, because programmers usually assume that an overflow raises an
//  * error, which is the standard behavior in high level programming languages.
//  * `SafeMath` restores this intuition by reverting the transaction when an
//  * operation overflows.
//  *
//  * Using this library instead of the unchecked operations eliminates an entire
//  * class of bugs, so it's recommended to use it always.
//  */
// library SafeMath {
//     /**
//      * @dev Returns the addition of two unsigned integers, reverting on
//      * overflow.
//      *
//      * Counterpart to Solidity's `+` operator.
//      *
//      * Requirements:
//      * - Addition cannot overflow.
//      */
//     function add(uint256 a, uint256 b) internal pure returns (uint256) {
//         uint256 c = a + b;
//         require(c >= a, "SafeMath: addition overflow");

//         return c;
//     }

//     /**
//      * @dev Returns the subtraction of two unsigned integers, reverting on
//      * overflow (when the result is negative).
//      *
//      * Counterpart to Solidity's `-` operator.
//      *
//      * Requirements:
//      * - Subtraction cannot overflow.
//      */
//     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
//         require(b <= a, "SafeMath: subtraction overflow");
//         uint256 c = a - b;

//         return c;
//     }

//     /**
//      * @dev Returns the multiplication of two unsigned integers, reverting on
//      * overflow.
//      *
//      * Counterpart to Solidity's `*` operator.
//      *
//      * Requirements:
//      * - Multiplication cannot overflow.
//      */
//     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
//         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
//         // benefit is lost if 'b' is also tested.
//         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
//         if (a == 0) {
//             return 0;
//         }

//         uint256 c = a * b;
//         require(c / a == b, "SafeMath: multiplication overflow");

//         return c;
//     }

//     /**
//      * @dev Returns the integer division of two unsigned integers. Reverts on
//      * division by zero. The result is rounded towards zero.
//      *
//      * Counterpart to Solidity's `/` operator. Note: this function uses a
//      * `revert` opcode (which leaves remaining gas untouched) while Solidity
//      * uses an invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      * - The divisor cannot be zero.
//      */
//     function div(uint256 a, uint256 b) internal pure returns (uint256) {
//         // Solidity only automatically asserts when dividing by 0
//         require(b > 0, "SafeMath: division by zero");
//         uint256 c = a / b;
//         // assert(a == b * c + a % b); // There is no case in which this doesn't hold

//         return c;
//     }

//     /**
//      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
//      * Reverts when dividing by zero.
//      *
//      * Counterpart to Solidity's `%` operator. This function uses a `revert`
//      * opcode (which leaves remaining gas untouched) while Solidity uses an
//      * invalid opcode to revert (consuming all remaining gas).
//      *
//      * Requirements:
//      * - The divisor cannot be zero.
//      */
//     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
//         require(b != 0, "SafeMath: modulo by zero");
//         return a % b;
//     }
// }

// // File: contracts/Proxy/DexStorage.sol

// pragma solidity ^0.5.0;






// ///////////////////////////////////////////////////////////////////////////////////////////////////
// /**
//  * @title DexStorage
//  * @dev Defining dex storage for the proxy contract.
//  */
// ///////////////////////////////////////////////////////////////////////////////////////////////////

// contract DexStorage {
//   using SafeMath for uint256;
//    address x; // dummy variable, never set or use its value in any logic contracts. It keeps garbage value & append it with any value set on it.
//    IERC20 ALIA;
//    INFT XNFT;
//    IFactory factory;
//    IERC20 OldNFTDex;
//    IERC20 BUSD;
//    IERC20 BNB;
//    struct RDetails {
//        address _address;
//        uint256 percentage;
//    }
//   struct AuthorDetails {
//     address _address;
//     uint256 royalty;
//     string ownerId;
//     bool isSecondry;
//   }
//   // uint256[] public sellList; // this violates generlization as not tracking tokenIds agains nftContracts/collections but ignoring as not using it in logic anywhere (uncommented)
//   mapping (uint256 => mapping(address => AuthorDetails)) internal _tokenAuthors;
//   mapping (address => bool) public adminOwner;
//   address payable public platform;
//   address payable public authorVault;
//   uint256 internal platformPerecentage;
//   struct fixedSell {
//   //  address nftContract; // adding to support multiple NFT contracts buy/sell 
//     address seller;
//     uint256 price;
//     uint256 timestamp;
//     bool isDollar;
//     uint256 currencyType;
//   }
//   // stuct for auction
//   struct auctionSell {
//     address seller;
//     address nftContract;
//     address bidder;
//     uint256 minPrice;
//     uint256 startTime;
//     uint256 endTime;
//     uint256 bidAmount;
//     bool isDollar;
//     uint256 currencyType;
//     // address nftAddress;
//   }

  
//   // tokenId => nftContract => fixedSell
//   mapping (uint256 => mapping (address  => fixedSell)) internal _saleTokens;
//   mapping(address => bool) public _supportNft;
//   // tokenId => nftContract => auctionSell
//   mapping(uint256 => mapping ( address => auctionSell)) internal _auctionTokens;
//   address payable public nonCryptoNFTVault;
//   // tokenId => nftContract => ownerId
//   mapping (uint256=> mapping (address => string)) internal _nonCryptoOwners;
//   struct balances{
//     uint256 bnb;
//     uint256 Alia;
//     uint256 BUSD;
//   }
//   mapping (string => balances) internal _nonCryptoWallet;
//   LPInterface LPAlia;
//   LPInterface LPWETH;
//   uint256 public adminDiscount;
//   address admin;
//   mapping (string => address) internal revenueAddressBlindBox;
//   mapping (uint256=>string) internal boxNameByToken;
//    bool public collectionConfig;
//   uint256 public countCopy;
//   mapping (uint256=> mapping( address => mapping(uint256 => bool))) _allowedCurrencies;
//   IERC20 ETH;
//   LPInterface LPWMATIC;
//   address award;
//   IERC20 token;
// //   struct offer {
// //       address _address;
// //       string ownerId;
// //       uint256 currencyType;
// //       uint256 price;
// //   }
// //   struct offers {
// //       uint256 count;
// //       mapping (uint256 => offer) _offer;
// //   }
// //   mapping(uint256 => mapping(address => offers)) _offers;
//   uint256[] allowedArray;
//   mapping (address => bool) collectionsWithRoyalties;
//   address blindAddress;

// }

// // File: contracts/CollectionDex.sol

// pragma solidity ^0.5.0;



// contract DexUpdates is Ownable, DexStorage {
   
//   event SellNFT(address indexed from, address nft_a, uint256 tokenId, address seller, uint256 price, uint256 royalty, uint256 baseCurrency, uint256[] allowedCurrencies);
//   event BuyNFT(address indexed from, address nft_a, uint256 tokenId, address buyer, uint256 price, uint256 baseCurrency, uint256 calculated, uint256 currencyType);
//   event CancelSell(address indexed from, address nftContract, uint256 tokenId);
//   event UpdatePrice(address indexed from, uint256 tokenId, uint256 newPrice, bool isDollar, address nftContract, uint256 baseCurrency, uint256[] allowedCurrencies);
//   event BuyNFTNonCrypto( address indexed from, address nft_a, uint256 tokenId, string buyer, uint256 price, uint256 baseCurrency, uint256 calculated, uint256 currencyType);
//   event SellNFTNonCrypto( address indexed from, address nft_a, uint256 tokenId, string seller, uint256 price, uint256 baseCurrency, uint256[] allowedCurrencies);
//   event MintWithTokenURINonCrypto(address indexed from, string to, string tokenURI, address collection);
//   event TransferPackNonCrypto(address indexed from, string to, uint256 tokenId);
//   event updateTokenEvent(address to,uint256 tokenId, string uriT);
//   event updateDiscount(uint256 amount);
//   event Collection(address indexed creater, address collection, string name, string symbol);
//   event CollectionsConfigured(address indexed xCollection, address factory);
//   event MintWithTokenURI(address indexed collection, uint256 indexed tokenId, address minter, string tokenURI);
  
//   function() external payable {}


//   // modifier to check if given collection is supported by DEX
//   modifier isValid( address collection_) {
//     require(_supportNft[collection_],"unsupported collection");
//     _;
//   }
//   function updateRoyaltyAdmin( uint256 tokenId, address nft_a, uint256 royalty) isValid(nft_a) public {
//     require(admin == msg.sender);
//      _tokenAuthors[tokenId][nft_a].royalty = royalty;
     
//   }

//   function nonCryptoAuthor(uint256[] memory tokenId, string memory authorId) public {
//     require(msg.sender == admin, "not authorize");
//     for(uint i =0; i< tokenId.length; i++){
//     _tokenAuthors[tokenId[i]][address(XNFT)].ownerId = authorId;
//     }
//   }

//   function init() public {
//     XNFT = INFT(0x3BD5e6970398463fC41d03a0dc7e0F6Cd3Fef3B2);
//    LPAlia=LPInterface(0x27dD65b98DDAcda1fCbdE9A28f7330f3dFAB304F);
//    LPWETH=LPInterface(0xd919650860CD93f45c2F23399f841043A299Ce49);
//    countCopy = 3;
//    ETH = IERC20(0x062f24cb618e6ba873EC1C85FD08B8D2Ee9bF23e);
//    LPWMATIC = LPInterface(0xFbe216d69e6760145D56cc597C559B322A85c397);
//    _supportNft[0x3BD5e6970398463fC41d03a0dc7e0F6Cd3Fef3B2] = true;
//    BUSD = IERC20(0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747);
//    BNB = IERC20(0x86652c1301843B4E06fBfbBDaA6849266fb2b5e7);
//    award = 0x1F8343eb57adb31384A466658a542aA1BeBC941f;
//   }


//   function buyNFT(address nft_a,uint256 tokenId, string memory ownerId, uint256 currencyType) isValid(nft_a) public{
//         fixedSell storage temp = _saleTokens[tokenId][nft_a];
//         require(temp.price > 0, "108");
//         require(currencyType == 0 || (_allowedCurrencies[tokenId][nft_a][currencyType] && currencyType != 3), "123");
//         require(msg.sender != nonCryptoNFTVault || currencyType == 0, "124" );
//         uint256 price = calculatePrice(temp.price, temp.currencyType, currencyType, tokenId, temp.seller, nft_a);
//         (uint256 mainPerecentage, uint256 authorPercentage, address blindRAddress) = getPercentages(tokenId, nft_a);
//         //  token = currencyType == 1 ? BUSD :  ALIA; //IERC20(address(ALIA));
//         if(currencyType == 1){
//             token = BUSD;
//             price = SafeMath.div(price,1000000000000);
//         }else if(currencyType == 2){
//             token = ETH;
//         }else {
//             token = ALIA;
//         }
//         if(msg.sender == nonCryptoNFTVault) {
//           token.mint(nonCryptoNFTVault, price);
//           token.transferFrom(nonCryptoNFTVault, platform, (price * 5)/100); // transferring from nonCryptoNFTVault who isn't approved, is it intentional ?
//           price= price - ((price * 5)/100);
            
//         }
//         // price = 100000000000000000;
//         if(blindRAddress == address(0x0)){
//          blindRAddress = _tokenAuthors[tokenId][nft_a]._address;
//         //   token.transferFrom(msg.sender, platform, (price  / 1000) * platformPerecentage);
//           token.transferFrom(msg.sender, platform, SafeMath.mul(SafeMath.div(price,1000), platformPerecentage));
//         }
//         if( nft_a == address(XNFT)  || collectionsWithRoyalties[nft_a]) {
//         //   token.transferFrom(msg.sender, blindRAddress, (price  / 1000) * authorPercentage);
//           token.transferFrom(msg.sender, blindRAddress, SafeMath.mul(SafeMath.div(price,1000), authorPercentage));
//           if(blindRAddress == nonCryptoNFTVault){
//             _nonCryptoWallet[_tokenAuthors[tokenId][nft_a].ownerId].Alia += SafeMath.mul(SafeMath.div(price,1000), authorPercentage);
//           }
//         }
        
//         // token.transferFrom(msg.sender, temp.seller, (price  / 1000) * mainPerecentage);
//          token.transferFrom(msg.sender, temp.seller, SafeMath.mul(SafeMath.div(price,1000), mainPerecentage));
//         if(temp.seller == nonCryptoNFTVault) {
//           if(currencyType == 0){
//             _nonCryptoWallet[_nonCryptoOwners[tokenId][nft_a]].Alia += SafeMath.mul(SafeMath.div(price,1000), mainPerecentage);
//           } else {
//             // _nonCryptoWallet[_nonCryptoOwners[tokenId][nft_a]].BUSD += (price / 1000) * mainPerecentage;

//           }
//           // updateAliaBalance(_nonCryptoOwners[tokenId], (price / 1000) * mainPerecentage);
//           delete _nonCryptoOwners[tokenId][nft_a];
//         }
//         if(msg.sender == nonCryptoNFTVault) {
//           _nonCryptoOwners[tokenId][nft_a] = ownerId;
//         emit BuyNFTNonCrypto(msg.sender, nft_a, tokenId, ownerId, temp.price, temp.currencyType, price, currencyType); 
//         }
//         clearMapping(tokenId, nft_a, temp.price, temp.currencyType, price, currencyType);
//         // INFT(nft_a).transferFrom(address(this), msg.sender, tokenId);
//         // delete _saleTokens[tokenId][nft_a];
//         // _allowedCurrencies[tokenId][0] = false;
//         // _allowedCurrencies[tokenId][1] = false;
//         // _allowedCurrencies[tokenId][2] = false;
//         // in first argument there should seller not buyer/msg.sender, is it intentional ??
//         // emit BuyNFT(msg.sender, nft_a, tokenId, msg.sender, temp.price, temp.currencyType, price, currencyType);
//   }

//   function calculatePrice(uint256 _price, uint256 base, uint256 currencyType, uint256 tokenId, address seller, address nft_a) public view returns(uint256 price) {    
//     price = _price; 
//     //(uint112 _reserve0, uint112 _reserve1,) =LPBNB.getReserves();  
//     (uint112 reserve0, uint112 reserve1,) =LPAlia.getReserves();
//     (uint112 reserveWETH0, uint112 reserveWETH1,) =LPWETH.getReserves(); //0x853Ee4b2A13f8a742d64C8F088bE7bA2131f670d 
//     (uint112 reserveWMATIC0, uint112 reserveWMATIC1,) =LPWMATIC.getReserves(); //0xFbe216d69e6760145D56cc597C559B322A85c397 LPWMATIC
//     if(nft_a == address(XNFT) && _tokenAuthors[tokenId][address(this)]._address == admin && adminOwner[seller] && adminDiscount > 0){ // getAuthor() can break generalization if isn't supported in Collection.sol. SOLUTION: royality isn't paying for user-defined collections    
//         price = _price- ((_price * adminDiscount) / 1000);  
//     }   
//     if(currencyType == 0 && base == 1){
//         //dollar to alia
//         price = SafeMath.div(SafeMath.mul(price,reserve1),SafeMath.mul(reserve0,1000000000000));  
//     } else if(currencyType == 1 && base == 0){
//         //alia to dollar
//         price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserve0,1000000000000)),reserve1);
//     } else if (currencyType == 0 && base == 2) {
//         //weth to alia
//         price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserveWETH0,1000000000000)),reserveWETH1);
//         price = SafeMath.div(SafeMath.mul(price,reserve1),SafeMath.mul(reserve0,1000000000000)); 
//     }else if (currencyType == 1 && base == 2) {
//         // weth to usdc
//       price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserveWETH0,1000000000000)),reserveWETH1);    
//     } else if (currencyType == 2 && base == 0) {
//         //alia to weth
//         price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserve0,1000000000000)),reserve1);
//         price = SafeMath.div(SafeMath.mul(price,reserveWETH1),SafeMath.mul(reserveWETH0,1000000000000));  
//     }else if (currencyType ==2 &&  base == 1) { 
//         //usdc to weth
//       price = SafeMath.div(SafeMath.mul(price,reserveWETH1),SafeMath.mul(reserveWETH0,1000000000000));    
//     }   else if (currencyType == 0 && base == 3) {
//         //wmatic to alia
//         price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserveWMATIC1,1000000000000)),reserveWMATIC0);
//         price = SafeMath.div(SafeMath.mul(price,reserve1),SafeMath.mul(reserve0,1000000000000));
//     } else if (currencyType == 1 && base == 3) {
//         // wmatic to usdc
//       price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserveWMATIC1,1000000000000)),reserveWMATIC0);
//     } else if (currencyType == 2 && base == 3) {
//         // wmatic to weth
//       price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserveWMATIC1,1000000000000)),reserveWMATIC0);
//       price = SafeMath.div(SafeMath.mul(price,reserveWETH1),SafeMath.mul(reserveWETH0,1000000000000));
//     } else if (currencyType == 3 && base == 0) {
//         //alia to wmatic
//         price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserve0,1000000000000)),reserve1);
//         price = SafeMath.div(SafeMath.mul(price,reserveWMATIC0),SafeMath.mul(reserveWMATIC1,1000000000000));
//     } else if (currencyType ==3 &&  base == 1) {
//         //usdc to wmatic
//       price = SafeMath.div(SafeMath.mul(price,reserveWMATIC0),SafeMath.mul(reserveWMATIC1,1000000000000));
//     } else if (currencyType ==3 &&  base == 2) {
//         //weth to wmatic
//       price = SafeMath.div(SafeMath.mul(price,SafeMath.mul(reserveWETH0,1000000000000)),reserveWETH1);
//       price = SafeMath.div(SafeMath.mul(price,reserveWMATIC0),SafeMath.mul(reserveWMATIC1,1000000000000));
//     }
        
//   } 
  
//   function getPercentages(uint256 tokenId, address nft_a) public view returns(uint256 mainPerecentage, uint256 authorPercentage, address blindRAddress) {
//         if(nft_a == address(XNFT) || collectionsWithRoyalties[nft_a]) { // royality for XNFT only (non-user defined collection)
//           if(_tokenAuthors[tokenId][nft_a].royalty > 0) { authorPercentage = _tokenAuthors[tokenId][nft_a].royalty; } else { authorPercentage = 25; }
//           mainPerecentage = SafeMath.sub(SafeMath.sub(1000,authorPercentage),platformPerecentage); //50
//         } else {
//           mainPerecentage = SafeMath.sub(1000, platformPerecentage);
//         }
//      blindRAddress = revenueAddressBlindBox[boxNameByToken[tokenId]];
//     if(blindRAddress != address(0x0)){
//           mainPerecentage = 865;
//           authorPercentage =135;    
//     }
//   }

//   function clearMapping(uint256 tokenId, address nft_a, uint256 price, uint256 baseCurrency, uint256 calcultated, uint256 currencyType ) internal {
//       INFT(nft_a).transferFrom(address(this), msg.sender, tokenId);
//         delete _saleTokens[tokenId][nft_a];
//         for(uint256 i = 0; i <=3 ; i++) {
//             _allowedCurrencies[tokenId][nft_a][i] = false;
//         }
//         // _allowedCurrencies[tokenId][1] = false;
//         // _allowedCurrencies[tokenId][2] = false;
//         emit BuyNFT(msg.sender, nft_a, tokenId, msg.sender, price, baseCurrency, calcultated, currencyType);
//   }


  
// }