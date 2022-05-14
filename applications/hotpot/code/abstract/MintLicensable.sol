// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "../interfaces/IBondingCurve.sol";

// ----------------------------------------------------------------------------
// MintLicensable contract
// ----------------------------------------------------------------------------
abstract contract MintLicensable {

    IBondingCurve _coinMaker;

    event CoinMakerChanged(address indexed _from, address indexed _to);
    
    function _changeCoinMaker(address newBonding) internal {
        _coinMaker = IBondingCurve(newBonding);
        emit CoinMakerChanged(address(_coinMaker), newBonding);
    }
    
    function _mining(uint256 tokens, uint256 totalSupply) internal view returns(uint256 x, uint256 y) {
        return _coinMaker.mining(tokens, totalSupply);
    }
    
    function _burning(uint256 tokens, uint256 totalSupply) internal view returns(uint256 x, uint256 y) {
        return _coinMaker.burning(tokens, totalSupply);
    }
    
    function _gasFeeMint(uint256 x, uint256 y, uint256 fee) internal view returns(uint256 gas) {
        return _coinMaker.gasMint(x, y, fee);
    }
    
    function _gasFeeBurn(uint256 x, uint256 y, uint256 fee) internal view returns(uint256 gas) {
        return _coinMaker.gasBurn(x, y, fee);
    }
    
    function getBondingCurve() public view returns(address) {
        return address(_coinMaker);
    }

}
