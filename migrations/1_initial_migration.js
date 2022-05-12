const Migrations = artifacts.require("BlindBox");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
