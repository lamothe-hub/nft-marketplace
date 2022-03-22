// SPDX-License-Identifier: MIT
pragma solidity >0.8.0; 

contract ERC721 {
    /*
    Minting function : 
        1. NFT to point to ad address 
        2. Keep track of the token ids
        3. Keep track of token owner addresses to token ids 
        4. Keep track of how many tokens an owner address has 
        5. create an event that emits a transfer log - contract address , where it is being minted to, the id
    */ 

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); 

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId); 

    // mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner; 

    // mapping from owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;

    // mapping from token id to approved addresses 
    mapping(uint256 => address) private _tokenApprovals;

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), "Error : owner address can not equal '0'");
        return _ownedTokensCount[_owner]; 
    }

    function ownerOf(uint256 _tokenId) public view returns(address) {
        address owner = _tokenOwner[_tokenId]; 
        require(owner != address(0), "the owner for this query is 0"); 
        return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId]; 
        return owner != address(0); 
    }

    function _mint(address _to, uint _tokenId) internal virtual {

        require(_to != address(0), "Can not mint to address '0'"); 
        require(!_exists(_tokenId), "A token with this id has already been minted");     

        _tokenOwner[_tokenId] = _to; 
        _ownedTokensCount[_to] += 1; 

        emit Transfer(address(0), _to, _tokenId);
    }

     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error : transfer to the 0 address'); 
        require(ownerOf(_tokenId) == _from); 

        // add the token id to the address receiving the token 
        _tokenOwner[_tokenId] = _to; 
    
        // update the balance of the address from token
        _ownedTokensCount[_from]--; 
     
        // update the balance of the address too token
        _ownedTokensCount[_to]++; 
        
        emit Transfer(_from, _to, _tokenId); 
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(isApprovedOrOwner(msg.sender, _tokenId)); 
        _transferFrom(_from, _to, _tokenId); 
    }

    function approve(address _to, uint256 _tokenId) public {
        // require the person approving is the owner 
        // approve an address to a token 
        // require that we cant approve wsending tokens of the owner to the owner (current caller)
        // update the map of the approval addresses 

        address owner = ownerOf(_tokenId); 
        require(_to != owner, 'Error : cant approve to current owner'); 
        require(msg.sender == owner, 'Current caller does not own the token'); 
        _tokenApprovals[_tokenId] = _to; 
        emit Approval(owner, _to, _tokenId); 
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist'); 
        address owner = ownerOf(tokenId); 
        return (spender == owner); 
        // optional bonus : extend to check if the sender is approved (reference OpenZeppelin)
    }
}