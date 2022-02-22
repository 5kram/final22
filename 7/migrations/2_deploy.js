const BobWallet = artifacts.require("BobWallet");
const MalloryAttack = artifacts.require("MalloryAttack");

module.exports = function (deployer) {
  deployer.deploy(BobWallet);
  deployer.deploy(MalloryAttack,{from: '0x428f11FACC7EA7c4A27E32218920fAd2ae37f008'});
};
