// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

// openzeppelin
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// diy
import "./abstract/MintLicensable.sol";
import "./abstract/HotpotMetadata.sol";
import "./interfaces/IBondingCurve.sol";


contract BondingSwap is IBondingCurve {

    using SafeMath for uint256;
    
    function fx(uint256 x) public pure returns(uint256) {
        return x.mul(x).div(10000).div(10 ** 18 );
    }
    
    // (x,y,mintFee)
    function gasMint(uint256, uint256 y, uint256 fee) public override pure returns(uint256 gas) {
        return y.mul(fee).div(10000);
    }
    
    // (x,y,burnFee)
    function gasBurn(uint256, uint256 y, uint256 fee) public override pure returns(uint256 gas) {
        return y.mul(fee).div(10000);
    }
    
    function mining(uint256 tokens, uint256 totalSupply) public override pure returns(uint256 x, uint256 y) {
        x = tokens;
        uint fx1 = fx(tokens.add(totalSupply));
        uint fx0 = fx(totalSupply);
        y = fx1.sub(fx0);
        return (x,y);
    }
    
    function burning(uint256 tokens, uint256 totalSupply) public override pure returns(uint256 x, uint256 y) {
        x = tokens;
        uint fx1 = fx(totalSupply);
        uint fx0 = fx(totalSupply.sub(tokens));
        y = fx1.sub(fx0);
        return (x,y);
    }

}


contract HotpotToken is Initializable, ERC20Upgradeable, OwnableUpgradeable , MintLicensable, HotpotMetadata {
    
    using SafeMath for uint;
    
    address public _treasury;
    address private _project = 0xDa9c964863EA9d156f1C39eA9874dd9aBE23A56E;

    uint public constant MAX_GAS_RATE_DENOMINATOR = 10000;
    uint private _treasuryMintFee = 100;
    uint private _treasuryBurnFee = 100;
    uint private _projectMintFee = 100;
    uint private _projectBurnFee = 100;
    

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(string memory name, string memory symbol, address treasury,uint mintRate,uint burnRate,address owner) initializer{
    
        __ERC20_init(name, symbol);
        _treasury = treasury;

        _setTaxRate(mintRate, burnRate);
        _transferOwnership(owner);

        BondingSwap curve = new BondingSwap();
        _changeCoinMaker(address(curve));
        
    }
    
    function _setTaxRate(uint mintRate,uint burnRate) private {
        require(mintRate>=0&&mintRate<=MAX_GAS_RATE_DENOMINATOR, "SetTax: Invalid number");
        require(burnRate>=0&&burnRate<=MAX_GAS_RATE_DENOMINATOR, "SetTax: Invalid number");
        _treasuryMintFee = mintRate;
        _treasuryBurnFee = burnRate;
        emit TaxChanged(mintRate, burnRate);
    }

    function setTaxRate(uint mintRate,uint burnRate) public onlyOwner {
        _setTaxRate(mintRate, burnRate);
    }

    function setTreasury(address account) external virtual onlyOwner{
      _treasury = account;
    }

    function getTaxRate() public view returns(uint mintRate,uint burnRate) {
        return (_treasuryMintFee,_treasuryBurnFee);
    }
    
    function setMetadata(string memory url) external virtual onlyOwner {
        _setMetadata(url);
    }
    
    /**
     * @dev mint
     */
    function mint(address to, uint tokens) public payable {
        // Calculate the actual amount through Bonding Curve
        uint x;
        uint y;
        (x, y)= _mining(tokens, totalSupply());
        require(x > 0 && y > 0, 'Mint: token amount is too low');

        uint mintFee = _gasFeeMint(x, y, _treasuryMintFee);
        uint projectFee = y.mul(_projectMintFee).div(MAX_GAS_RATE_DENOMINATOR);
        uint need = y.add(mintFee).add(projectFee);
        require(need <= msg.value, 'Mint: value is too low');
        _mint(to,x);

        payable(_treasury).transfer(mintFee);
        payable(_project).transfer(projectFee);
        // The extra value is transferred to the sender itself
        uint left = (msg.value).sub(need);
        if(left > 0) {
            payable(msg.sender).transfer(left);
        }

        emit Mined(to, x, y);
    }

    /**
     * @dev testMint
     */
    function estimateMint(uint tokens) public view returns (uint x, uint y, uint gasMint) {
        (x, y) = _mining(tokens, totalSupply());
        gasMint = _gasFeeMint(x, y, _treasuryMintFee);
        gasMint = gasMint.add((y.mul(_projectMintFee).div(MAX_GAS_RATE_DENOMINATOR)));
        return (x, y, gasMint);
    }

    /**
     * @dev burn
     */
    function burn(address to,uint tokens) public payable {
        // Calculate the actual amount through Bonding Curve
        address from = msg.sender;
        uint x;
        uint y;
        (x, y) = _burning(tokens, totalSupply());
        require(x > 0 && y > 0, 'Balance: token amount is too low');

        uint burnFee = _gasFeeBurn(x, y, _treasuryBurnFee);
        uint projectFee = y.mul(_projectBurnFee).div(MAX_GAS_RATE_DENOMINATOR);
        uint left = y.sub(burnFee).sub(projectFee);

        require(balanceOf(from) >= x &&address(this).balance >= y, 'Balance: balance is not enough');
        _burn(from,x);

        payable(_treasury).transfer(burnFee);
        payable(_project).transfer(projectFee);
        payable(to).transfer(left);

        emit Burned(from, x, y);
    }

    function estimateBurn(uint tokens) public view returns (uint x, uint y, uint gasBurn) {
        (x, y) = _burning(tokens, totalSupply());
        gasBurn = _gasFeeBurn(x, y, _treasuryBurnFee);
        gasBurn = gasBurn.add((y.mul(_projectBurnFee).div(MAX_GAS_RATE_DENOMINATOR)));
        return (x, y, gasBurn);
    }

    event TaxChanged(uint mintRate, uint burnRate);
    
    event Mined(address indexed _to, uint tokens, uint binded);

    event Burned(address indexed _from, uint tokens, uint binded);
}

