// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Interface of the hotpot project metadata
 */
interface IHotpotMetadata {

    /**
     * @dev Returns the logo of the dao project.
     */
    function getMetadata() external view returns (string memory);

}
