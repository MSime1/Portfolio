const Notarize = artifacts.require("Notarize");
//deploya il contratto. Esegui il deploy con un log che mi da l'indirizzo di deploy
module.exports = async function (deployer) {
    await deployer.deploy(Notarize);
    const noteAddress = await Notarize.deployed();
    console.log("Notarize contract to @: " + noteAddress.address)
};