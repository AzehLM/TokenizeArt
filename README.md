# TokenizeArt
Build my own NFT - another Web3 related exercise


Documentation

An ERC721 compliant contract must implement ERC165 interfaces (need to read more on that)

## NOTES:

### Avantages de stocker les metadata On-Chain:
- **Immutability**: Une fois que c'est stocké sur une blockain, les données peuvent pas etre modifiés ou supprimés. C'est un enregistrement pernanant et inviolable des détails de l'asset.
- **Transparency**: Les donnés on-chain sont accessible publiquement, n'importe qui peut voir et vérifier les données d'un NFT.
- **Verifiable Authenticity**: L'origine et l'historique des NFTs peut etre facilement tracké, réduisant le risque de contrefacons
- **Traceability**: Ces metadonnées incluent des details critiques tel que la date de création, l'historique de possession, l'historique des transactions...
- **Decentralized storage**: Les metadonnées on-chain sont distribué a travers le reseau blockchain, permettant de résister a la censure et aux pertes de données.
- **Smart Contract Integration**: Puisque les metadata sont on-chain, on peut intéragir entre différents smart contract avec, permattant l'automatisation d'actions baser sur la distribution des assets (evolution des NFTs, mechaniques in-game si c'est dans un jeu, etc.)



CID IMG mandatory: bafybeieibtmy3tq56zwkuajbgemseigqc72kj4cjuv3rrpx5jo2toowj6q
CID metadata mandatory: bafkreigqppjjr2oi75t4dj2cun3fk3rimr4h756ylo5bmksvdgckhst3a4


# TokenizeArt

Build my own NFT - a Web3 related exercise

# 42SocietyArt - F42A

**42SocietyArt** is an ERC-721 NFT collection built in Solidity using OpenZeppelin v5. It is the direct continuation of the Tokenizer project (42Society / FS42 ERC-20 token): minting the mandatory NFT requires holding FS42 tokens, linking both projects together.

The collection consists of two separate contracts:
- **Mandatory contract**: NFT image and metadata stored on IPFS via Pinata, mint gated by FS42 token ownership
- **Bonus contract**: NFT image (SVG) and metadata stored entirely on-chain as a `data:` URI, open mint

The project is a Web3 exercise done for 42 post-cc project TokenizeArt.

## Choices

### Blockchain platform - Ethereum / Sepolia testnet

Same platform as Tokenizer, for consistency between the two projects:
- **Sepolia** is a stable, well-maintained Ethereum testnet
- **ERC-721** is the most documented and widely understood NFT standard
- **Etherscan (Sepolia)** provides NFT display, contract verification and read/write interaction
- Reusing the same network allows the mandatory contract to read FS42 balances directly on-chain

### Language - Solidity

Solidity is the native smart contract language of Ethereum. It compiles to bytecode that runs on the Ethereum Virtual Machine (EVM).

### IDE - Remix IDE

Remix is a browser-based Solidity IDE that requires no local installation:
- No setup: directly works from browsers
- Built-in Solidity compiler with version management
- Native **MetaMask** integration for testnet deployment
- Remix Flattener plugin for Etherscan single-file verification

### Token standard - ERC-721

ERC-721 is the standard interface for non-fungible tokens on Ethereum. Unlike Tokenizer where the ERC-20 was implemented from scratch, this project uses **OpenZeppelin v5** contracts:
- The mandatory contract uses `ERC721URIStorage` to store per-token IPFS URIs
- The bonus contract inherits `ERC721` directly and overrides `tokenURI()` to generate metadata on the fly
- Using an audited library is the industry standard for NFT contracts and allows focusing on the project-specific logic (FS42 gating, on-chain SVG) rather than re-implementing token mechanics

### Collection name - 42SocietyArt / F42A

The name must contain "42" (project requirement). 42SocietyArt continues the 42Society universe established in Tokenizer, referencing the Fun Society group from Mr. Robot. The NFT image for the mandatory contract depicts a cyberpunk Hong Kong skyline under a tri-solar sunset, drawing from Three-Body Problem, Mr. Robot, and Hong Kong sunsets.

### Architecture - Two separate contracts

The mandatory and bonus parts are implemented as two independent contracts rather than a single contract with dual storage. This decision was made because:
- It cleanly separates the IPFS approach (mandatory requirement) from the on-chain approach (bonus)
- Each contract is self-contained, independently deployable and verifiable
- The mandatory contract can be evaluated on its own without the bonus adding complexity
- With OpenZeppelin, each contract is lightweight enough that duplication is negligible

### Image storage

- **Mandatory**: image and metadata JSON pinned on IPFS via Pinata. `tokenURI()` returns `ipfs://` CIDs resolved by wallets and explorers through their own IPFS gateways
- **Bonus**: SVG image encoded as a base64 `data:` URI embedded directly in the JSON metadata, which is itself returned as a `data:` URI. No external dependency whatsoever - the image lives in the contract bytecode

### Mint website

A minimal static website allows minting from both contracts with a graphical interface. Built with vanilla HTML/CSS/JS and ethers.js, it reuses the monospace glassmorphism aesthetic from the webserv project.

### Documentation - Resources

Full technical documentation is available in the `documentation/` folder.

Here is a list of documentation/articles I based my implementation on:
- [OpenZeppelin ERC-721 contracts](https://docs.openzeppelin.com/contracts/5.x/erc721)
- [ERC-721 Token Standard](https://ethereum.org/developers/docs/standards/tokens/erc-721/)
- [EIP-721 specification](https://eips.ethereum.org/EIPS/eip-721)
- [OpenZeppelin ERC721URIStorage](https://docs.openzeppelin.com/contracts/5.x/api/token/erc721#ERC721URIStorage)
- [IPFS documentation](https://docs.ipfs.tech/)
- [Pinata IPFS pinning](https://docs.pinata.cloud/)
- [Sepolia resources](https://ethereum.org/developers/docs/networks/#sepolia)
- [Write and deploy NFT](https://ethereum.org/developers/tutorials/how-to-write-and-deploy-an-nft/)
- [ERC721 standard french short explaination](https://ethereum.org/fr/developers/docs/standards/tokens/erc-721/)
- [ERC721 Final Standard](https://eips.ethereum.org/EIPS/eip-721)
