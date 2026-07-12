# 42SocietyArt (F42A) - Usage & Features

## 1. Collection Summary

| Property                 | Value                                                 |
| ------------------------ | ----------------------------------------------------- |
| **Name**                 | 42SocietyArt / 42SocietyArtOnChain                    |
| **Ticker**               | F42A / F42AOC                                         |
| **Standard**             | ERC-721                                               |
| **Max supply**           | 9001 / 10 tokens per contract                         |
| **Network**              | Ethereum Sepolia Testnet                              |
| **IPFS contract**        | `0xA6e1E1fD9da9c33249Db466410E69023B48A0F81`          |
| **On-chain contract**    | `0x552b1726694e330f3f249DF598018DbDf5F1CB80`          |
| **FS42 token**           | `0xc033d60d6c2f4cd561c4f77019cf2790f4e825ab`          |
| **Etherscan (IPFS)**     | https://sepolia.etherscan.io/address/0xA6e1E1fD9da9c33249Db466410E69023B48A0F81 |
| **Etherscan (On-Chain)** | https://sepolia.etherscan.io/token/0x552b1726694e330f3f249DF598018DbDf5F1CB80 |

> [!NOTE]
> For the reasoning behind platform, language and architectural choices, see the main `README.md` at the root of the repository.

## 2. Prerequisites

To interact with the 42SocietyArt NFTs you need:

**A Web3 wallet**: MetaMask is recommended.

**Sepolia testnet selected in MetaMask**: Sepolia is available by default under Settings > Networks.

**Sepolia ETH for gas fees**: Obtain free test ETH from a faucet ([Google Cloud Web3 faucet](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)). A small amount is enough to cover transaction gas.

**FS42 tokens (mandatory contract only)**: The IPFS contract requires the minter to hold at least 1 FS42 token. FS42 is the ERC-20 token from the Tokenizer project, deployed at the address listed above.

## 3. Architecture

The project consists of two independent ERC-721 contracts.

**Contract 1 - IPFS (mandatory)**: Built with `ERC721URIStorage` and `Ownable` from OpenZeppelin v5. The NFT image is a cyberpunk Hong Kong skyline with "42" visible, stored on IPFS via Pinata. The metadata JSON is also on IPFS. Minting requires FS42 token ownership, verified via a read-only `balanceOf` call to the FS42 contract using a minimal `IERC20Balance` interface. The FS42 address is set as `immutable` at deployment and cannot be changed afterward.

**Contract 2 - On-chain SVG (bonus)**: Built with `ERC721` and `Ownable` from OpenZeppelin v5. The NFT image is an SVG stored directly in the contract bytecode as a `string constant`. The `tokenURI()` function is overridden to build the metadata JSON on the fly, embedding the SVG as a base64-encoded `data:` URI. No external storage dependency. Minting is open to anyone, no FS42 requirement.

## 4. NFT Operations

### 4.1 Minting

**IPFS contract - `mint()`**: Callable by any address that holds at least 1 FS42 token. The function checks the caller's FS42 balance, verifies the max supply has not been reached, mints a new token to the caller with `_safeMint`, and sets the token URI to the IPFS metadata CID.

**On-chain contract - `mint()`**: Callable by anyone. The function verifies the max supply has not been reached and mints a new token to the caller with `_safeMint`. No token gating.

Both functions revert with a descriptive message if the supply cap is reached or (for the IPFS contract) if the caller has no FS42 tokens.

### 4.2 Standard ERC-721 (any user)

Operations available to any holder of 42SocietyArt NFTs. These are inherited from OpenZeppelin and follow the ERC-721 specification.

**`ownerOf(tokenId)`**: Returns the owner address of a given token. Reverts if the token does not exist.

**`balanceOf(owner)`**: Returns the number of NFTs held by an address.

**`transferFrom(from, to, tokenId)`**: Transfer a token from one address to another. The caller must be the owner or an approved operator.

**`approve(to, tokenId)`**: Approve an address to transfer a specific token on your behalf.

**`setApprovalForAll(operator, approved)`**: Approve or revoke an operator for all your tokens.

**`getApproved(tokenId)`**: Returns the approved address for a specific token.

**`isApprovedForAll(owner, operator)`**: Check if an operator is approved for all tokens of an owner.

**`tokenURI(tokenId)`**: Returns the metadata URI for a token. On the IPFS contract, this is an `ipfs://` CID. On the on-chain contract, this is a `data:application/json;base64,...` URI containing the full metadata and embedded SVG image.

**`totalSupply()`**: Returns the number of tokens minted so far (custom function, not part of ERC-721 base).

## 5. Metadata

### IPFS contract

The metadata JSON is pinned on IPFS and shared across all 42 tokens. It follows the ERC-721 metadata standard:

```json
{
  "name": "42SocietyArt",
  "description": "42SocietyArt NFT Collection on Sepolia Testnet",
  "image": "ipfs://bafybeieibtmy3tq56zwkuajbgemseigqc72kj4cjuv3rrpx5jo2toowj6q",
  "attributes": [
    { "trait_type": "Artist", "value": "gueberso" },
    { "trait_type": "Reference", "value": "Three-Body Problem" },
    { "trait_type": "Reference", "value": "Mr. Robot" },
    { "trait_type": "Setting", "value": "Hong Kong" },
    { "trait_type": "Element", "value": "Rooftop Observer" },
    { "trait_type": "Mood", "value": "Contempling" },
    { "trait_type": "Element", "value": "Skyline" },
    { "trait_type": "Signal", "value": "42" }
  ]
}
```

The image is a cyberpunk Hong Kong skyline under a tri-solar sunset, with "42" clearly visible as a glowing sign on a building. The artist name matches the 42 login as required by the subject.

### On-chain contract

The metadata is generated inside `tokenURI()`. The SVG image is stored as a constant string in the contract bytecode and encoded in base64 at read time. The JSON wraps it as a `data:image/svg+xml;base64,...` URI inside the `image` field. Each token gets a unique name (`42SocietyArtOnChain #0`, `#1`, etc.) while sharing the same SVG.

## 6. Security Considerations

**FS42 gating via immutable address**: The IPFS contract stores the FS42 token address as `immutable`, meaning it is set once at deployment and can never be changed - not even by the contract owner. This prevents a scenario where the owner could redirect the balance check to a different token contract.

**`_safeMint` over `_mint`**: Both contracts use `_safeMint`, which verifies that the recipient address can receive ERC-721 tokens (if it is a contract, it must implement `onERC721Received`). This prevents tokens from being permanently locked in contracts that do not support them.

**Ownable**: Both contracts inherit OpenZeppelin's `Ownable`, giving the deployer address exclusive access to owner-restricted functions. Currently no owner-only functions are used beyond what OpenZeppelin provides by default, but the pattern is in place for extensibility.

**Max supply enforcement**: The 42-token cap is enforced via a `require` check in `mint()` against a `constant` value. Constants cannot be modified post-deployment.

**No API keys or secrets**: The contracts contain no credentials. IPFS content is addressed by hash (CID), not by authenticated URL. The mint website uses MetaMask for transaction signing - no private keys are handled by the frontend.

## 7. Mint Website

A static website is available for minting from both contracts through a graphical interface. It is built with vanilla HTML, CSS and JavaScript using the ethers.js library for blockchain interaction.

The website features two mint cards (one per contract). The IPFS contract card checks the user's FS42 balance before allowing the mint. The on-chain contract card allows minting directly. Both cards display the connected wallet address and provide transaction feedback.
