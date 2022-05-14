// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


/**
 * @title MarginEvents
 * @author dYdX
 *
 * Contains events for the Margin contract.
 *
 * NOTE: Any Margin function libraries that use events will need to both define the event here
 *       and copy the event into the library itself as libraries don't support sharing events
 */
contract ChemixEvents {
    // ============ Events ============

    event PairCreated(address indexed quoteToken, address indexed baseToken);
    event NewOrderCreated(address indexed quoteToken, address indexed baseToken,
                            bytes32 indexed hashData, address orderUser, bool side, uint256 orderIndex,
                            uint256 limitPrice, uint256 orderAmount);
    event NewCancelOrderCreated(address indexed quoteToken, address indexed baseToken,
                                bytes32 indexed hashData, address cancelUser, uint256 mCancelIndex, uint256 orderIndex);
}
