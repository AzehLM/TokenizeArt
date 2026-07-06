// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import {ERC721, Ownable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @notice using this interface to communicate with the FS42 token. The sole purpose of the communication is to check if a minter has a balance of the targeted token address
 * @dev Returns the token balance held by `account`. The address is meant to be the one of a token smart contract
 */
interface IERC20Balance {
    function balanceOf(address account) external view returns (uint256);
}

contract FortyTwoSocietyArt {

}
