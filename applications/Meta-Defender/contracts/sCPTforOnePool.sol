pragma solidity ^0.5.1;

interface CptPool{
    function transferCapitalShare(address transferor, address recipient, uint256 amount) external;
}


contract SafeMath {
   function safeAdd(uint a, uint b) public pure returns (uint c) {
       c = a + b;
       require(c >= a);
   }
   function safeSub(uint a, uint b) public pure returns (uint c) {
       require(b <= a);
       c = a - b;
   }
   function safeMul(uint a, uint b) public pure returns (uint c) {
       c = a * b;
       require(a == 0 || c / a == b);
   }
   function safeDiv(uint a, uint b) public pure returns (uint c) {
       require(b > 0);
       c = a / b;
   }
}


contract sCptForSingle is SafeMath {
    string public name ;
    string public symbol ;
    uint8 public decimals=18 ;  
    uint256 public totalSupply;
    address private tokenFactory;
    address private owner;
    bool public factoryInitialized = false;
    
    CptPool pool = CptPool(tokenFactory);
 
    mapping (address => uint256) public balanceOf;
 
    mapping (address => mapping (address => uint256)) public allowance;
    

    event Transfer(address indexed from, address indexed to, uint256 value);

 
    event Burn(address indexed from, uint256 value);


    constructor (uint256 _totalSupply, string memory _name, string memory _symbol) public {
        totalSupply = _totalSupply;  
        balanceOf[msg.sender] = totalSupply;                
        name = _name;                                  
        symbol = _symbol;                               
        owner = msg.sender;
    }

    modifier onlyowner() {
    require(msg.sender == owner);   
     _;
  } 
  
    modifier onlyFactory(){
        require(msg.sender == tokenFactory);
        _;
    }
    
    function initializeFactory(address _factory) external onlyowner {
        require(factoryInitialized == false);
        tokenFactory = _factory;
        factoryInitialized = true;
    }
  
    function mint(address _to, uint256 amount) external onlyFactory returns(bool) {
        totalSupply = safeAdd(totalSupply,amount);
        balanceOf[_to] = safeAdd(balanceOf[_to],amount);
        return true;
    }
  

    function _transfer(address _from, address _to, uint _value) internal {
        
        require(_to != address(0));
        
        require(balanceOf[_from] >= _value);
    
        require(balanceOf[_to] + _value > balanceOf[_to]);

        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] = safeSub(balanceOf[_from],_value) ;
        // Add the same to the recipient
        balanceOf[_to] = safeAdd(balanceOf[_to] , _value);
        pool.transferCapitalShare(_from,_to, _value);
        emit  Transfer(_from, _to, _value);

        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }


    function transfer(address _to, uint256 _value) public returns (bool) {
        _transfer(msg.sender, _to, _value);
       return true;
    }


    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender] , _value);
        _transfer(_from, _to, _value);
        return true;
    }


    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

}  

