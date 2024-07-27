// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "src/Blacklist.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {

    

//indirizzo blacklistato
    address public blAddress; 
    uint8 public _tokenDecimals;
    uint256 public _maxSupply;

/*
  Passo i parametri al contruttore e ai contratti che importo
  nel costruttore blAddress è l'indirizzo del contratto blacklistato
*/
constructor(
    string memory tokenName, 
    string memory tokenSymbol, 
    uint8 tokenDecimals,
    uint256 maxSupply,
    address blAddress_,
    address owner_
) ERC20(tokenName, tokenSymbol) Ownable(owner_) {
    _tokenDecimals = tokenDecimals;
    _maxSupply = maxSupply;
    blAddress = blAddress_;
}



//ritorna i decimali
     function decimals() public view override returns (uint8) {
        return _tokenDecimals;
    }
//ritorna la max supply
    function getMaxSupply() public view returns (uint256) {
        return _maxSupply;
    }
//ritorna il numero di token mintabili
    function remainingMintable() public view returns (uint256) {
        return getMaxSupply() - totalSupply();
    }

/*
  funzione che prima che il token venga mintato, burnato, trasferito
  controllo che l'inirizzo non sia blacklistato, se è blacklistato allora fa un revert
  e manda un messaggio di avviso che l'indirizzo è blacklistato
*/
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal view {
        amount;
        if(Blacklist(blAddress).isBlacklisted(from) || Blacklist(blAddress).isBlacklisted(to)) {
            revert("address is Blacklisted");
        }
    }
/*
 funzione di mint, accessibile solo all'owner, 
 controllo che l'indirizzo a cui sto mintando non sia blacklistato
 e che sia ancora possibile mintare i token
*/
    function mint(address account, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= getMaxSupply(), "Exceeds max supply");
        _mint(account, amount);
    } 

/*
 funzione di burn, accessibile solo all'owner,
 controllo che l'indirizzo a cui sto burnando non sia blacklistato
*/
    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }

/*
 funzione di trasferimento dal msg.sender all'indirizzo,
 se è blacklistato reverta.
 uso super perchè eredita da ERC20
 ritorna true se il transfer è andato a buon fine
*/
    function transfer(address to, uint256 value) public override returns(bool)  {
        _beforeTokenTransfer(msg.sender, to, value);
        super._transfer(msg.sender, to, value);
        return true;
    }

/*
  funzione di trasferimento che da a un altro indirizzo la possibilità di spostare il token
  da parte dell'owner. Se a chi viene data la possibilità di spostare il token o se l'indirizzo
  a cui è indirizzato è blacklistato allra reverta
*/
    function transferFrom(address from, address to, uint256 value) public override returns(bool) {
        _beforeTokenTransfer(from, to, value);
        super._transfer(from, to, value);
        return true;
    }
}



