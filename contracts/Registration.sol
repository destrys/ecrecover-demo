pragma solidity ^0.4.23;

contract Registration {

    address private authorizer;
    mapping(address => bool) private registeredUsers;
    
    constructor() public {
        authorizer = msg.sender;
    }

    function register(uint8 v, bytes32 r, bytes32 s) public {
        
        address signer = getSigner(v, r, s);

        require(signer == authorizer);

        registeredUsers[msg.sender] = true;
    }
    
    function getSigner(uint8 v, bytes32 r, bytes32 s)
        private view returns (address) {

        bytes memory prefix = "\x19Ethereum Signed Message:\n20";
        bytes32 message =  keccak256(abi.encodePacked(prefix,msg.sender));
        return ecrecover(message, v+27, r, s);
    }
}
