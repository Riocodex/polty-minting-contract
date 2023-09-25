// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTCollection is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 MAX_SUPPLY = 100000;

    struct NFT {
        string uri;
        address owner;
        uint256 royaltyPercentage;
    }

    NFT[] public nfts;

    constructor() ERC721("NFTCollection", "NFTC") {}

    function safeMint(string memory uri, uint256 royaltyPercentage) public {
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "I'm sorry we reached the cap");
        require(royaltyPercentage <= 100, "Royalty percentage cannot exceed 100");
        
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(msg.sender, tokenId);
        
        NFT memory newNFT = NFT(uri, msg.sender, royaltyPercentage);
        nfts.push(newNFT);
    }

    function setRoyalties(uint256 tokenId, uint256 royaltyPercentage) public {
        require(tokenId < nfts.length, "Token ID does not exist");
        require(msg.sender == nfts[tokenId].owner, "Only the owner can set royalties");
        require(royaltyPercentage <= 100, "Royalty percentage cannot exceed 100");
        
        nfts[tokenId].royaltyPercentage = royaltyPercentage;
    }
}
