const Animals = artifacts.require("Animals");
//deploya il contratto. Esegui il deploy con un log che mi da l'indirizzo di deploy
module.exports = async function (deployer) {
    await deployer.deploy(Animals);
    const noteAddress = await Animals.deployed();
    console.log("Animals contract to @: " + noteAddress.address)
};