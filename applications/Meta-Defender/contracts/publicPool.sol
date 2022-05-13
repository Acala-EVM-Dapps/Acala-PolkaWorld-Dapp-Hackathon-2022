pragma solidity ^0.6.12;

//SPDX-License-Identifier: SimPL-2.0

interface ERC20token{
   function transferFrom(address _from, address _to, uint256 _value) external  returns (bool success);
   function transfer(address _to,uint256 _value) external returns (bool success);
   function balanceOf(address _address) external view returns (uint);
   function approve(address spender, uint256 amount) external returns (bool);
   function mint(address _to, uint256 amount) external returns (bool);

}

interface emergencyJudgeInterface{
    function judgement(bytes32 hash, bytes calldata signature1, bytes calldata signature2, bytes calldata signature3, uint value, address to) external returns(bool);
}

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

   
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract publicCapitalPool {
    
    using SafeMath for uint256;
    
    struct providerInfo{
        uint256 CPTstaked;
        uint256 rewardDebt;
    }
    
    uint256 public CPTstakedInPublicPool;
    uint256 public capitalInPublicPool;
    uint256 public totalCoverageSharedByPublic;
    uint256 public accumlatedRewardPerShare;
    
    address public operator;
    
    mapping(address => bool) private _isCPTprotocol;
    mapping(address => providerInfo) public providerMap;
    
    //while sCPT recipient is dex-pair or other addesses which should be excluded
    mapping(address => bool) private _isTreatedAsOperator;
    mapping(address => bool) private _isMiningAddress;
    
    bool private inCapitalProviding = false;
    bool private inCapitalTransfer = false;
    
    ERC20token CPT;
    ERC20token sCPT;
    emergencyJudgeInterface emergencyJudgement;
    
    constructor(address _CPTaddress, address _sCPTaddress , address _judger) public {
        operator = msg.sender;
        CPT = ERC20token(_CPTaddress);
        sCPT = ERC20token(_sCPTaddress);
        emergencyJudgement = emergencyJudgeInterface(_judger);
    }
    
    modifier onlyOperator {
        require(msg.sender == operator);
        _;
    }
    
    modifier onlyCPTprotocols() {
        require(_isCPTprotocol[msg.sender] == true);
        _;
    }
    
    modifier only_sCPT_contractAddress(){
        require(msg.sender == address(sCPT));
        _;
    }
    
    function defineCPTprotocols(address _address) external onlyOperator{
        _isCPTprotocol[_address] = true;
    }
    
    function transferOwnership(address _to) external onlyOperator{
        operator = _to;
    }
    
    function treatAsOperator(address _address) external onlyOperator{
        // such as dex-pair
        _isTreatedAsOperator[_address] = true;
    }
    
    function defineMiningAddress(address _address) external onlyOperator{
        _isMiningAddress[_address] = true;
    }
    
    function approveForCPTprotocols(address spender,uint256 value) external onlyOperator{
        require(_isCPTprotocol[spender] == true);
        CPT.approve(spender,value);
    }
    
    function useablePublicCapital() public view returns(uint256){
        uint256 result = capitalInPublicPool.sub(totalCoverageSharedByPublic);
        return result;
    }
    
    function capitalInPublicPoolDown(uint256 _down) external onlyCPTprotocols{
        capitalInPublicPool = capitalInPublicPool.sub(_down);
    }
    
    function totalCoverageSharedByPublicUp(uint256 _up) external onlyCPTprotocols{
        totalCoverageSharedByPublic = totalCoverageSharedByPublic.add(_up);
    }
    
    function totalCoverageSharedByPublicDown(uint256 _down) external onlyCPTprotocols{
        totalCoverageSharedByPublic = totalCoverageSharedByPublic.sub(_down);
    }
    
    function accumlatedRewardPerShareUp(uint256 _up) external onlyCPTprotocols{
        accumlatedRewardPerShare = accumlatedRewardPerShare.add(_up);
    }
    
    function earnedCPT(address _provider) public view returns(uint256){
        providerInfo storage provider = providerMap[_provider];
        uint256 result = provider.CPTstaked.mul(accumlatedRewardPerShare).div(1e12).sub(provider.rewardDebt);
        return result;
    }
    
    function provideCapital(uint256 _provideAmount) public {
        require(inCapitalProviding == false);
        inCapitalProviding = true;
        
        providerInfo storage provider = providerMap[msg.sender];
        if(provider.CPTstaked > 0){
            uint256 earned = earnedCPT(msg.sender);
            CPT.transfer(msg.sender,earned);
        }
        
        CPT.transferFrom(msg.sender,address(this),_provideAmount);
        sCPT.mint(msg.sender,_provideAmount);
        
        provider.CPTstaked = provider.CPTstaked.add(_provideAmount);
        provider.rewardDebt = provider.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        
        CPTstakedInPublicPool = CPTstakedInPublicPool.add(_provideAmount);
        capitalInPublicPool = capitalInPublicPool.add(_provideAmount);
        
        inCapitalProviding = false;
    }
    
    
    function transferCapitalShare(address transferor, address recipient, uint256 amount) external only_sCPT_contractAddress{
        require(inCapitalTransfer == false);
        inCapitalTransfer = true;
        
        if((!_isTreatedAsOperator[transferor] && !_isMiningAddress[transferor]) 
        && (!_isTreatedAsOperator[recipient] && !_isMiningAddress[recipient])){
            //comon address transfer to another common address
            _transferStandard(transferor,recipient,amount);
        }else if((!_isTreatedAsOperator[transferor] && !_isMiningAddress[transferor]) 
        && (_isTreatedAsOperator[recipient] && !_isMiningAddress[recipient])){
            //common address sell sCPT to dex-pair
            _transferToTreatedAsOperator(transferor,amount);
        }else if((_isTreatedAsOperator[transferor] && !_isMiningAddress[transferor]) 
        && (!_isTreatedAsOperator[recipient] && !_isMiningAddress[recipient])){
            //common address buy sCPT from dex-pair
            _transferFromTreatedAsOperator(recipient,amount);
        }else{}
        
        inCapitalTransfer = false;
    }
    
    function _transferStandard(address transferor, address recipient, uint256 amount) internal{
        providerInfo storage provider_transferor = providerMap[transferor];
        providerInfo storage provider_recipient = providerMap[recipient];
        
        require(provider_transferor.CPTstaked >= amount);
        
        //caculate earnedCPT of each side before param changement
        uint256 earnedCPTtransferor = earnedCPT(transferor);
        uint256 earnedCPTrecipient = earnedCPT(recipient);
        
        //update CPTstaked of each side
        provider_transferor.CPTstaked = provider_transferor.CPTstaked.sub(amount);
        provider_recipient.CPTstaked = provider_recipient.CPTstaked.add(amount);
        
        //update rewardDebt of each side
        provider_transferor.rewardDebt = provider_transferor.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        provider_recipient.rewardDebt = provider_recipient.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        
        CPT.transfer(transferor, earnedCPTtransferor);
        CPT.transfer(recipient, earnedCPTrecipient);
    }
    
    function _transferToTreatedAsOperator(address transferor, uint256 amount) internal {
        providerInfo storage provider_transferor = providerMap[transferor];
        providerInfo storage provider_operator = providerMap[operator];
        
        require(provider_transferor.CPTstaked >= amount);
        
        uint256 earnedCPTtransferor = earnedCPT(transferor);
        uint256 earnedCPToperator = earnedCPT(operator);
        
        provider_transferor.CPTstaked = provider_transferor.CPTstaked.sub(amount);
        provider_operator.CPTstaked = provider_operator.CPTstaked.add(amount);
        
        provider_transferor.rewardDebt = provider_transferor.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        provider_operator.rewardDebt = provider_operator.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        
        CPT.transfer(transferor,earnedCPTtransferor);
        CPT.transfer(operator,earnedCPToperator);
    }
    
    function _transferFromTreatedAsOperator(address recipient, uint256 amount) internal{
        providerInfo storage provider_operator = providerMap[operator];
        providerInfo storage provider_recipient = providerMap[recipient];
        
        require(provider_operator.CPTstaked >= amount);
        
        uint256 earnedCPToperator = earnedCPT(operator);
        uint256 earnedCPTrecipient = earnedCPT(recipient);
        
        provider_operator.CPTstaked = provider_operator.CPTstaked.sub(amount);
        provider_recipient.CPTstaked = provider_recipient.CPTstaked.add(amount);
        
        provider_operator.rewardDebt = provider_operator.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        provider_recipient.rewardDebt = provider_recipient.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        
        CPT.transfer(operator,earnedCPToperator);
        CPT.transfer(recipient,earnedCPTrecipient);
    }
    
    function takeReward() public {
        providerInfo storage provider = providerMap[msg.sender];
        require(provider.CPTstaked > 0);
        uint256 earned = earnedCPT(msg.sender);
        provider.rewardDebt = provider.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        CPT.transfer(msg.sender,earned);
    }
    
    function emergencyWithdraw(bytes32 hash, bytes calldata signature1, bytes calldata signature2, bytes calldata signature3,address to) external onlyOperator{
        uint256 value = CPT.balanceOf(address(this));
        require(
            emergencyJudgement.judgement(hash,signature1,signature2,signature3,value,to) == true
            );
        CPT.transfer(to,value);
    }
    
}