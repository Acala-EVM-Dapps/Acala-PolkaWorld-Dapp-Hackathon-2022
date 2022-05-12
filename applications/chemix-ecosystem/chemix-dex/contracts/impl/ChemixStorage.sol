// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { StaticAccessControlled } from "../lib/StaticAccessControlled.sol";
import { ChemixEvents } from "../impl/ChemixEvents.sol";

/**
 * @title ChemixStorage
 * @author Hellman
 *
 * This contract serves as the storage for the entire state of ChemixStorage
 */
contract ChemixStorage is 
    StaticAccessControlled,
    ChemixEvents
{

    struct OrderState {
        uint256   orderIndex;
        uint256   limitPrice;
        uint256   orderAmount;
        address   quoteToken;
        address   baseToken;
        address   orderUser;
        bytes32   hashData;
        bool      ordertype;
    }

    struct CancelOrderState {
        address   quoteToken;
        address   baseToken;
        address   orderUser;
        uint256   mCancelIndex;
        uint256   orderIndex;
        bytes32   hashData;
    }

    mapping(uint256 => OrderState) allOrder;
    mapping(uint256 => CancelOrderState) allCancelOrder;

    mapping(address => address) getPair;

    uint256 mOrderIndex = 0;
    uint256 mCancelIndex = 0;

    constructor(
    )
        StaticAccessControlled()
    {}

    function checkIfIndexBelongs(
        address user, 
        uint256 orderIndex
    )
        external
        view
        returns (bool)
    {
        return (allOrder[orderIndex].orderUser == user);
    }

    function getOrderIndex(
    )
        external
        view
        returns (uint256)
    {
        return mOrderIndex;
    }

    function getOrderInfoByIndex(
        uint256 orderIndex
    )
        external
        view
        returns (OrderState memory)
    {
        return allOrder[orderIndex];
    }

    function getCancelOrderInfoByIndex(
        uint256 cancelIndex
    )
        external
        view
        returns (CancelOrderState memory)
    {
        return allCancelOrder[cancelIndex];
    }

    function getCancelIndex(
    )
        external
        view
        returns (uint256)
    {
        return mCancelIndex;
    }

    function checkPairExist(
        address quoteToken,
        address baseToken
    )
        external
        view
        returns (bool)
    {
        return (getPair[quoteToken] == baseToken);
    }

    function checkHashData(
        uint256 index,
        bytes32 hashData
    )
        external
        view
        returns (bool)
    {
        return (allOrder[index].hashData == hashData);
    }

    function createNewPair(
        address quoteToken,
        address baseToken
    )
        external
        requiresAuthorization
    {
        getPair[quoteToken] = baseToken;
        emit PairCreated(quoteToken, baseToken);
    }

    function createNewOrder(
        address   quoteToken,
        address   baseToken,
        address   orderUser,
        bool      orderType,
        uint256   limitPrice,
        uint256   orderAmount
    )
        external
        requiresAuthorization
    {
        uint256 index = mOrderIndex;
        bytes32 preOrderHash = bytes32(0);
        if(mOrderIndex > 0){
            preOrderHash = allOrder[mOrderIndex - 1].hashData;
        }
        bytes32 newHashData = keccak256(abi.encodePacked(preOrderHash, orderUser, orderType, limitPrice, orderAmount));
        OrderState memory newOrder = OrderState({
            quoteToken: quoteToken,
            baseToken: baseToken,
            ordertype: orderType,
            orderIndex: index,
            limitPrice: limitPrice,
            orderAmount: orderAmount,
            orderUser:  orderUser,
            hashData: newHashData
        });
        allOrder[index] = newOrder;
        mOrderIndex += 1;
        emit NewOrderCreated(quoteToken, baseToken, newHashData, orderUser, orderType,
                index, limitPrice, orderAmount);
    }

    function createCancelOrder(
        address   quoteToken,
        address   baseToken,
        address   orderUser,
        uint256   orderIndex
    )
        external
        requiresAuthorization
    {
        uint256 index = mCancelIndex;
        bytes32 preCancelHash = bytes32(0);
        if(mCancelIndex > 0){
            preCancelHash = allOrder[mCancelIndex - 1].hashData;
        }
        bytes32 newHashData = keccak256(abi.encodePacked(preCancelHash, orderUser, orderIndex));
        CancelOrderState memory newCancelOrder = CancelOrderState({
            quoteToken: quoteToken,
            baseToken: baseToken,
            mCancelIndex: index,
            orderIndex: orderIndex,
            orderUser:  orderUser,
            hashData:   newHashData
        });
        allCancelOrder[index] = newCancelOrder;
        mCancelIndex += 1;
        emit NewCancelOrderCreated(quoteToken, baseToken, newHashData, orderUser,
                index, orderIndex);
    }
}