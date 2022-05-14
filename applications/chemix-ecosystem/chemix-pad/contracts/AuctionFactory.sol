//SPDX-License-Identifier: MIT
pragma solidity >=0.6.12;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IAuctionImplement {
    function initialize(bytes calldata) external payable;
}

contract AuctionFactory is AccessControl {
    using Clones for address;

    bytes32 public constant DEPLOYER_ROLE = keccak256("DEPLOYER");

    constructor(address admin) public {
        _setupRole(DEFAULT_ADMIN_ROLE, admin);
        _setRoleAdmin(DEPLOYER_ROLE, DEFAULT_ADMIN_ROLE);
    }

    mapping(uint256 => address) public auctionImplements;

    event Deployed(
        address indexed sender,
        uint256 auctionType,
        address indexed implementAddress,
        address indexed newAuctionAddress
    );
    event UpdateAuctionImplement(
        address indexed sender,
        uint256 auctionType,
        address prevImplementAddress,
        address newImplementAddress
    );



    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "Restricted to admins");
        _;
    }

    modifier onlyDeployer() {
        require(isDeployer(msg.sender), "Restricted to minters");
        _;
    }

    function isAdmin(address account) public view returns(bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, account);
    }

    function isDeployer(address account) public view returns(bool) {
        return hasRole(DEPLOYER_ROLE, account);
    }

    function setAuctionImplement(
        uint256 auctionType,
        address newAuctionImplement
    ) external onlyAdmin {
        address prevImplementAddress = auctionImplements[auctionType];
        auctionImplements[auctionType] = newAuctionImplement;
        emit UpdateAuctionImplement(
            msg.sender,
            auctionType,
            prevImplementAddress,
            newAuctionImplement
        );
    }

    function deploy(uint256 auctionType, bytes memory data) external onlyDeployer {
        address implementAddress = auctionImplements[auctionType];
        require(implementAddress != address(0), "Unknown AuctionType");
        address newAuctionAddress = implementAddress.clone();
        IAuctionImplement(newAuctionAddress).initialize(data);
        emit Deployed(
            msg.sender,
            auctionType,
            implementAddress,
            newAuctionAddress
        );
    }
}
