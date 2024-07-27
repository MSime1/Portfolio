// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Notarize is Ownable, AccessControlEnumerable{
    //importo AccessControlEnumerable per la funzione di counter
    using Counters for Counters.Counter;

    bytes32 public constant HASH_WRITER = keccak256("HASH_WRITER"); //crea un nuovo ruolo
//contatore dei documenti
    Counters.Counter private _docCounter;
//mappo di documento, dal numero del documento a url e hash
    mapping(uint256 => Doc) private _documents;
//mappo da hash a notarizzato
    mapping(bytes32 => bool) private _regHashes;
//evento di notarizzazione
    event DocHashAdded(uint256 indexed docCounter, string docUrl, bytes32 docHash);

    struct Doc{
        string docUrl;
        bytes32 docHash;
    }
//chi deploya il contratto è l'owner
    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender()); //do al deployer il ruolo di admin
    }
//l'owner può dare il ruolo di hash writer
    function setHashWriterRole(address _hashWriter) external onlyRole(DEFAULT_ADMIN_ROLE){
        grantRole(HASH_WRITER, _hashWriter);
    }
/*
    aggiunge un nuovo documento: fa il check per vedere se è gia stato notarizzato 
    se non è notarizzato, lo notarizza, incrementa il counter ed ementte l'evento

*/
    function addNewDocument(string memory _url, bytes32 _hash) external onlyRole(HASH_WRITER){
        require(!_regHashes[_hash], "hash already notarized");
        uint256 counter = _docCounter.current();
        _documents[counter] = Doc({docUrl: _url, docHash: _hash});
        _regHashes[_hash] = true;
        _docCounter.increment();
        emit DocHashAdded(counter, _url, _hash);
    }
//ritorna l'url e l'hash di un documento dato il numero
    function getDocInfo(uint256 _num) external view returns (string memory, bytes32) {
        require(_num < _docCounter.current(), "requested number does not exist");
        return(_documents[_num].docUrl, _documents[_num].docHash);        
    }
//ritorna il numero di documenti notarizzati
    function getDocsCount() external view returns (uint256) {
        return _docCounter.current();
    }
//ritorna se un hash è notarizzato
    function getRegisteredHash(bytes32 _hash) external view returns (bool) {
        return _regHashes[_hash];
    }
}





