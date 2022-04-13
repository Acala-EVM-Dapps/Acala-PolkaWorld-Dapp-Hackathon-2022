// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IHotpot {
    /**
     * @dev setTreasury
     */
    function setTreasury(address account) external;

    /**
     * @dev Returns the amount of tokens presale.
     */
    function initialSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of the locked presale tokens owned by `account`.
     */
    function balanceOfLockedPresale(address account) external view returns (uint256);

    /**
     * @dev Returns the amount of the released presale tokens owned by `account`.
     */
    function balanceOfPresale(address account) external view returns (uint256);

    /**
     * @dev release the locked presale tokens by unique strategy
     */
    function releasePresale() external;
    /**
     * @dev Moves presale `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferPresale(address recipient, uint256 amount, uint256 lockTime, uint256 releaseTime) external;

    /**
     * @dev presaleStrategy
     */
    function presaleStrategy() external view returns (uint256 amount, uint256 lockTime, uint256 releaseTime, uint256 startTime, uint256 unit);

    /**
     * @dev setTreasuryFee
     */
    function setTreasuryFee( uint256 fee) external;

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event TransferPresale(address indexed from, address indexed to, uint256 value);

}
