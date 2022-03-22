// SPDX-License-Identifier: MIT
pragma solidity >0.8.0; 

import './ERC721Connector.sol'; 

contract KryptoBird is ERC721Connector {

    // array to store our nfts
    string[] public kryptoBirds; 

    mapping(string => bool) _kryptoBirdExist; 

    function mint(string memory _kryptoBird) public {

        require(!_kryptoBirdExist[_kryptoBird], "Error : KryptoBird already exists");
        // deprecated : uint _id = kryptoBirds.push(_kryptoBird); 
        kryptoBirds.push(_kryptoBird); 
        uint _id = kryptoBirds.length - 1;
        _mint(msg.sender, _id); // invokes ERC721
        _kryptoBirdExist[_kryptoBird] = true;
    }

    constructor() ERC721Connector('KryptoBirdNEW', 'KBIRDZ') {

    }
}