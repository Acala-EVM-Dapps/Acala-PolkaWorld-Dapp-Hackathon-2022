// Inspired by https://github.com/deepyr/DutchSwap
// Inspired by https://github.com/sushiswap/miso
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// ---------------------------------------------------------------------
// SPDX-License-Identifier: GPL-3.0-or-later
// ---------------------------------------------------------------------

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "@openzeppelin/contracts/math/Math.sol";

import "./interfaces/IERC20Extended.sol";

contract BasicBatchAuction is ReentrancyGuard, Initializable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address private constant ETH = address(0);
    uint256 private constant PENALTY = 50000000000000000; //5%
    address payable private constant PENALTY_RECIPIENT = 0x20212521370Dd2ddE0b0e3aC25b65EB3E859d303;
    uint256 private constant FEE = 1000000000000000; //0.1%
    address payable private constant FEE_RECIPIENT = 0x20212521370Dd2ddE0b0e3aC25b65EB3E859d303;

    uint256 public startTime;
    uint256 public endTime;
    address public auctionToken;
    address public paymentToken;
    uint256 public totalAmount;
    uint256 public targetCommitments;
    address public collateralToken;
    uint256 public collateralAmount;
    uint256 public depositExpired;
    address payable public seller;

    bool public isCollateralsDeposited;
    bool public isCollateralsWithdrawn;
    bool public isTokensDeposited;
    bool public isTokensWithdrawn;

	uint256 public totalCommitments;
    mapping(address => uint256) public commitments;
    mapping(address => uint256) public claimed;

    uint256 private _unit;

    event WithdrawTokens(address indexed sender, address indexed token, uint256 amount, uint256 time);
    event DepositTokens(address indexed sender, address indexed token, uint256 amount, uint256 time);
    event DepositCollaterals(address indexed sender, address indexed token, uint256 amount, uint256 time);
    event WithdrawCollaterals(address indexed sender, address indexed token, uint256 amount, uint256 time);
    event WithdrawPayments(address indexed sender, address indexed token, uint256 amount, uint256 time);
    event AddedCommitment(address addr, uint256 commitment, uint256 time);

    function initAuction(
        uint256 _startTime,
        uint256 _endTime,
        address _auctionToken,
        address _paymentToken,
        uint256 _totalAmount,
        uint256 _targetCommitments,
        address _collateralToken,
        uint256 _collateralAmount,
        uint256 _depositExpired,
        address payable _seller
    ) internal initializer {
        require(_startTime >= block.timestamp, "Start time is before current time");
        require(_endTime > _startTime, "End time must be older than start price");
        require(_totalAmount > 0, "Total tokens must be greater than zero");
        require(_collateralToken != ETH, "Collateralled token is not ERC20");
        require(PENALTY <= 1e18, "Invalid penalty rate");
        require(FEE <= 1e18, "Invalid fee rate");

        startTime = _startTime;
        endTime = _endTime;
        auctionToken = _auctionToken;
        paymentToken = _paymentToken;
        totalAmount = _totalAmount;
        targetCommitments = _targetCommitments;
        collateralToken = _collateralToken;
        collateralAmount = _collateralAmount;
        depositExpired = _depositExpired;
        seller = _seller;

        _unit = 10**IERC20Extended(_auctionToken).decimals();
    }

    modifier onlySeller() {
        require(msg.sender == seller, "!onlySeller");
        _;
    }


    //=============================================================================

    function clearingPrice() public view returns (uint256) {
        return totalCommitments.mul(_unit).div(totalAmount);
    }

    //=============================================================================

    function commitEther() external payable nonReentrant {
        require(isActive() && paymentToken == ETH, "!isActive OR paymentToken is not Ether");
        require(msg.value > 0, "Invalid commitments");
        uint256 fee = msg.value.mul(FEE).div(1e18);
        addCommitment(msg.sender, msg.value.sub(fee));
        _transfer(ETH, FEE_RECIPIENT, fee);
    }

    function commitTokens(uint256 _amount) external {
        require(isActive() && paymentToken != ETH, "!isActive OR paymentToken is Ether");
        require(_amount > 0, "Invalid commitments");
        uint256 fee = _amount.mul(FEE).div(1e18);
        addCommitment(msg.sender, _amount.sub(fee));
        IERC20(paymentToken).safeTransferFrom(msg.sender, address(this), _amount);
        _transfer(paymentToken, FEE_RECIPIENT, fee);
    }

    function addCommitment(address account, uint256 amount) internal {
        commitments[account] = commitments[account].add(amount);
        totalCommitments = totalCommitments.add(amount);
        emit AddedCommitment(account, amount, block.timestamp);
    }

    //=============================================================================

    function tokensClaimable(address account) public view returns (uint256 claimerCommitment)
    {
        if (commitments[account] == 0) return 0;
        uint256 unclaimedTokens = IERC20(auctionToken).balanceOf(address(this));
        claimerCommitment = commitments[account].mul(totalAmount).div(totalCommitments);
        claimerCommitment = claimerCommitment.sub(claimed[account]);
        if (claimerCommitment > unclaimedTokens) {
            claimerCommitment = unclaimedTokens;
        }
    }

    function isActive() public view returns (bool) {
        return block.timestamp >= startTime && block.timestamp <= endTime && isCollateralsDeposited;
    }

    function successful() public view returns (bool) {
        return totalCommitments >= targetCommitments && block.timestamp > endTime;
    }

    //=============================================================================

    function depositTokens() external onlySeller {
        require(successful(), "!successful");
        require(!isTokensDeposited, "isTokensDeposited");
        require(block.timestamp <= depositExpired, "!depositExpired");
        isTokensDeposited = true;
        IERC20(auctionToken).safeTransferFrom(msg.sender, address(this), totalAmount);
        emit DepositTokens(msg.sender, auctionToken, totalAmount, block.timestamp);
    }

    function withdrawPayments() external nonReentrant onlySeller {
        require(successful(), "!successful");
        require(isTokensDeposited, "!isTokensDeposited");
        require(!isTokensWithdrawn, "isTokensWithdrawn");
        isTokensWithdrawn = true;
        _transfer(paymentToken, msg.sender, totalCommitments);
        emit WithdrawPayments(msg.sender, paymentToken, totalCommitments, block.timestamp);
    }

    function withdrawTokens() external nonReentrant {
        if (isTokensDeposited) {
            uint256 tokensToClaim = tokensClaimable(msg.sender);
            require(tokensToClaim > 0, "No tokens to claim");
            claimed[msg.sender] = claimed[msg.sender].add(tokensToClaim);
            _transfer(auctionToken, msg.sender, tokensToClaim);
            emit WithdrawTokens(msg.sender, auctionToken, tokensToClaim, block.timestamp);
        } else {
            require(block.timestamp > depositExpired, "!depositExpired");
            uint256 fundsCommitted = commitments[msg.sender];
            commitments[msg.sender] = 0;
            _transfer(paymentToken, msg.sender, fundsCommitted);
            emit WithdrawTokens(msg.sender, paymentToken, fundsCommitted, block.timestamp);
        }
    }

    function depositCollaterals() external onlySeller {
        require(block.timestamp < startTime, "Overdue");
        require(!isCollateralsDeposited, "isCollateralsDeposited");
        isCollateralsDeposited = true;
        IERC20(collateralToken).safeTransferFrom(msg.sender, address(this), collateralAmount);
        emit DepositCollaterals(msg.sender, collateralToken, collateralAmount, block.timestamp);
    }

    function withdrawCollaterals() external onlySeller {
        require(isCollateralsDeposited, "!isCollateralsDeposited");
        require(!isCollateralsWithdrawn, "isCollateralsWithdrawn");
        isCollateralsWithdrawn = true;
        uint256 collateralsToWithdraw = collateralAmount;
        if(successful()) {
            if (!isTokensDeposited) {
                require(block.timestamp > depositExpired, "!depositExpired");
                uint256 penaltyAmount = collateralAmount.mul(PENALTY).div(1e18);
                collateralsToWithdraw = collateralAmount.sub(penaltyAmount);
                _transfer(collateralToken, PENALTY_RECIPIENT, penaltyAmount);
            }
        } else {
            require(block.timestamp > endTime, "!endTime");
        }
        _transfer(collateralToken, msg.sender, collateralsToWithdraw);
        emit WithdrawCollaterals(msg.sender, collateralToken, collateralsToWithdraw, block.timestamp);
    }

    //=============================================================================

    function _transfer(address token, address payable to, uint256 amount) internal {
        if(token == ETH) {
            (bool success,) = to.call{value: amount}(new bytes(0));
            require(success, 'ETH_TRANSFER_FAILED');
        } else {
           IERC20(token).safeTransfer(to, amount);
        }
    }

    //=============================================================================

    function initialize(bytes calldata _data) external {
        (
            uint256 _startTime,
            uint256 _endTime,
            address _auctionToken,
            address _paymentToken,
            uint256 _totalAmount,
            uint256 _targetCommitments,
            address _collateralToken,
            uint256 _collateralAmount,
            uint256 _depositExpired,
            address payable _seller
        ) = abi.decode(
                _data,
                (
                    uint256,
                    uint256,
                    address,
                    address,
                    uint256,
                    uint256,
                    address,
                    uint256,
                    uint256,
                    address
                )
            );

        initAuction(
            _startTime,
            _endTime,
            _auctionToken,
            _paymentToken,
            _totalAmount,
            _targetCommitments,
            _collateralToken,
            _collateralAmount,
            _depositExpired,
            _seller
        );
    }

    receive() external payable {
        revert("!payable");
    }
}
