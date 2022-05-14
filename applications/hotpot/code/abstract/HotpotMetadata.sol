// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;
import "../interfaces/IHotpotMetadata.sol";

contract HotpotMetadata is IHotpotMetadata{

    string private _meta; 

    /**
     * @dev Sets the values for {daoUrl}.
     */

    function _setMetadata(string memory url) internal {
        _meta = url;
    }

    /**
     * @dev Returns the logo of the dao project.
     */
    function getMetadata() public view virtual returns (string memory){
        return _meta;
    }

    
}