pragma solidity ^0.4.23;

contract KillSwitch {
    address public owner;
    address public killer;
    
    bool public is_dead = false;
    uint256 public things_done;

    constructor(address killer) public {
        owner = msg.sender;
        killer = killer;
    }

    function kill(uint8 v, bytes32 r, bytes32 s) public {
        // require(msg.sender == owner)
        bytes memory prefix = "\x19Ethereum Signed Message:\n20";
        bytes32 message = keccak256(abi.encodePacked(prefix,this.address));

        address signer = ecrecover(message, v+27, r, s);

        require(signer == killer);
        is_dead = true;
    }

    function doThings() public {
        require(!is_dead);
        things_done += 1;
    }
}
