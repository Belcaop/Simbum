// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

error Simbiumdev__PresaleNotStarted();
error Simbiumdev__PresaleNotEnded();
error Simbiumdev__NotWhiteListed();
error Simbiumdev__ExceededMaxSupply();
error Simbiumdev__NotEnoughEth();

contract SimbiumDev is ERC721Enumerable, Ownable {
    string _baseTokenURI;
     //  _price is the price of one Crypto Dev NFT
     uint256 public _price = 0.01 ether;
     // _paused is used to pause the contract incase of emergency
     bool public _paused;

     // max no. of CryptoDev
     uint256 public maxTokenId = 20;

     //total no. of tokenIds minted
     uint256 public tokenIds;

    // Whitelist contract instance
      IWhitelist whitelist;
    
    // boolean to keep track if presale has started or not 
    bool public presaleStarted;

    //timestamp to know when presale will end
    uint256 public presaleEnded;


    modifier onlyWhenNotPaused{
        require(!_paused,"Contract currently paused");
        _;
    }
constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
          _baseTokenURI = baseURI;
          whitelist = IWhitelist(whitelistContract);
      }
/**starts presale for whitelisted addresses
 */
 function startPresale() public onlyOwner{
    presaleStarted = true;
    // Set presaleEnded time as current timestamp + 5 minutes
    presaleEnded = block.timestamp + 5 minutes;

 }
 // @presaleMint mints 1 NFT per transaction during presale
 function presaleMint()public payable onlyWhenNotPaused{
    if(presaleStarted && block.timestamp > presaleEnded) {
        revert Simbiumdev__PresaleNotStarted();
    }
    if(!whitelist.whitelistedAddresses(msg.sender)){
        revert Simbiumdev__NotWhiteListed();
    }
    if(tokenIds >maxTokenId){
        revert Simbiumdev__ExceededMaxSupply();
    }
    if(msg.value < _price){
        revert Simbiumdev__NotEnoughEth();
    }
    
    tokenIds += 1;
    _safeMint(msg.sender, tokenIds);
 }
 // @mint mints 1 NFT per transaction after presale has ended
 function mint()public payable onlyWhenNotPaused{
    if(presaleStarted && block.timestamp < presaleEnded){
        revert Simbiumdev__PresaleNotEnded();
    }
    if(tokenIds > maxTokenId){
        revert Simbiumdev__ExceededMaxSupply();
    }
    if(msg.value < _price){
        revert Simbiumdev__NotEnoughEth();
    }
    tokenIds += 1;
    _safeMint(msg.sender, tokenIds);
 }

 function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
}
//@setPaused makes the contract paused or on paused
function setPaused(bool val) public onlyOwner{
    _paused = val;
}
/*
       @withdraw sends all the ether in the contract
     to the owner of the contract
*/
function withdraw() public onlyOwner{
    address _owner = owner();
    uint256 amount = address(this).balance;
    (bool sent,)= _owner.call{value: amount}("");
    require(sent, "Failed to send Ether");
}
receive() external payable {}
fallback() external payable {}
} 