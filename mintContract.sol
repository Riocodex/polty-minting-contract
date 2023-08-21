// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RandomNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    string[] public uriA;
    mapping(string => uint256) private uriToTokenId;
    mapping(address => bool) private mintedTokens;

    constructor(string[] memory _initialUriA) ERC721("RandomNFT", "RNFT") {
        uriA = _initialUriA;
    }

    modifier onlyNotMinted() {
        require(!mintedTokens[msg.sender], "Already minted");
        _;
    }

    function mintRandomToken() public onlyNotMinted {
        require(uriA.length > 0, "No more tokens available");
        
        uint256 randomIndex = _getRandomIndex();
        string memory randomTokenUri = uriA[randomIndex];
        uriA[randomIndex] = uriA[uriA.length - 1];
        uriA.pop();

        _mint(msg.sender, _tokenIdCounter.current());
        uriToTokenId[randomTokenUri] = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        mintedTokens[msg.sender] = true;
    }

    function _getRandomIndex() internal view returns (uint256) {
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        return seed % uriA.length;
    }

    function mintListedToken(string memory tokenUri) public onlyOwner {
        require(uriToTokenId[tokenUri] > 0, "Token not found");
        require(ownerOf(uriToTokenId[tokenUri]) == address(this), "Token not owned by contract");

        _mint(msg.sender, uriToTokenId[tokenUri]);
        mintedTokens[msg.sender] = true;
    }

    // Add other ERC721 functions and any additional functionality you need

    // Prerequisite functions

    function approve(address to, uint256 tokenId) public override(ERC721) {
        require(ownerOf(tokenId) == msg.sender || isApprovedForAll(ownerOf(tokenId), msg.sender), "Not approved");
        super.approve(to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}
