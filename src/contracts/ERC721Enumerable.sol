// SPDX-License-Identifier: MIT
pragma solidity >0.8.0; 

import './ERC721.sol';

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
contract ERC721Enumerable is ERC721 {

    uint256[] private _allTokens;

    // map from tokenId to position in _allTokens array
    mapping(uint256 => uint256) internal _allTokensIndex; 

    // map from owner to list of all owner token ids 
    mapping(address => uint256[]) internal _ownedTokens; 

    // map from token ID index of the owner tokens list 
    mapping(uint256 => uint256) internal _ownedTokensIndex; 

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId); 
        // 1. add tokens to the owner
        _addTokensToAllTokenEnumeration(tokenId);

        // 2. add tokens to our total suppy - to allTokens 
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the _allTokens array and set position of the token
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length; 
        _allTokens.push(tokenId); 
    }

    function _addTokensToOwnerEnumeration(address to, uint tokenId) private {
        // add address and token id to the _ownedTokens
        _ownedTokens[to].push(tokenId); 

        // ownedTokensIndex tokenId set to address fo ownedTokens position 
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length - 1;

        // execute the function with minting

    }

    // two functions ; one to return token by index and another to return token of owner by index 
    function tokenByIndex(uint256 index) public view returns(uint256) {
        require(index >= 0 && index < totalSupply(), 'index is out of bounds'); 
        return _allTokens[index]; 
    }

    function tokenOfOwnerByIndex(address owner, uint index) public view returns(uint256) {
        require(index < balanceOf(owner), 'Error : owner does not have that many NFTs');
        return _ownedTokens[owner][index]; 
    }

    // return total supply of the _allTokens array
    function totalSupply() public view returns(uint256) {
        return _allTokens.length;
    }
}