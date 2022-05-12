// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

interface IChemixFactory {
    function createPair(address tokenA, address tokenB) external returns (bool successd);
    function setFeeTo(address) external;
}
