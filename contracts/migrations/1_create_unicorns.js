const Unicorns = artifacts.require("Unicorns");

module.exports = function (deployer) {
  deployer.deploy(Unicorns);
};
