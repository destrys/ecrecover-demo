// written with web3.version.api == 0.20.6
const VerifySig = artifacts.require("VerifySig");
let catchRevert = require("./exceptions.js").catchRevert;


// Helper function to parse signature returned from web3 (<1.0)
// into v, r, s coordinates
function parse_signature(signature) {
    // this signature starts with 0x, we don't want that...
    // but we do want v,r,s to each have the 0x prefix...
    let r = "0x" + signature.substring(2,66);
    let s = "0x" + signature.substring(66,130);
    let v = "0x" + signature.substring(130,132);
    console.log("Signature: ",signature);
    console.log("R: ", r);
    console.log("S: ", s);
    console.log("V: ", v);
    return {
        r: r,
        s: s,
        v: v
    }
}


contract('VerifySig: When first deployed...', function(accounts) {

    it("should set owner to deploying address", async () => {
        let instance = await VerifySig.deployed();
        let owner = await instance.owner();
        assert.equal(owner, accounts[0]);
    });

    it("should set is_verified to false", async () => {
        let instance = await VerifySig.deployed();
        let is_verified = await instance.is_verified.call();
        assert.equal(is_verified, false);
    });
    
})

contract('VerifySig: When verifying...', function(accounts) {

    it("should set is_verified to true if signature is correct", async () => {
        let signature = web3.eth.sign(accounts[0], accounts[0]);
        let vrs = parse_signature(signature);
        
        let instance = await VerifySig.deployed();
        await instance.verify(vrs.v, vrs.r, vrs.s);
        let is_verified = await instance.is_verified.call();        
        assert.equal(is_verified, true);
    });

    it("should revert if signed by wrong address", async () => {
        let signature = web3.eth.sign(accounts[1], accounts[0]);
        let vrs = parse_signature(signature);
        
        let instance = await VerifySig.deployed();
        await catchRevert(instance.verify(vrs.v, vrs.r, vrs.s));
    });

    it("should revert if signing wrong message", async () => {
        let signature = web3.eth.sign(accounts[0], accounts[1]);
        let vrs = parse_signature(signature);
        
        let instance = await VerifySig.deployed();
        await catchRevert(instance.verify(vrs.v, vrs.r, vrs.s));
    });

})

