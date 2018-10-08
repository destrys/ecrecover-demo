pragma solidity ^0.4.23;

contract TimeClock {

    mapping(address => bool) private workers;
    mapping(address => bool) private clockedIn;
    mapping(address => uint64) private lastClockedIn;
    mapping(address => uint64) private lastClockedOut
    
    constructor(address firstWorker) public {
        workers[firstWorker] = true;
    }

    event ClockIn(address worker, uint64 blockIn);
    event ClockOut(address worker, uint64 blockOut);
    
    function clockIn(uint64 blockIn, uint8 v, bytes32 r, bytes32 s) public {

        require(blockIn < block.number);
        
        signer = getSigner(blockIn, v, r, s);

        require(workers[signer]);
        require(!clockedIn[signer]);
        require(blockIn > lastClockedOut[signer]);

        emit ClockIn(signer, blockIn);
        clockedIn[signer] = true;
        lastClockedIn[signer] = blockIn;
    }

    function clockOut(uint64 blockOut, uint8 v, bytes32 r, bytes32 s) public {

        require(blockOut < block.number);
        
        signer = getSigner(blockOut, v, r, s);

        require(workers[signer]);
        require(clockedIn[signer]);
        require(blockIn > lastClockedIn[signer]);

        emit ClockOut(signer, blockOut);
        clockedIn[signer] = false;
        lastClockedOut[signer] = blockOut;
    }
    
    function getSigner(uint64 blockNumber, uint8 v, bytes32 r, bytes32 s)
        private view returns (address) {
        bytes32 hashedUnsignedMessage = keccak256(abi.encodePacked(
                                        this, blockNumber));

        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 message =  keccak256(abi.encodePacked(prefix,hashedUnsignedMessage));
        return ecrecover(message, v+27, r, s);
    }
}
