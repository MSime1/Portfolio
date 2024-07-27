const {expect} = require('chai');
const{
    BN,
    constants,
    expectEvent,
    expectRevert,
    time
} = require('@openzeppelin/test-helpers');
const {web3} = require('@openzeppelin/test-helpers/src/setup');
const {ZERO_ADDRESS} = constants;

const Wallet = artifacts.require("Wallet");
const Token = artifacts.require("Token");
const PriceConsumerV3 = artifacts.require("PriceConsumerV3");
//do indirizzi degli oracoli
const ethUsdContract = "0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419";
const azukiPriceContract = "0xA8B9A447C73191744D5B79BcE864F343455E1150";

const fromWei = (x) => web3.utils.fromWei(x.toString());
const toWei = (x) => web3.utils.toWei(x.toString());
const fromWei8Dec = (x) => Number(x) / Math.pow(10, 8);
const toWei8Dec = (x) => Number(x) * Math.pow(10, 8);
const fromWei2Dec = (x) => Number(x) / Math.pow(10, 2);
const toWei2Dec = (x) => Number(x) * Math.pow(10, 2);

contract('Wallet', function (accounts) {
    const [deployer , firstAccount, secondAccount] = accounts;
    


    it('Retrive contract', async function() {
        tokenContract = await Token.deployed()
        expect (tokenContract.address).to.be.not.equal(ZERO_ADDRESS);
        expect (tokenContract.address).to.match(/0x[0-9a-fA-F]{40}/);

        walletContract = await Wallet.deployed();

        priceEthUsd = await PriceConsumerV3.deployed();
      
    });

 
   it('distribuite some tokens from deployer', async function () {
    
       const amountToMint = web3.utils.toBN(web3.utils.toWei("1000000")); // Converti 1.000.000 token in wei
       await tokenContract.mint(deployer, amountToMint); // Esegui il mint dei token per il deployer

       //trasferisco
       await tokenContract.transfer(firstAccount, toWei(1000)); 
       await tokenContract.transfer(secondAccount, toWei(1500));
      //visualizzo i balance
       balDepl = await tokenContract.balanceOf(deployer);
       balFA = await tokenContract.balanceOf(firstAccount);
       balSA = await tokenContract.balanceOf(secondAccount);

        console.log(fromWei(balDepl), fromWei(balFA), fromWei(balSA));
    });

    it('Visualizzo ultimo prezzo ETH/USD', async function () {
        ret = await priceEthUsd.getDecimals();
        console.log(ret.toString());
        res = await priceEthUsd.getLatestPrice();
        console.log(fromWei8Dec(res))
    })

    it('Azuki in ETH', async function () {
        // Ottieni l'istanza del contratto
        azukiEthData = await PriceConsumerV3.deployed(); 

        // Ottieni i decimali di Azuki
        const decimals = await azukiEthData.getDecimals();
        console.log('Azuki Decimals:', decimals.toString());

        //Ottieni l'ultimo prezzo di Azuki in ETH
        const latestPrice = await azukiEthData.getLatestPrice();
        console.log('Latest Price of Azuki in ETH:', latestPrice.toString());
    });


    it('converte ETH in USD', async function () {

//conversione ETH in USD
    await walletContract.sendTransaction({from: firstAccount, value: toWei(2)})
    ret = await walletContract.convertEthinUsd(firstAccount)
    console.log(fromWei2Dec(ret));
//conversione USD in ETH
    ret = await walletContract.convertUsdinETH(toWei2Dec(5000));
    console.log(fromWei(ret));
//conversione NFT in USD
    ret = await walletContract.convertNFTPriceInUSD()
    console.log(fromWei2Dec(ret))
//converto USD in NFT

    ret = await walletContract.convertUSDinNFTAmount(toWei2Dec(5000))
    console.log(ret[1].toString(), fromWei2Dec(ret[1]))

    ret = await walletContract.convertUSDinNFTAmount(toWei2Dec(8000))
    console.log(ret[1].toString(), fromWei2Dec(ret[1]))
    })

    
});
