// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @notice using this interface to communicate with the FS42 token. The sole purpose of the communication is to check if a minter has a balance of the targeted token address
 * @dev Returns the token balance held by `account`. The address is meant to be the one of a token smart contract
 */
interface IERC20Balance {
	function balanceOf(address account) external view returns (uint256);
}

/**
 * @title 42SocietyArt - solution for the mandatory IPFS Contract
 * @notice ERC-721 NFT gated by FS42 token ownership. Metadata stored on IPFS.
 */
contract FortyTwoSocietyArt is ERC721URIStorage, Ownable, ERC721 {

	uint256 public constant MAX_SUPPLY = 9001;
	uint256 private _tokenIdCounter;

	IERC20Balance public immutable fs42Token;

	string private constant METADATA_URI = "ipfs://bafkreigqppjjr2oi75t4dj2cun3fk3rimr4h756ylo5bmksvdgckhst3a4";

	constructor(address _fs42Address) ERC721("42SocietyArt", "F42A") Ownable(msg.sender)
	{
		fs42Token = IERC20Balance(_fs42Address);
	}

	/**
	 * @notice Mints one NFT to the caller, gated by FS42 token ownership.
	 * @dev Reverts if the caller holds no FS42 tokens, checked via a read-only balanceOf call
	 * to the FS42 contract using the minimal IERC20Balance interface.
	 * Uses _safeMint instead of _mint: if the recipient is a smart contract, it must implement
	 * onERC721Received, otherwise the transaction reverts.
	 * All tokens share the same IPFS metadata URI (METADATA_URI constant), set via _setTokenURI.
	 * Emits a Transfer event from address(0) to the caller via _mint().
	 */
	function mint() external {

		require(fs42Token.balanceOf(msg.sender) > 0, "Must hold FS42 tokens");
		require(_tokenIdCounter < MAX_SUPPLY, "Max supply reached");

		uint256 tokenId = _tokenIdCounter;
		_tokenIdCounter++;

		_safeMint(msg.sender, tokenId);
		_setTokenURI(tokenId, METADATA_URI);
	}

	/**
	 * @notice Returns the total number of tokens minted so far.
	 * @dev Not part of the ERC-721 standard. Exposes _tokenIdCounter which is incremented
	 * on each mint and never decremented. Since token IDs start at 0 and are sequential,
	 * totalSupply() also equals the next token ID to be minted.
	 * @return The number of tokens that have been minted.
	 */
	function totalSupply() external view returns (uint256) {
		return _tokenIdCounter;
	}
}
