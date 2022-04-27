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
import "@openzeppelin/contracts/math/Math.sol";
import "@openzeppelin/contracts/proxy/Initializable.sol";
import "./interfaces/IERC20Extended.sol";

contract BasicDutchAuction is ReentrancyGuard, Initializable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address private constant ETH = address(0);
    uint256 private constant PENALTY = 50000000000000000; //5%
    uint256 private constant FEE1 = 20000000000000000; //2%
    uint256 private constant FEE2 = 30000000000000000; //3%
    address payable private constant PENALTY_RECIPIENT =
        0x20212521370Dd2ddE0b0e3aC25b65EB3E859d303;
    address payable private constant FEE_RECIPIENT =
        0x20212521370Dd2ddE0b0e3aC25b65EB3E859d303;

    uint256 public startTime;
    uint256 public endTime;
    uint256 public totalAmount;
    uint256 public targetAmount;
    uint256 public initialPrice;
    uint256 public reservePrice;
    address public auctionToken;
    address public paymentToken;
    address public collateralToken;
    uint256 public collateralAmount;
    uint256 public minimumAuctionAmount;
    uint256 public maximumAuctionAmount;
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

    event WithdrawTokens(
        address indexed sender,
        address indexed token,
        uint256 amount,
        uint256 time
    );
    event DepositTokens(
        address indexed sender,
        address indexed token,
        uint256 amount,
        uint256 time
    );
    event DepositCollaterals(
        address indexed sender,
        address indexed token,
        uint256 amount,
        uint256 time
    );
    event WithdrawCollaterals(
        address indexed sender,
        address indexed token,
        uint256 amount,
        uint256 time
    );
    event WithdrawPayments(
        address indexed sender,
        address indexed token,
        uint256 amount,
        uint256 time
    );
    event AddedCommitment(address addr, uint256 commitment, uint256 time);

    function _initAuction(
        address _auctionToken,
        address _paymentToken,
        uint256 _totalAmount,
        uint256 _targetAmount,
        uint256 _minimumAuctionAmount,
        uint256 _maximumAuctionAmount,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _initialPrice,
        uint256 _reservePrice,
        address _collateralToken,
        uint256 _collateralAmount,
        uint256 _depositExpired,
        address payable _seller
    ) internal initializer nonReentrant {
        require(_startTime >= block.timestamp, "Start time is before current time");
        require(_endTime > _startTime, "End time must be older than start price");
        require(_totalAmount > 0, "Total tokens must be greater than zero");
        require(_initialPrice > _reservePrice, "Start price must be higher than minimum price");
        require(_reservePrice > 0, "Minimum price must be greater than 0");
        require(_collateralToken != ETH, "Collateralled token is not ERC20");
        require(PENALTY <= 1e18, "Invalid penalty rate");
        require(FEE1 <= 1e18, "Invalid fee rate");
        require(FEE2 <= 1e18, "Invalid fee rate");

        startTime = _startTime;
        endTime = _endTime;
        auctionToken = _auctionToken;
        paymentToken = _paymentToken;
        totalAmount = _totalAmount;
        targetAmount = _targetAmount;
        minimumAuctionAmount = _minimumAuctionAmount;
        maximumAuctionAmount = _maximumAuctionAmount;
        initialPrice = _initialPrice;
        reservePrice = _reservePrice;
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

    function priceDrop() public view returns (uint256) {
        uint256 numerator = initialPrice.sub(reservePrice);
        uint256 denominator = endTime.sub(startTime);
        return numerator.div(denominator);
    }

    function tokenPrice() public view returns (uint256) {
        return totalCommitments.mul(_unit).div(totalAmount);
    }

    function currentPrice() public view returns (uint256) {
        if (block.timestamp <= startTime) return initialPrice;
        if (block.timestamp >= endTime) return reservePrice;
        return
            initialPrice.sub(block.timestamp.sub(startTime).mul(priceDrop()));
    }

    function clearingPrice() public view returns (uint256) {
        return Math.max(tokenPrice(), currentPrice());
    }

    //=============================================================================

    function commitEther() external payable nonReentrant {
        require(isActive(), "!isActive");
        require(paymentToken == ETH, "PaymentToken is not Ether");
        require(
            msg.value >= minimumAuctionAmount.mul(clearingPrice()).div(_unit) ||
                minimumAuctionAmount == 0,
            "!minimumAuctionAmount"
        );
        uint256 ethToTransfer = calculateCommitment(msg.value);
        uint256 ethToRefund = msg.value.sub(ethToTransfer);
        require(ethToTransfer > 0, "Exceed maximum commitments");
        uint256 fee = ethToTransfer.mul(FEE1).div(1e18);
        _addCommitment(msg.sender, ethToTransfer.sub(fee));
        _transfer(ETH, FEE_RECIPIENT, fee);
        if (ethToRefund > 0) {
            _transfer(ETH, msg.sender, ethToRefund);
        }
    }

    function commitTokens(uint256 _amount) external nonReentrant {
        require(isActive(), "!isActive");
        require(paymentToken != ETH, "PaymentToken is Ether");
        require(
            _amount >= minimumAuctionAmount.mul(clearingPrice()).div(_unit) ||
                minimumAuctionAmount == 0,
            "!minimumAuctionAmount"
        );
        uint256 tokensToTransfer = calculateCommitment(_amount);
        require(tokensToTransfer > 0, "Exceed maximum commitments");
        uint256 fee = tokensToTransfer.mul(FEE1).div(1e18);
        _addCommitment(msg.sender, tokensToTransfer.sub(fee));
        IERC20(paymentToken).safeTransferFrom(
            msg.sender,
            address(this),
            tokensToTransfer
        );
        _transfer(paymentToken, FEE_RECIPIENT, fee);
    }

    function _addCommitment(address account, uint256 amount) internal {
        commitments[account] = commitments[account].add(amount);
        require(
            maximumAuctionAmount.mul(clearingPrice()).div(_unit) >=
                commitments[account] ||
                maximumAuctionAmount == 0,
            "!maximumAuctionAmount"
        );
        totalCommitments = totalCommitments.add(amount);
        emit AddedCommitment(account, amount, block.timestamp);
    }

    //=============================================================================

    function calculateCommitment(uint256 commitment)
        public
        view
        returns (uint256 committed)
    {
        uint256 maxCommitment = totalAmount.mul(clearingPrice()).div(_unit);
        if (totalCommitments.add(commitment) > maxCommitment)
            return maxCommitment.sub(totalCommitments);
        return commitment;
    }

    function tokensClaimable(address account)
        public
        view
        returns (uint256 claimerCommitment)
    {
        if (commitments[account] == 0) return 0;
        uint256 unclaimedTokens = IERC20(auctionToken).balanceOf(address(this));
        claimerCommitment = commitments[account].mul(totalTokensCommitted()).div(
            totalCommitments
        );
        claimerCommitment = claimerCommitment.sub(claimed[account]);
        if (claimerCommitment > unclaimedTokens) {
            claimerCommitment = unclaimedTokens;
        }
    }

    function totalTokensCommitted() public view returns (uint256) {
        //Handling oversold
        return Math.min(totalCommitments.mul(_unit).div(clearingPrice()), totalAmount);
    }

    function isActive() public view returns (bool) {
        return
            block.timestamp >= startTime &&
            block.timestamp <= endTime &&
            isCollateralsDeposited;
    }

    function successful() public view returns (bool) {
        return
            tokenPrice() >= clearingPrice() ||
            (block.timestamp > endTime &&
                totalCommitments >= targetAmount.mul(clearingPrice()).div(_unit));
    }

    //=============================================================================

    function depositTokens() external onlySeller {
        require(successful(), "!successful");
        require(!isTokensDeposited, "isTokensDeposited");
        require(block.timestamp <= depositExpired, "!depositExpired");
        isTokensDeposited = true;
        uint256 tokensToDeposit = totalTokensCommitted();
        IERC20(auctionToken).safeTransferFrom(
            msg.sender,
            address(this),
            tokensToDeposit
        );
        emit DepositTokens(
            msg.sender,
            auctionToken,
            tokensToDeposit,
            block.timestamp
        );
    }

    function withdrawPayments() external nonReentrant onlySeller {
        require(successful(), "!successful");
        require(isTokensDeposited, "!isTokensDeposited");
        require(!isTokensWithdrawn, "isTokensWithdrawn");
        isTokensWithdrawn = true;
        uint256 fee = totalCommitments.mul(FEE2).div(1e18);
	    _transfer(paymentToken, FEE_RECIPIENT, fee);
        _transfer(paymentToken, msg.sender, totalCommitments.sub(fee));
        emit WithdrawPayments(
            msg.sender,
            paymentToken,
            totalCommitments,
            block.timestamp
        );
    }

    function withdrawTokens() external nonReentrant {
        if (isTokensDeposited) {
            uint256 tokensToClaim = tokensClaimable(msg.sender);
            require(tokensToClaim > 0, "No tokens to claim");
            claimed[msg.sender] = claimed[msg.sender].add(tokensToClaim);
            _transfer(auctionToken, msg.sender, tokensToClaim);
            emit WithdrawTokens(
                msg.sender,
                auctionToken,
                tokensToClaim,
                block.timestamp
            );
        } else {
            require(block.timestamp > depositExpired || !successful(), "!depositExpired");
            uint256 fundsCommitted = commitments[msg.sender];
            commitments[msg.sender] = 0;
            _transfer(paymentToken, msg.sender, fundsCommitted);
            emit WithdrawTokens(
                msg.sender,
                paymentToken,
                fundsCommitted,
                block.timestamp
            );
        }
    }

    function depositCollaterals() external onlySeller {
        require(block.timestamp < startTime, "Overdue");
        require(!isCollateralsDeposited, "isCollateralsDeposited");
        isCollateralsDeposited = true;
        IERC20(collateralToken).safeTransferFrom(
            msg.sender,
            address(this),
            collateralAmount
        );
        emit DepositCollaterals(
            msg.sender,
            collateralToken,
            collateralAmount,
            block.timestamp
        );
    }

    function withdrawCollaterals() external onlySeller {
        require(isCollateralsDeposited, "!isCollateralsDeposited");
        require(!isCollateralsWithdrawn, "isCollateralsWithdrawn");
        isCollateralsWithdrawn = true;
        uint256 collateralsToWithdraw = collateralAmount;
        if (successful()) {
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
        emit WithdrawCollaterals(
            msg.sender,
            collateralToken,
            collateralsToWithdraw,
            block.timestamp
        );
    }

    //=============================================================================

    function _transfer(
        address token,
        address payable to,
        uint256 amount
    ) internal {
        if (token == ETH) {
            (bool success, ) = to.call{value: amount}(new bytes(0));
            require(success, "ETH_TRANSFER_FAILED");
        } else {
            IERC20(token).safeTransfer(to, amount);
        }
    }

    //=============================================================================

    function initialize(bytes calldata _data) external {
        (
            address _auctionToken,
            address _paymentToken,
            uint256 _totalAmount,
            uint256 _targetAmount,
            uint256 _minimumAuctionAmount,
            uint256 _maximumAuctionAmount,
            uint256 _startTime,
            uint256 _endTime,
            uint256 _initialPrice,
            uint256 _reservePrice,
            address _collateralToken,
            uint256 _collateralAmount,
            uint256 _depositExpired,
            address payable _seller
        ) = abi.decode(
                _data,
                (
                    address,
                    address,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    uint256,
                    address,
                    uint256,
                    uint256,
                    address
                )
            );

        _initAuction(
            _auctionToken,
            _paymentToken,
            _totalAmount,
            _targetAmount,
            _minimumAuctionAmount,
            _maximumAuctionAmount,
            _startTime,
            _endTime,
            _initialPrice,
            _reservePrice,
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
