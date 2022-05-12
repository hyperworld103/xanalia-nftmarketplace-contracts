# xanalia-contracts

# BlindBox
This is BlindBox smartcontracts project containing two type of BlindBoxes OR series
1. NonGenerative Series, which is responsible of creating NonGenerative BlindBox & NonGenerative NFTs (when that Box opened)
## Highlevel flow shared below:
At the time of starting new SERIES, you'll give
1. stringsData in an array: [name, seriesURI, boxName, boxURI]
2. integerData in an array: [startTime, endTime, maxBoxes, perBoxNftMint, perBoxPrice, baseCurrency, userLimit, registrationFee]
3. allowedCurrencies (array of currencies in which box can be bought)
4. bool isGenerative(for future use)
5. bankAddress (in which all assets of box will be transferred)
6. royalty (each nft royalty)
7. isWhiteListed(publicly opened or not)
8. _isCryptoAlowed (used only in case of polygon chain)

- Users will buy Boxes of given series
- Box buyer will open the box
- once box is open it will randomly assign NFT from offchain uris to 

note: 
generative functionality isn't enabled yet 
# Xanalia-Dex
Xanalia Dex is divided into multiple moduler smartcontracts, this project is of xanalia dex containing following dex smartcontracts 
1. **MainDex** - this smartcontract contains most important `init()` function and some other utility functions with offer module (commented)
2. **FixPriceDex** - this smartcontract contains fixed price Buy/Sell module of xanalia dex.
3. **AuctionDex** - it contains auction based trade module.
4. **CollectionDex** - this module is responsible of managing collections based DEX's functioanlities.
5. **BlindBoxDex** - it contain DEX's blindbox related functionality
6. **NonCryptoDex** - this smartcontract is handling DEX's non-crypto users functionalities.

As you can see above DEX is divided into *6* different smartcontracts, all these modules (as explained above) are responsible of performing their respective functionality to complete overall flow of the DEX.

# Archtecture
All these 6 smartcontracts are connected to each other through a `Proxy` using ` EIP1538` standard. This special `DexProxy` (can be found at ```contracts/Proxy/``` ) keeps state of whole DEX where DEX's 6 smartcontracts works as its logic contracts. Proxy delegates function call to its relevant smartcontract whose function is called.
e.g: `init()` is function of ```MainDex``` hence when init() will be called, proxy will delegate this call of MainDex. similarly when `setOnAuction` function will be called proxy will delegate this call not ```AuctionDex``` smartcontract and so on.

In whole this process each called smartcontract/function will be using ( Reading/Writting) state of Proxy contract hence removing the complexity of managing states on each smartcontract or wirring them up to fulfill functionality of other contracts/modules.

# Configuration
To configure & use all these DEX's 6 smartcontracts with `Proxy` you can view sample code I've provided in `**test/ProxyTest.js**` file.

These you can see 4 test-cases are written
1. deploying all 6 + Proxy contract
2. flow of registering MainDex contract's functions in proxy
3. flow to register AuctionDex functions in proxy.
4. a sample call to show how through proxy you can trigger any registered smartcontract's function. In this sample I called `init()` function of ```MainDex```

test-cases 2,3 covering how you should register your smartcontract's each function with Proxy using Proxy's following function:
```code
function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage)
```
here: 
- `_delegate` - is the address of smartcontract whose function you're registering
- `_functionSignatures` - is function's signature which is to be registered with proxy, so when it is called proxy can delegate it to its contract i.e `_delegate`
- `_commitMessage` - its memo string.


# Note
1. Only registered functions of each smartcontract can be called through proxy
2. May you noticed some functions are duplicated in more then one smartcontracts, please don't worry it's intentinal :). You don't need to register that function multiple time (with each smartcontract) on Proxy, JUST register that function with any of its smartcontract and it will work for all others. There will be no issue in the functionality of other smartcontract.

May you've also noticed that with this architecture now we've almost unlimited flexibility of adding more and more functionalities in our DEX without worring about size issue or integration issues with other DEX modules.

# Important

**Standard DexStorage.sol file created at ``contracts/Proxy/`` it keeps all state variables used in all 6 Dex Logic contracts. This file is also imported to each Dex Contract to maintain standard. In latest research I've found state variables declared in one contract should also be declared in other contract in `same order` to get same state of those variables, also in future if more state variables to be introduced, those should also be declared in same order in each contract where those variables are required to read/write. That's why to avoid confusion OR complexity I've declared all Dex's state (so far) variables in one file and imported it into all contracts.**
