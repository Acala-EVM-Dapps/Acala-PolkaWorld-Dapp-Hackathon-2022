// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// ----------------------------------------------------------------------------
// IBindingCurve contract
// ----------------------------------------------------------------------------

interface IBondingCurve {
    // Processing logic must implemented in subclasses

    function gasMint(uint256 x, uint256 y, uint256 gasFee) external pure returns(uint256 gas);

    function mining(uint256 tokens, uint256 totalSupply) external pure  returns(uint256 x, uint256 y);

    function gasBurn(uint256 x, uint256 y, uint256 gasFee) external pure returns(uint256 gas);

    function burning(uint256 tokens, uint256 totalSupply) external pure  returns(uint256 x, uint256 y);

}
