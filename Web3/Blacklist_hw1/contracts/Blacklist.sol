// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Blacklist is Ownable {

//mappo gli indirizzi per ottenere un booleano che dica se l'indirizzo inserito è o meno blacklistato

    mapping (address => bool) _blacklisted;

//richiamo il costruttore passando msg.sender a Ownable
    constructor() Ownable(msg.sender) {} 


/*setto gli indirizzi blacklistati,
  calldata indirica che i dati dell'array sono passati in fase di test
  solo l'owner può modificare l'array blArray e chiamare la funzione
*/
    function setBlacklist(address[] calldata blArray) external onlyOwner{ 
        for(uint256 i = 0; i< blArray.length; i++){
            _blacklisted[blArray[i]]=true;
        }
    }

//resetto gli indirizzi blacklistati
    function resetBlacklist(address[] calldata blArray) external onlyOwner{
        for(uint256 i = 0; i< blArray.length; i++){
            _blacklisted[blArray[i]]=false;
        }
    }

//funzione che permette a chiunque di verificare se un indirizzo è blacklistato o meno
    function isBlacklisted (address account) public view returns (bool) {
        return _blacklisted[account];
    }
}

