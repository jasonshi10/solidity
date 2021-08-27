const Decentragram = artifacts.require("Decentragram");

module.exports = function(deployer){
  // deploys Decentragram smart contract to the blockchain
  deployer.deploy(Decentragram);
};
