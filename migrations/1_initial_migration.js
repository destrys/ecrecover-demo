var Migrations = artifacts.require("./Migrations.sol");
var VerifySig = artifacts.require("VerifySig");


module.exports = function(deployer) {
    deployer.deploy(Migrations);
    deployer.deploy(VerifySig);    
};
