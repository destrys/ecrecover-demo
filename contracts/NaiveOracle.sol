pragma solidity ^0.4.23;

contract NaiveOracle {

    address private _oracle;
    address private _raidersWin;
    address private _raidersLose;
    int8    private _gameId;
    
    
    constructor(address oracle, address raidersWin, address raidersLose, uint8 gameId) public {
        _oracle = oracle;
        _raidersWin = raidersWin;
        _raidersLose = raidersLose;
        _gameId = gameId;
    }

    function register(uint8 v, bytes32 r, bytes32 s, uint8 raidersScore, uint8 otherScore) public {

        signer = getSigner(v, r, s, raiderScore, otherScore);
        require(signer == oracle);
        
        if (raiderScore > otherScore) {
            _raidersWin.transfer(this.balance);
        } else {
            _raidersLose.transfer(this.balance);
        }
    }
    
    function getSigner(uint8 v, bytes32 r, bytes32 s, raidersScore, otherScore)
        private view returns (address) {

        bytes32 hashedUnsignedMessage = keccak256(abi.encodePacked(_gameId, raidersScore, otherScore));

        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 message =  keccak256(abi.encodePacked(prefix,hashedUnsignedMessage));
        return ecrecover(message, v+27, r, s);
    }
}



