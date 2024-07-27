// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";
import {Blacklist} from "../src/Blacklist.sol";

contract TokenScript is Script {
    address public tokenAddress;
    address public blacklistAddress;

    function setUp() public {
        // Deploy the Token contract
        Token tokenContract = new Token("MyToken", "MTKN", 8, 10000000000*10**8, address(1), msg.sender);
        tokenAddress = address(tokenContract);

        // Deploy the Blacklist contract
        Blacklist blacklistContract = new Blacklist();
        blacklistAddress = address(blacklistContract);
    }

    function run() public {
        // Broadcast the addresses of the deployed contracts
        vm.broadcast(tokenAddress);
        vm.broadcast(blacklistAddress);
    }
}
