// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { TokenProxy } from "./TokenProxy.sol";
import { StaticAccessControlled } from "./lib/StaticAccessControlled.sol";
import { TokenInteract } from "./lib/TokenInteract.sol";
import { ChemixStorage } from "./impl/ChemixStorage.sol";

/**
 * @title Vault
 * @author dYdX
 *
 * Holds and transfers tokens in vaults denominated by id
 *
 * Vault only supports ERC20 tokens, and will not accept any tokens that require
 * a tokenFallback or equivalent function (See ERC223, ERC777, etc.)
 */
contract Vault is
    StaticAccessControlled,
    ReentrancyGuard
{
    using SafeMath for uint256;

    // ============ Events ============

    event ExcessTokensWithdrawn(
        address indexed token,
        address indexed to,
        address caller
    );

    event ThawBalance(
        address indexed token,
        address indexed from,
        uint256 amount
    );

    event Settlement(
        address indexed quoteToken,
        address indexed baseToken,
        bytes32 indexed hashData
    );

    struct Asset {
        uint256 frozenBalace;
        uint256 availableBalance;
    }

    struct settleValues {
        address  user;
        bool     positiveOrNegative1;
        uint256  incomeQuoteToken;
        bool     positiveOrNegative2;
        uint256  incomeBaseToken;
    }

    // ============ State Variables ============

    // Address of the TokenProxy contract. Used for moving tokens.
    address public TOKEN_PROXY;
    address public STORAGE;
    // Map from vault ID to map from token address to amount of that token attributed to the
    // particular vault ID.
    mapping (address => mapping (address => Asset)) public balances;

    // Map from token address to total amount of that token attributed to some account.
    mapping (address => uint256) public totalBalances;

    // ============ Constructor ============

    constructor(
        address proxyAddr,
        address storageAddr
    )
        StaticAccessControlled()
    {
        TOKEN_PROXY = proxyAddr;
        STORAGE = storageAddr;
    }

    function setNewProxy(
        address newProxy
    )
        external
        onlyOwner
    {
        TOKEN_PROXY = newProxy;
    }

    // ============ Owner-Only State-Changing Functions ============

    /**
     * Allows the owner to withdraw any excess tokens sent to the vault by unconventional means,
     * including (but not limited-to) token airdrops. Any tokens moved to the vault by TOKEN_PROXY
     * will be accounted for and will not be withdrawable by this function.
     *
     * @param  token  ERC20 token address
     * @param  to     Address to transfer tokens to
     * @return        Amount of tokens withdrawn
     */
    function withdrawExcessToken(
        address token,
        address to
    )
        external
        onlyOwner
        returns (uint256)
    {
        uint256 actualBalance = TokenInteract.balanceOf(token, address(this));
        uint256 accountedBalance = totalBalances[token];
        uint256 withdrawableBalance = actualBalance.sub(accountedBalance);

        require(
            withdrawableBalance != 0,
            "Vault#withdrawExcessToken: Withdrawable token amount must be non-zero"
        );

        TokenInteract.transfer(token, to, withdrawableBalance);

        emit ExcessTokensWithdrawn(token, to, msg.sender);

        return withdrawableBalance;
    }

    // ============ Authorized-Only State-Changing Functions ============

    /**
     * Transfers tokens from an address (that has approved the proxy) to the vault.
     *
     * @param  token   ERC20 token address
     * @param  from    Address from which the tokens will be taken
     * @param  amount  Number of the token to be sent
     */
    function depositToVault(
        address token,
        address from,
        uint256 amount
    )
        external
        requiresAuthorization
    {
        // First send tokens to this contract
        TokenProxy(TOKEN_PROXY).transferTokens(
            token,
            from,
            address(this),
            amount
        );

        // Then increment balances
        balances[token][from].availableBalance = balances[token][from].availableBalance.add(amount);
        totalBalances[token] = totalBalances[token].add(amount);

        validateBalance(token);
    }

    function frozenBalance(
        address token,
        address from,
        uint256 amount
    )
        external
        requiresAuthorization
        nonReentrant
    {
        // First send tokens to this contract
        require(balances[token][from].availableBalance >= amount, "Vault#frozenBalance: InsufficientBalance");

        // Then increment balances
        balances[token][from].availableBalance = balances[token][from].availableBalance.sub(amount);
        balances[token][from].frozenBalace = balances[token][from].frozenBalace.add(amount);

        validateBalance(token);
    }

    function thawBalance(
        address token,
        address from,
        uint256 amount
    )
        external
        requiresAuthorization
        nonReentrant
    {
        // First send tokens to this contract
        require(balances[token][from].frozenBalace >= amount, "Vault#thawBalance: InsufficientBalance");

        // Then increment balances
        balances[token][from].frozenBalace = balances[token][from].frozenBalace.sub(amount);
        balances[token][from].availableBalance = balances[token][from].availableBalance.add(amount);

        validateBalance(token);
        emit ThawBalance(token, from, amount);
    }

    /**
     * Transfers a certain amount of funds to an address.
     *
     * @param  token   ERC20 token address
     * @param  to      Address to transfer tokens to
     * @param  amount  Number of the token to be sent
     */
    function withdrawFromVault(
        address token,
        address to,
        uint256 amount
    )
        external
        nonReentrant
        returns (bool successed)
    {
        require(balances[token][to].availableBalance >= amount, "Vault#withdrawFromVault: InsufficientBalance");
        // Next line also asserts that (balances[id][token] >= amount);
        balances[token][to].availableBalance = balances[token][to].availableBalance.sub(amount);

        // Next line also asserts that (totalBalances[token] >= amount);
        totalBalances[token] = totalBalances[token].sub(amount);
        // Do the sending
        TokenInteract.transfer(token, to, amount); // asserts transfer succeeded

        // Final validation
        validateBalance(token);
        return true;
    }

    function settlement(
        address   quoteToken,
        address   baseToken,
        uint256   largestIndex,
        bytes32   hashData,
        settleValues[] calldata settleInfo
    )
        external
        onlySettleAddr
        nonReentrant
    {
        require(ChemixStorage(STORAGE).checkHashData(largestIndex,hashData), 'Chemix: PAIR_NOTEXISTS');
        for(uint i = 0; i < settleInfo.length; i++){
            if(settleInfo[i].positiveOrNegative1){
                balances[quoteToken][settleInfo[i].user].availableBalance = balances[quoteToken][settleInfo[i].user].availableBalance.add(settleInfo[i].incomeQuoteToken);
            }else{
                balances[quoteToken][settleInfo[i].user].availableBalance = balances[quoteToken][settleInfo[i].user].availableBalance.sub(settleInfo[i].incomeQuoteToken);
            }
            if(settleInfo[i].positiveOrNegative2){
                balances[baseToken][settleInfo[i].user].availableBalance = balances[baseToken][settleInfo[i].user].availableBalance.add(settleInfo[i].incomeBaseToken);
            }else{
                balances[baseToken][settleInfo[i].user].availableBalance = balances[baseToken][settleInfo[i].user].availableBalance.sub(settleInfo[i].incomeBaseToken);
            }
        }
        emit Settlement(quoteToken, baseToken, hashData);
    }

    // ============ Private Helper-Functions ============

    /**
     * Verifies that this contract is in control of at least as many tokens as accounted for
     *
     * @param  token  Address of ERC20 token
     */
    function validateBalance(
        address token
    )
        private
        view
    {
        // The actual balance could be greater than totalBalances[token] because anyone
        // can send tokens to the contract's address which cannot be accounted for
        assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
    }

    function balanceOf(
        address token,
        address user
    )
        external
        view
        returns (uint256, uint256)
    {
        // The actual balance could be greater than totalBalances[token] because anyone
        // can send tokens to the contract's address which cannot be accounted for
        //assert(TokenInteract.balanceOf(token, address(this)) >= totalBalances[token]);
        return (balances[token][user].availableBalance,
                balances[token][user].frozenBalace);
    }
}