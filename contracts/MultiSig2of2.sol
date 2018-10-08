pragma solidity ^0.4.23;

contract MultiSig2of2 {
    
    address public signer1;
    address public signer2;

    // The contract nonce is not accessible to the contract so we
    // implement a nonce-like variable for replay protection.
    uint256 public spendNonce = 0;

    constructor(address address1, address address2) public {
        signer1 = address1;
        signer2 = address2;
    }

    function() public payable { }

    function spend(address destination, uint256 value,
                   uint8 v1, bytes32 r1, bytes32 s1,
                   uint8 v2, bytes32 r2, bytes32 s2) public {

        require(address(this).balance >= value);
        
        address1 = getSigner(destination, value, v1, r1, s1);
        address2 = getSigner(destination, value, v2, r2, s2);
        require(address1 == signer1);
        require(address2 == signer2);
        
        spendNonce = spendNonce + 1;
        destination.transfer(value);
    }

    function getSigner(address destination, uint256 value,
                               uint8 v, bytes32 r, bytes32 s)
        private view returns (address) {
        bytes32 hashedUnsignedMessage = keccak256(abi.encodePacked(
                                        spendNonce, this, value, destination));

        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 message =  keccak256(abi.encodePacked(prefix,hashedUnsignedMessage));
        return ecrecover(message, v+27, r, s);
    }
}

