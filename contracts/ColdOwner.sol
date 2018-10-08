pragma solidity ^0.4.23;

contract ColdOwner {
    address public coldOwner;
    address public hotOwner;
    
    uint256 public things_done;

    constructor(address firstOwner) public {
        hotOwner = msg.sender;
        coldOwner = firstOwner;
    }

    function changeOwner(uint8 v, bytes32 r, bytes32 s, address newOwner) public {
        bytes memory prefix = "\x19Ethereum Signed Message:\n20";
        bytes32 message = keccak256(abi.encodePacked(prefix,newOwner));

        address signer = ecrecover(message, v+27, r, s);

        require(signer == coldOwner);
        coldOwner = newOwner;
    }

    function hotOwnerDoThings() public {
        require(msg.sender == hotOwner);
        things_done += 1;
    }
}
