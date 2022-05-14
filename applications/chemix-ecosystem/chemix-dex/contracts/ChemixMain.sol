// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { IChemixFactory } from "./interface/IChemixFactory.sol";
import { ChemixStorage } from "./impl/ChemixStorage.sol";
import { Vault } from "./Vault.sol";
import { StaticAccessControlled } from "./lib/StaticAccessControlled.sol";

contract ChemixMain is 
    IChemixFactory,
    StaticAccessControlled,
    ReentrancyGuard
{
    using SafeMath for uint256;

    struct Env {
        address VAULT;
        address STORAGE;
        address FEETO;
        uint256 MINFEE;
    }
    Env env;

    constructor(
        address vault,
        address stateStorage,
        address feeTo,
        uint256 minFee
    )  
        StaticAccessControlled() 
    {
        env = Env({
            VAULT: vault,
            STORAGE: stateStorage,
            FEETO: feeTo,
            MINFEE: minFee
        });
    }

    function createPair(
        address quoteToken, 
        address baseToken
    ) 
        external 
        onlyCreatePairAddr
        nonReentrant
        override
        returns (bool successd) 
    {
        require(quoteToken != baseToken, 'Chemix: IDENTICAL_ADDRESSES');
        require(quoteToken != address(0) && baseToken != address(0), 'Chemix: ZERO_ADDRESS');
        require(!ChemixStorage(env.STORAGE).checkPairExist(quoteToken,baseToken), 'Chemix: PAIR_EXISTS');
        ChemixStorage(env.STORAGE).createNewPair(quoteToken,baseToken);
        return true;
    }

    function newLimitBuyOrder(
        address   quoteToken,
        address   baseToken,
        uint256   limitPrice,
        uint256   orderAmount
    )
        external
        nonReentrant
        payable
        returns (bool successed)
    {
        require(msg.value >= env.MINFEE, 'Chemix: msg.value less than MINFEE');
        require(ChemixStorage(env.STORAGE).checkPairExist(quoteToken,baseToken), 'Chemix: PAIR_NOTEXISTS');
        uint256 totalAmount = orderAmount.mul(limitPrice);
        Vault(env.VAULT).depositToVault(
            baseToken,
            msg.sender,
            totalAmount
        );

        Vault(env.VAULT).frozenBalance(baseToken, msg.sender, totalAmount);
        ChemixStorage(env.STORAGE).createNewOrder(
            quoteToken,
            baseToken,
            msg.sender,
            true,
            limitPrice,
            totalAmount
        );
        address payable addr = payable(env.FEETO);
        addr.transfer(msg.value);

        return true;
    }

    function newLimitSellOrder(
        address   quoteToken,
        address   baseToken,
        uint256   limitPrice,
        uint256   orderAmount
    )
        external
        nonReentrant
        payable
        returns (bool successed)
    {
        require(msg.value >= env.MINFEE, 'Chemix: msg.value less than MINFEE');
        require(ChemixStorage(env.STORAGE).checkPairExist(quoteToken,baseToken), 'Chemix: PAIR_NOTEXISTS');
        
        Vault(env.VAULT).depositToVault(
            quoteToken,
            msg.sender,
            orderAmount
        );

        Vault(env.VAULT).frozenBalance(quoteToken, msg.sender, orderAmount);
        ChemixStorage(env.STORAGE).createNewOrder(
            quoteToken,
            baseToken,
            msg.sender,
            false,
            limitPrice,
            orderAmount
        );
        address payable addr = payable(env.FEETO);
        addr.transfer(msg.value);

        return true;
    }

    function newCancelOrder(
        address   quoteToken,
        address   baseToken,
        uint256   orderIndex
    )
        external
        nonReentrant
        payable
        returns (bool successed)
    {
        require(msg.value >= env.MINFEE, 'Chemix: msg.value less than MINFEE');
        require(ChemixStorage(env.STORAGE).checkPairExist(quoteToken,baseToken), 'Chemix: PAIR_NOTEXISTS');
        require(ChemixStorage(env.STORAGE).checkIfIndexBelongs(msg.sender, orderIndex),'Chemix: OrderIndex not bolongs msg.sender');
  
        ChemixStorage(env.STORAGE).createCancelOrder(
            quoteToken,
            baseToken,
            msg.sender,
            orderIndex
        );

        return true;
    }

    function setFeeTo(
        address _feeTo
    ) 
        external 
        onlyOwner 
        override
    {
        env.FEETO = _feeTo;
    }

    function setMinFee(uint256 _minFee) external onlyOwner {
        env.MINFEE = _minFee;
    }
}