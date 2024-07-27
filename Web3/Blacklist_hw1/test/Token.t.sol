// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";
import {Blacklist} from "../src/Blacklist.sol";

contract TokenTest is Test {

    
Token public token; //contratto token
Blacklist public blacklistContract; //contratto blacklist
address public owner;
address public ZERO_ADDRESS = address(0);
address public spender = address(1);
address public user = address(2);
uint8 public decimals;
uint256 public maxSupply;
address public recipient = address(3);
string public name = "MyToken";
string public symbol = "MTKN";

function setUp() public {
  
    decimals = 8;
    maxSupply = 10000000000 * 10**8;
    owner = address(this); // Imposta l'indirizzo del contratto di test come proprietario

    // Crea un nuova istanza del contratto Blacklist
    blacklistContract = new Blacklist();

    // Imposta gli account da blacklistare, array da 2
    address[] memory blacklistedAccounts = new address[](2);
    blacklistedAccounts[0] = user;
    blacklistedAccounts[1] = spender;

    // Imposta la blacklist con gli account blacklistati
    blacklistContract.setBlacklist(blacklistedAccounts); //passa gli account blacklistati al contratto

    // Crea un nuovo contratto Token con l'indirizzo del contratto di blacklist come parametro
    token = new Token("MyToken", "MTKN", decimals, maxSupply, address(blacklistContract), owner);
//minto dei token all'owner per fare le operazioni
    token.mint(owner, 10000);

//Check per verificare che il contratto di test sia impostato come proprietario
    assertEq(token.owner(), owner);

}




    

    function testinitialState() public view {
        
        assertEq(token.name(), name);
        assertEq(token.symbol(), symbol);
        assertEq(token.owner(), owner);
        assertEq(token._maxSupply(), maxSupply);
        assertEq(token.decimals(), decimals);
    
       
    }

    
//trasferimento da owner a recipient
     function testTransfer() public {
        uint256 initialBalance = token.balanceOf(owner);
        vm.prank(owner);
        token.transfer(recipient, 1);
        assertEq(token.balanceOf(owner), initialBalance - 1);
        assertEq(token.balanceOf(recipient), 1);    
    }
//test per mintare
    function testMint() public returns (uint256){
        token.mint(owner, 10);
        return token.balanceOf(owner);
    }
//test del burn
    function testBurn() public returns (uint256) {
        token.burn (owner, 10);
        return token.balanceOf(owner);
    }

//test che ritorna la max supply
    function testGetmaxSupply() public view returns (uint256) {
        return token.getMaxSupply();
    }
// ritorno i decimali
    function testDecimals() public view returns (uint8) {
        return token.decimals();}
//ritorno i token ancora mintabili
    function testMintable() public view returns (uint256) {
        return token.remainingMintable();
    }
//provo a mintare da account non autorizzato
     function testFailUnauthorizedMinter(uint256 amount) public {
        vm.prank(user);
        token.mint(user, amount);
    }
//provo a burnare da account non autorizzato
    function testFailUnauthorizedBurner(uint256 amount) public {
        vm.prank(spender);
        token.burn(spender, amount);
    }
//provo a trasferire ad account blacklistato da recipient
    function testFailUnauthorizedTransfer(uint256 amount) public {
        vm.prank(user);
        token.transfer(recipient, amount);
    }
//provo a trasferire ad account blacklistato
    function testFailToBlacklistedTransfer(uint256 amount) public {
        vm.prank(owner);
        token.transfer(spender, amount);
    }

    function testFailMintToBlacklist() public {
        uint256 amount = 10;
        vm.prank(spender);
        token.mint(spender, amount);
    }
    
}


    
    




