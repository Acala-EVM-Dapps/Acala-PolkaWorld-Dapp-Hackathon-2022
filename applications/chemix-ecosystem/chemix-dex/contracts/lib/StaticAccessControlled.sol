// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { AccessControlledBase } from "./AccessControlledBase.sol";


/**
 * @title StaticAccessControlled
 * @author hellman
 *
 * Allows for functions to be access controled
 * Permissions cannot be changed after a grace period
 */
contract StaticAccessControlled is AccessControlledBase, Ownable {
    using SafeMath for uint256;

    // ============ Constructor ============

    constructor(
    )
        Ownable()
    {
    }

    // ============ Owner-Only State-Changing Functions ============

    function grantAccess(
        address who
    )
        external
        onlyOwner
    {
        emit AccessGranted(who);
        authorized[who] = true;
    }

    function revokeAccess(
        address who
    )
        external
        onlyOwner
    {
        emit RevokeGranted(who);
        authorized[who] = false;
    }

    function setCreatePairAddr(
        address who
    )
        external
        onlyOwner
    {
        emit SetCreatePairAddr(who);
        createPairAddr = who;
    }

    function setSettleAddr(
        address who
    )
        external
        onlyOwner
    {
        emit SetSettleAddr(who);
        settleAddr = who;
    }
}
