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

    
    uint256 public _price = 0.01 ether;

    bool public _paused;

    // max number of SimbiumDevs
    uint256 public maxTokenIds = 20;

    // total number of tokenIds minted
    uint256 public tokenIds;

    // Whitelist contract instance
    IWhitelist whitelist;

    bool public presaleStarted;

    // timestamp for when presale would end
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("Crypto Devs", "CD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

   
    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        if(presaleStarted && block.timestamp > presaleEnded){
            revert Simbiumdev__PresaleNotStarted();
        }
        if(!whitelist.whitelistedAddresses(msg.sender)){
            revert Simbiumdev__NotWhiteListed();
        }
        if(tokenIds > maxTokenIds){
            revert Simbiumdev__ExceededMaxSupply();
        }
       if(msg.value < _price){
        revert Simbiumdev__NotEnoughEth();
       }
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    
    function mint() public payable onlyWhenNotPaused {
        if(presaleStarted && block.timestamp <  presaleEnded){
            revert Simbiumdev__PresaleNotEnded();
        }
        if(tokenIds > maxTokenIds){
            revert Simbiumdev__ExceededMaxSupply();
        }
        if(msg.value < _price){
            revert Simbiumdev__NotEnoughEth();
        }
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI();
    }

    
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

      
    receive() external payable {}

    
    fallback() external payable {}
}