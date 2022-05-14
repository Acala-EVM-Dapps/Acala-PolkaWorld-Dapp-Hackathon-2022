pragma solidity ^0.5.17;


contract emergencyJudgement {
    
    address public judger1;
    address public judger2;
    address public judger3;
    
    mapping(bytes => bool) public signatureUsed;
    uint256 public judgeTime;
    
    constructor(address _judger1, address _judger2, address _judger3) public {
        judger1 = _judger1;
        judger2 = _judger2;
        judger3 = _judger3;
    }
    
    function transferPower1(address _to) external {
        require(msg.sender == judger1);
        judger1 = _to;
    }
    
    function transferPower2(address _to) external {
        require(msg.sender == judger2);
        judger2 = _to;
    }
    
    function transferPower3(address _to) external {
        require(msg.sender == judger3);
        judger3 = _to;
    }
    
    //所有要被签名的信息，先打包哈希，再加前缀总哈希
    function _getHashOfInputParams(uint value, address to) public view returns(bytes32) {
        bytes32 unPrefixedHash = keccak256(abi.encodePacked(value,judgeTime,to));//solidity sha3
        bytes32 prefixedHash = keccak256(abi.encodePacked( "\x19Ethereum Signed Message:\n32" , unPrefixedHash  )); //web3.eth.accounts.hashMessage
        return prefixedHash;
    }
    
    function judgement(bytes32 hash, bytes calldata signature1, bytes calldata signature2, bytes calldata signature3, uint value, address to) external returns(bool){
        //input signature was never used
        require(signatureUsed[signature1] != true && 
                signatureUsed[signature2] != true &&
                signatureUsed[signature3] != true);
        
        //make sure the value and recipient match the hash
        require( hash == _getHashOfInputParams(value,to) );
        
        //make sure the signature do be signed by judgers
        if(decode(hash,signature1) == judger1 &&
           decode(hash,signature2) == judger2 &&
           decode(hash,signature3) == judger3){
                judgeTime++;
                signatureUsed[signature1] = true;
                signatureUsed[signature2] = true;
                signatureUsed[signature3] = true;
                    return true;
                }else{
                    return false;
                }
        
    }
    
    
    function decode(bytes32 hash, bytes memory signature) public pure returns (address){
      
    bytes memory signedString = signature;

    bytes32  r = bytesToBytes32(slice(signedString, 0, 32));
    bytes32  s = bytesToBytes32(slice(signedString, 32, 32));
    byte  v = slice(signedString, 64, 1)[0];
    return ecrecoverDecode(hash, r, s, v);
  }

  //将原始数据按段切割出来指定长度
    function slice(bytes memory data, uint start, uint len) internal pure returns (bytes memory){
    bytes memory b = new bytes(len);

    for(uint i = 0; i < len; i++){
      b[i] = data[i + start];
    }

    return b;
   }

  //使用ecrecover恢复公匙
  function ecrecoverDecode(bytes32 hash, bytes32 r, bytes32 s, byte v1) internal pure returns (address addr){
     uint8 v = uint8(v1); //+ 27;
     
     addr = ecrecover(hash, v, r, s);
  }

  //bytes转换为bytes32
  function bytesToBytes32(bytes memory source) internal pure returns (bytes32 result) {
    assembly {
        result := mload(add(source, 32))
    }
  }
    
}