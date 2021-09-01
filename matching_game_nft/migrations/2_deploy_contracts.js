const MemoryToken = artifacts.require("MemoryToken");
// this script moves the contract on blockchain
module.exports = function(deployer) {
  deployer.deploy(MemoryToken);
};
