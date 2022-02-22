const MovieToken = artifacts.require("MovieToken");

module.exports = function (deployer) {
  deployer.deploy(MovieToken, {value: 10000000000000000000});
};