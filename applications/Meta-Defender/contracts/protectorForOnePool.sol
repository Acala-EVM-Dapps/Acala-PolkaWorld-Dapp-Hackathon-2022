pragma solidity ^0.6.12;

//SPDX-License-Identifier: SimPL-2.0

interface ERC20token{
   function transferFrom(address _from, address _to, uint256 _value) external  returns (bool success);
   function transfer(address _to,uint256 _value) external returns (bool success);
   function balanceOf(address _address) external view returns (uint);
   function approve(address spender, uint256 amount) external returns (bool);
   function mint(address _to, uint256 amount) external returns (bool);

}

interface publicCapitalPoolInterface{
    function useablePublicCapital() external view returns(uint);
    function CPTstakedInPublicPool() external view returns(uint);
    function capitalInPublicPoolDown(uint256 _down) external;
    function totalCoverageSharedByPublicUp(uint256 _up) external;
    function totalCoverageSharedByPublicDown(uint256 _down) external;
    function accumlatedRewardPerShareUp(uint256 _up) external;
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


contract cryptoProtectorInstance {
    
    using SafeMath for uint256;
    
    struct providerInfo{
        uint256 CPTstaked;
        uint256 rewardDebt;
    }
    
    struct policyInfo{
        address beneficiary;
        uint256 id;
        uint256 coverage; // policy coverage
        uint256 coverageSharedByThis;
        uint256 coverageSharedByPublicPool;
        uint256 startTime;
        uint256 effectiveUntil;
        bool isClaimed;
        bool inClaimApplying;
    }
    
    policyInfo[] public policies; //all the policies ever existed 
    policyInfo[] public policiesInClaimApplying;
    
    event PolicyMade( uint256 id, uint256 _coverage, uint256 effectiveUntil);
    event AppicationMade(uint256 id, uint256 _coverage, uint256 effectiveUntil);
    
    address public operator;
    address private robot;
    
    //while sCPT recipient is dex-pair or other addesses which should be excluded
    mapping(address => bool) private _isTreatedAsOperator;
    mapping(address => bool) private _isMiningAddress;
    
    mapping( address => providerInfo) public providerMap; //details about each provider
    mapping( address => uint256) public beneficiaryPolicyCount; //how many policies a beneficiary hold
   
    uint256 public policyCount = 0; // the number of policies ever be minted in this contract
    
    uint256 public CPTstakedHere;
    uint256 public capitalInThispool;
    uint256 private accumlatedRewardPerShare = 0;
    uint256 private totalCoverage; //aka occupied capital here;
    uint256 private totalCoverageSharedByThis;
    uint256 public kLast;
    
    
    //protect the contract from reentrancy attack
    bool private inCapitalProviding = false;
    bool private inCapitalTransfer = false;
    
    ERC20token CPT;
    ERC20token sCPTforThis;
    publicCapitalPoolInterface publicPool;
    emergencyJudgeInterface emergencyJudgement;
    
    constructor(address _CPTaddress, address _stakedCPTaddress, address _publicPool,address _judger) public {
        operator = msg.sender;
        CPT = ERC20token(_CPTaddress);
        sCPTforThis = ERC20token(_stakedCPTaddress);
        publicPool = publicCapitalPoolInterface(_publicPool);
        emergencyJudgement = emergencyJudgeInterface(_judger);
    }
    
    modifier onlyOperator() {
        require(msg.sender == operator);
        _;
    }
    
    modifier only_sCPTforThis_contractAddress() {
        require(msg.sender == address(sCPTforThis));
        _;
    }
    
    modifier onlyRobot(){
        require(msg.sender == robot);
        _;
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
    
    function defineRobot(address _robot) external onlyOperator{
        robot = _robot;
    }
    
    function _caculateUseableCapital() public view returns(uint256) {
        uint256 r1 = publicPool.useablePublicCapital();
        uint256 r2 = capitalInThispool.sub(totalCoverageSharedByThis);
        uint256 r = r1.add(r2);
        return r;
    }
    
    //fee rate at least 3
    //show feeRate at front end by this function
    function caculateFeeRate() public view returns(uint256) {
        
        uint256 useableCapital = _caculateUseableCapital();
       
        if(useableCapital == 0){
            return 3;
        }
        
        uint256 tentativeRate = kLast.mul(100).div(useableCapital);
        if(tentativeRate >= 3){
            return tentativeRate;
        }else{
            return 3;
        }
    }
    
    //caculate feeRate with given param of useableCapital
    //in order not to caculate useableCapital again sometimes
    function _caculateFeeRateInternal(uint256 useableCapital) internal view returns(uint256){
        if(useableCapital == 0){
            return 3;
        }
        uint256 tentativeRate = kLast.mul(100).div(useableCapital);
        if(tentativeRate >= 3){
            return tentativeRate;
        }else{
            return 3;
        }
    }
    
    
    function _updateKLast(uint256 useableCapital) internal {
        
        uint256 tentativeRate = kLast.mul(100).div(useableCapital);
        if(tentativeRate >= 3){
            return;
        }else{
            kLast = useableCapital.mul(3).div(100);
        }
        
    }
    
    //caculatePolicyFee at front end 
    function caculatePolicyFee(uint256 _coverage, uint256 period) public view returns(uint256){
        require(period == 90 || period == 180 || period == 360, "ilegal period");
        
        uint256 useableCapital = _caculateUseableCapital();
        require(_coverage <= useableCapital.mul(5).div(100), "coverage exceeds 5% of useableCapital");// each policy coverage less than 5% of current useable capital
        
        uint256 _feeRate = _caculateFeeRateInternal(useableCapital);
        return _coverage.mul(_feeRate).mul(period).div(360).div(100);
    }
    
    
    function insure(uint256 _coverage, uint256 period) public {
        
        require(period == 90 || period == 180 || period == 360, "ilegal period");
        uint256 policyFee;
        
        //updateK first
        
        uint256 useableCapital = _caculateUseableCapital();
        require(_coverage <= useableCapital.mul(5).div(100), "coverage exceeds 5% of useableCapital");
        uint256 tentativeRate = kLast.mul(100).div(useableCapital);
        
        if(tentativeRate >= 3){
            policyFee = _coverage.mul(tentativeRate).mul(period).div(360).div(100);
        }else{
            policyFee = _coverage.mul(3).mul(period).div(360).div(100);
            kLast = useableCapital.mul(3).div(100);
        }
        
        uint256 totalCPTstaked = CPTstakedHere.add(publicPool.CPTstakedInPublicPool());
        uint256 fee1 = policyFee.mul(CPTstakedHere).div(totalCPTstaked);
        uint256 fee2 = policyFee.sub(fee1);
        
        CPT.transferFrom(msg.sender, address(this), policyFee);
        CPT.transfer(address(publicPool),fee2);
        
        uint256 coverage1 = _coverage.mul(CPTstakedHere).div(totalCPTstaked);
        uint256 coverage2 = _coverage.sub(coverage1);
        
        uint256 coveredPeriod = period.mul(86400);
        
        policies.push(policyInfo({
            beneficiary : msg.sender,
            id : policyCount,
            coverage : _coverage,
            coverageSharedByThis : coverage1,
            coverageSharedByPublicPool : coverage2,
            startTime : now,
            effectiveUntil : now.add(coveredPeriod),
            isClaimed : false,
            inClaimApplying : false
        }));
        
        policyCount++;
        beneficiaryPolicyCount[msg.sender]++;
        
        totalCoverage = totalCoverage.add(_coverage);
        totalCoverageSharedByThis = totalCoverageSharedByThis.add(coverage1);
        publicPool.totalCoverageSharedByPublicUp(coverage2);
        
        uint256 deltaAcc = policyFee.mul(1e12).div(totalCPTstaked); 
        accumlatedRewardPerShare = accumlatedRewardPerShare.add(deltaAcc);
        publicPool.accumlatedRewardPerShareUp(deltaAcc);
        
        emit PolicyMade(policyCount-1, _coverage, now.add(coveredPeriod) );
    }
    
    // caculate policyFee each capital provider has earned
    function earnedCPT(address _provider) public view returns(uint256) {
        providerInfo storage provider = providerMap[_provider];
        uint256 result = provider.CPTstaked.mul(accumlatedRewardPerShare).div(1e12).sub(provider.rewardDebt);
        return result;
    }
    
    function getPoliciesByBeneficiary(address _beneficiary) public view returns(uint256[] memory){
        uint256[] memory result = new uint256[](beneficiaryPolicyCount[_beneficiary]);
        
        uint256 counter = 0;
        for(uint256 i = 0; i < policies.length; i++){
            if(policies[i].beneficiary == _beneficiary){
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    
    function transferPolicy(address to, uint256 id) public {
        policyInfo storage policy = policies[id];
        require(policy.beneficiary == msg.sender); // only the owner of this policy can do this
        require(now < policy.effectiveUntil); // only effective policy can be transfered
        require(policy.isClaimed == false); // only unclaimed policy can be transfered
        
        beneficiaryPolicyCount[msg.sender] --;
        policy.beneficiary = to;
        beneficiaryPolicyCount[to]++;
    }
    
    function showPolicyDetails(uint256 _id) public view returns(uint256,uint256,uint256,bool,bool){
        policyInfo storage policy = policies[_id];
        return(policy.coverage, policy.startTime, policy.effectiveUntil, policy.isClaimed, policy.inClaimApplying);
    }
    
    function claimApplication(uint256 _id) public{
        policyInfo storage policy = policies[_id];
        require(policy.beneficiary == msg.sender); // only policy owner can apply
        require(now < policy.effectiveUntil); //effective or not
        require(policy.isClaimed == false);
        require(policy.inClaimApplying == false);
        policy.inClaimApplying = true;
        policiesInClaimApplying.push(policy);
        emit AppicationMade(_id, policy.coverage, policy.effectiveUntil);
    }
    
    function _doCoverageSub(policyInfo storage policy) internal {
        totalCoverage = totalCoverage.sub(policy.coverage);
        totalCoverageSharedByThis = totalCoverageSharedByThis.sub(policy.coverageSharedByThis);
        publicPool.totalCoverageSharedByPublicDown(policy.coverageSharedByPublicPool);
    }
    
    function _tryCoverageSub(policyInfo storage policy) internal {
        if(policy.effectiveUntil>=now){return;}
        if(policy.isClaimed == true){return;}
        if(policy.inClaimApplying == true){return;}
        _doCoverageSub(policy);
    }
    
    function acceptClaimApplication(uint256 _id) external onlyOperator {
        policyInfo storage policy = policies[_id];
        require(policy.isClaimed == false && policy.inClaimApplying == true);
        policy.isClaimed = true;
        
        capitalInThispool = capitalInThispool.sub(policy.coverageSharedByThis);
        publicPool.capitalInPublicPoolDown(policy.coverageSharedByPublicPool);
        
        _doCoverageSub(policy);
        
        CPT.transfer(policy.beneficiary, policy.coverageSharedByThis);
        CPT.transferFrom(address(publicPool), policy.beneficiary, policy.coverageSharedByPublicPool );
    }
    
    function refuseClaimApplication(uint256 _id) external onlyOperator {
        policyInfo storage policy = policies[_id];
        require(policy.isClaimed == false && policy.inClaimApplying == true);
        policy.inClaimApplying = false;
        
        _tryCoverageSub(policy);
    }
    
    function coverageSubstractionExternal(uint256 _id) external onlyRobot {
        policyInfo storage policy = policies[_id];
        _tryCoverageSub(policy);
    }
    
    function provideCapital(uint256 _providedAmount) public {
        require(inCapitalProviding == false);
        inCapitalProviding = true;
        
        providerInfo storage provider = providerMap[msg.sender];
        if(provider.CPTstaked > 0){
            uint256 earned = earnedCPT(msg.sender);
            CPT.transfer(msg.sender, earned);
        }
        
        CPT.transferFrom(msg.sender, address(this), _providedAmount);
        sCPTforThis.mint(msg.sender, _providedAmount);
        
        provider.CPTstaked = provider.CPTstaked.add(_providedAmount);
        provider.rewardDebt = provider.CPTstaked.mul(accumlatedRewardPerShare).div(1e12);
        CPTstakedHere = CPTstakedHere.add(_providedAmount);
        capitalInThispool = capitalInThispool.add(_providedAmount);
        uint256 useableCapital = _caculateUseableCapital();
        _updateKLast(useableCapital);
        
        inCapitalProviding = false;
    }
    
    
    
    function transferCapitalShare(address transferor, address recipient, uint256 amount) external only_sCPTforThis_contractAddress {
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
    
    function _transferStandard(address transferor, address recipient, uint256 amount) internal {
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
    
    //while transfer capital to excluded address, equals transfering to operator
    function _transferToTreatedAsOperator(address transferor, uint256 amount) internal{
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
    
    //while transfer capital from excluded address, equals transfering from operator
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
    
    //withdraw the left CPTs while emergency
    function emergencyWithdraw(bytes32 hash, bytes calldata signature1, bytes calldata signature2, bytes calldata signature3,address to) external onlyOperator {
        uint256 value = CPT.balanceOf(address(this));
        require(
            emergencyJudgement.judgement(hash,signature1,signature2,signature3,value,to) == true
            );
        CPT.transfer(to,value);
    }
    
    
}