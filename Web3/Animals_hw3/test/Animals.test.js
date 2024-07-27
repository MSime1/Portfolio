const { expect } = require('chai');
const { BN, constants, expectEvent, expectRevert, time } = require('@openzeppelin/test-helpers');

const Animals = artifacts.require("Animals");

contract("Animals test", function (accounts) {
    let animalsContract;
    const baseUri = "https://green-binding-flea-592.mypinata.cloud/ipfs/Qme1DL2k8L5b6PY1hLZYHtRDMaGyugTf7Lv9ce9eExsyVn/";

    before(async function () {
        // Deploy contract
        animalsContract = await Animals.new();
        console.log("Animals deployed to:", animalsContract.address);
    });

    it("owner mint", async function () {
        await animalsContract.mint(accounts[1], 4, 5, "0x", { from: accounts[0] });
        await animalsContract.mint(accounts[2], 3, 6, "0x", { from: accounts[0] });
        console.log("minted");
    });

    it("owner batch-mint", async function () {
        await animalsContract.mintBatch(accounts[3], [4, 5], [5, 6], "0x", { from: accounts[0] });
        console.log("minted");
    });

    it("check uris", async function () {
        await animalsContract.setTokenUri(1, baseUri + "1.json", { from: accounts[0] });
        const uri = await animalsContract.getTokenUri(1);
        console.log(uri);
        console.log(baseUri)
    });
});
