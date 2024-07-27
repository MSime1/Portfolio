// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceConsumerV3.sol";

contract Wallet is Ownable {
    //decimali del dollaro
    uint public constant usdDecimals = 2;
    //decimali di eth
    uint public constant ethDecimals = 18;
    //costo NFT
    uint public nftPrice;
    //ammontare ritirabile di eth dell'owner
    uint public ownerEthAmountToWithdraw;
    //ammontare ritirabile di token  dell'owner
    uint public ownerTokenAmountToWithdraw;
    //indirizzo dell'oracolo da ETH a USD
    address public oracleEthUsdPrice;
    //indirizzo dall'oracolo del token in ETH
    address public oracleTokenEthPrice;
    
    //indirizzo dell'oracolo da ETH a USD
    PriceConsumerV3 public ethUsdContract;
    //indirizzo dell'oracolo del token in ETH
    PriceConsumerV3 public tokenEthContract;

//mappo l'ammontare depositato per ogni utente
    mapping( address => uint256) public userEthDeposit;
//mappo l'ammontare depositato di token per ogni utente
    mapping( address => mapping(address=>uint256)) public userTokenDeposit;
//passo al costruttore gli indrizzi degli oracoli
    constructor (address clEthUsd, address clTokenUsd) {
        oracleEthUsdPrice = clEthUsd;
        oracleTokenEthPrice = clTokenUsd;

        ethUsdContract = new PriceConsumerV3(oracleEthUsdPrice);
        tokenEthContract = new PriceConsumerV3(oracleTokenEthPrice);
    }

    receive() external payable {
        registerUserDeposit(msg.sender, msg.value);
    }


//funzione che registra l'ammontare depositato
    function registerUserDeposit(address sender, uint256 value) internal {
        userEthDeposit[sender] += value;
    }
    
    
//funzione che restituisce il costo dell'NFT
    function getNFTPrice() external view returns (uint256) {
        uint256 price;
        int256 iPrice;
        AggregatorV3Interface nftOraclePrice = AggregatorV3Interface(oracleTokenEthPrice);
         (   /*1*/,
            iPrice,
            /*2*/,
            /*3*/,
            /*4*/
            ) = nftOraclePrice.latestRoundData();
            price = uint256(iPrice);
            return price;
    }
//funzione che converte l'ammontare di ETH in USD
    function convertEthinUsd(address user) public view returns (uint) {
        uint ethPriceDecimals = ethUsdContract.getDecimals();
        uint ethPrice = uint(ethUsdContract.getLatestPrice());
        uint divDecs = 18 + ethPriceDecimals - usdDecimals;
        uint userUSDDeposit = userEthDeposit[user] * ethPrice / (10 ** divDecs);
        return userUSDDeposit;
    }

//funzione che converte l'ammontare di USD in ETH
    function convertUsdinETH(uint usdAmount) public view returns (uint) {
        uint ethPriceDecimals = ethUsdContract.getDecimals();
        uint ethPrice = uint(ethUsdContract.getLatestPrice());
        uint mulDecs = 18 + ethPriceDecimals - usdDecimals;
        uint convertAmountInEth = usdAmount * (10**mulDecs) / ethPrice;
        return convertAmountInEth;
    }

//trasferisce gli ETH all'acquisto
    function transferETHAmountOnBuy(uint nftNumber) public {
        uint calcTotalUSDAmount = nftPrice + nftNumber * (10**2);
        uint ethAmountForBuying = convertUsdinETH(calcTotalUSDAmount);
        userEthDeposit[msg.sender] = ethAmountForBuying;
        ownerEthAmountToWithdraw = ethAmountForBuying;
    }

//converte costo NFT in USD
    function convertNFTPriceInUSD() public view returns (uint) {
        uint tokenPriceDecimals = tokenEthContract.getDecimals();
        uint tokenPrice = uint(tokenEthContract.getLatestPrice());

        uint ethPriceDecimals = ethUsdContract.getDecimals();
        uint ethPrice = uint(ethUsdContract.getLatestPrice());
        uint divDecs = tokenPriceDecimals + ethPriceDecimals - usdDecimals;

        uint tokenUSDPrice = tokenPrice * ethPrice / (10 ** divDecs);
        return tokenUSDPrice;
    }

//converte USD in NFT
    function convertUSDinNFTAmount (uint usdAmount) public view returns (uint, uint) {
        uint tokenPriceDecimals = tokenEthContract.getDecimals();
        uint tokenPrice = uint(tokenEthContract.getLatestPrice());

        uint ethPriceDecimals = ethUsdContract.getDecimals();
        uint ethPrice = uint(ethUsdContract.getLatestPrice());
        uint mulDecs = tokenPriceDecimals + ethPriceDecimals - usdDecimals;
        uint convertAmountInEth = usdAmount * ( 10 ** mulDecs) / ethPrice;
        uint convertEthInTokens = convertAmountInEth /  tokenPrice;


        uint totalCosts = convertEthInTokens * tokenPrice * ethPrice / (10 ** 24);
        uint remaningUSD = usdAmount - totalCosts;
        return (convertEthInTokens, remaningUSD);
    }

}