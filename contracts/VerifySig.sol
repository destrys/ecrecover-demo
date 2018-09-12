pragma solidity ^0.4.23;

contract VerifySig {
    address public owner;
    bool public is_verified = false;

    constructor() public {
        owner = msg.sender;
    }

    function verify(uint8 v, bytes32 r, bytes32 s) public {
        bytes memory prefix = "\x19Ethereum Signed Message:\n20";
        bytes32 message = keccak256(abi.encodePacked(prefix,owner));

        address signer = ecrecover(message, v+27, r, s);

        require(signer == owner);
        is_verified = true;
  }
}
