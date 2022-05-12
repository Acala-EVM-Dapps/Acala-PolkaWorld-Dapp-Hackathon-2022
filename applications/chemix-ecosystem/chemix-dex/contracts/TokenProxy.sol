// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { StaticAccessControlled } from "./lib/StaticAccessControlled.sol";
import { TokenInteract } from "./lib/TokenInteract.sol";


/**
 * @title TokenProxy
 * @author dYdX
 *
 * Used to transfer tokens between addresses which have set allowance on this contract.
 */
contract TokenProxy is StaticAccessControlled {
    using SafeMath for uint256;

    // ============ Constructor ============

    constructor(
        //uint256 gracePeriod
    )
        StaticAccessControlled()
    {}

    // ============ Authorized-Only State Changing Functions ============

    /**
     * Transfers tokens from an address (that has set allowance on the proxy) to another address.
     *
     * @param  token  The address of the ERC20 token
     * @param  from   The address to transfer token from
     * @param  to     The address to transfer tokens to
     * @param  value  The number of tokens to transfer
     */
    function transferTokens(
        address token,
        address from,
        address to,
        uint256 value
    )
        external
        requiresAuthorization
    {
        TokenInteract.transferFrom(
            token,
            from,
            to,
            value
        );
    }

    // ============ Public Constant Functions ============

    /**
     * Getter function to get the amount of token that the proxy is able to move for a particular
     * address. The minimum of 1) the balance of that address and 2) the allowance given to proxy.
     *
     * @param  who    The owner of the tokens
     * @param  token  The address of the ERC20 token
     * @return        The number of tokens able to be moved by the proxy from the address specified
     */
    function available(
        address who,
        address token
    )
        external
        view
        returns (uint256)
    {
        return Math.min(
            TokenInteract.allowance(token, who, address(this)),
            TokenInteract.balanceOf(token, who)
        );
    }
}