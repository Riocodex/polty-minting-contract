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

    function safeMint(address to,string memory uri, uint256 royaltyPercentage) public {
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

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
