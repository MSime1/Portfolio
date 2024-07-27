//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Animals is ERC1155Supply, Ownable {
//imposto le costanti
    uint256 public constant DWARF = 1;
    uint256 public constant ELF = 2;
    uint256 public constant JAGUAR = 3;
    uint256 public constant PANDA = 4;
    uint256 public constant TIGER = 5;
    uint256 public constant WOLF = 6;
//dall'id al'uri
    mapping(uint256 => string) public _uris;

constructor() ERC1155 ("https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/{id}.json") {
_uris[1] = "https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/1.json";
_uris[2] = "https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/2.json";
_uris[3] = "https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/3.json";
_uris[4] = "https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/4.json";
_uris[5] = "https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/5.json";
_uris[6] = "https://green-binding-flea-592.mypinata.cloud/ipfs/QmPDd9351cLmmxuJV5idRzRnpmp4RMFgfu1UNL3sW4F4r8/6.json";

}

//minto dei token
function mint(address to, uint256 id, uint256 amount, bytes memory data) external onlyOwner {
   _mint(to, id, amount, data);
}
//batch mint per mintare a gruppi
function mintBatch(address to, 
                   uint256[] memory ids, 
                   uint256[] memory amounts, 
                   bytes memory data) external onlyOwner {
    _mintBatch(to, ids, amounts, data);
}

//setto l'uri del token
function setTokenUri(uint256 id, string calldata tokenUri) external onlyOwner {
    _uris[id] = tokenUri;
}

//ottengo uri settato
function getTokenUri(uint256 id) external view returns (string memory) {
    return _uris[id];
}
    
}


