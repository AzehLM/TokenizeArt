# Deployment

This covers how to deploy the 42SocietyArt (F42A) and 42SocietyArtOnChain NFT contracts on the Ethereum Sepolia testnet using Remix IDE and MetaMask.

## Deployed Contracts

| Property                | Value                                                         |
| ----------------------- | ------------------------------------------------------------- |
| **Network**             | Ethereum Sepolia Testnet (Chain ID: 11155111)                 |
| **IPFS contract**       | `0xA6e1E1fD9da9c33249Db466410E69023B48A0F81`                  |
| **On-chain contract**   | `0x552b1726694e330f3f249DF598018DbDf5F1CB80`                  |
| **FS42 token**          | `0xc033d60d6c2f4cd561c4f77019cf2790f4e825ab`                  |
| **Tickers**             | F42A / F42AOC                                                 |
| **Etherscan (IPFS)**    | https://sepolia.etherscan.io/address/0xA6e1E1fD9da9c33249Db466410E69023B48A0F81 |
| **Etherscan (OnChain)** | https://sepolia.etherscan.io/address/0x552b1726694e330f3f249DF598018DbDf5F1CB80 |

---

## Prerequisites

**MetaMask**: Install the browser extension from [metamask.io](https://metamask.io). Switch to the Sepolia testnet.

**Sepolia ETH**: You need a small amount of test ETH to pay for deployment gas: [free Google Cloud Web3 faucet](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)

**FS42 contract address**: The IPFS contract requires the FS42 token address as a constructor parameter. The FS42 token from Tokenizer must already be deployed on Sepolia.

## IPFS Setup (mandatory contract only)

Before deploying the IPFS contract, the NFT image and metadata must be pinned on IPFS:

1. Create an account on [Pinata](https://www.pinata.cloud/) (free plan, 1 GB storage)
2. Upload the NFT image via the Pinata dashboard
3. Copy the image CID
4. Create a `metadata.json` file with the image CID in the `image` field (see `documentation/usage.md` for the full JSON structure)
5. Upload `metadata.json` to Pinata
6. Copy the metadata CID - this is the URI that goes into the contract's `METADATA_URI` constant

To verify: open `https://your-gateway.mypinata.cloud/ipfs/<METADATA_CID>` in a browser. The JSON should display with the image CID resolvable.

## Step-by-step Deployment

### 1. Open Remix IDE

Go to https://remix.ethereum.org. No installation required.

### 2. Import the contracts

Create new files in the Remix file explorer and paste the contract source code from the `code/` folder:
- `42SocietyArt.sol` (IPFS / mandatory)
- `42SocietyArtOnChain.sol` (on-chain SVG / bonus)

### 3. Compile

In the "Solidity Compiler" tab:
- Select compiler version `0.8.34` (or any version after with `^0.8.20`)
- Leave EVM version on "compiler default"
- Click "Compile" - ensure no errors

### 4. Connect MetaMask

In the "Deploy & Run Transactions" tab:
- Environment: select **Injected Provider - MetaMask**
- MetaMask will prompt you to connect, confirm and make sure Sepolia is selected
- The "Account" dropdown should show your MetaMask address with its Sepolia ETH balance

### 5. Deploy the IPFS contract (mandatory)

Select `FortyTwoSocietyArt` in the contract dropdown. Fill the constructor parameter:

| Parameter        | Format          | Value                                              |
| ---------------- | --------------- | -------------------------------------------------- |
| `_fs42Address`   | Address         | `0xc033d60d6c2f4cd561c4f77019cf2790f4e825ab`       |

Click **Deploy**. MetaMask will open a confirmation popup showing the estimated gas cost, confirm the transaction.

### 6. Deploy the on-chain contract (bonus)

Select `FortyTwoSocietyArtOnChain` in the contract dropdown. No constructor parameters needed.

Click **Deploy** and confirm in MetaMask.

### 7. Note the contract addresses

Once the transactions are confirmed, the deployed contracts appear in Remix under "Deployed Contracts". Copy both addresses for use in the mint website (if updates is required. The mint website is hosted as a pages.dev from cloudflare and accessible from the [following link](https://tokenizeart.ostrom.cloud/)).

## Etherscan Verification

Verifying the source code on Etherscan makes the contract publicly readable and allows anyone to interact with it directly from the explorer.

1. In Remix, right-click on the contract file and select **Flatten**
2. Remix generates a flattened file with all OpenZeppelin imports inlined
3. Go to `https://sepolia.etherscan.io/address/<CONTRACT_ADDRESS>` (IPFS/mandatory contract and/or on-chain contract)
4. Click the **Contract** tab, then **Verify and Publish**
5. Fill in the form:
   - Contract address: auto-filled
   - Compiler type: **Solidity (Single file)**
   - Compiler version: must match exactly the version used in Remix (e.g. `v0.8.34+commit...`)
   - License: MIT
   - Optimization: match your Remix setting (default: No)
6. Paste the full content of the flattened file in the source code field
7. For the IPFS contract, enter the constructor arguments (ABI-encoded FS42 address)
8. Click **Verify and Publish**

Once verified, the "Read Contract" / "Write Contract" tabs allow direct interaction from Etherscan.

## Local Testing (before Sepolia deployment)

Before spending testnet ETH, test the contracts locally in Remix:

1. In "Deploy & Run Transactions", select **Remix VM (Osaka)** as environment
2. Remix provides 10+ accounts with 100 ETH each
3. Deploy the FS42 token first (from the Tokenizer project), mint some tokens to a test account
4. Deploy `FortyTwoSocietyArt` with the FS42 address as constructor argument
5. Call `mint()` from the account holding FS42 tokens - should succeed
6. Call `mint()` from an account without FS42 tokens - should revert with "Must hold FS42 tokens"
7. Verify: `ownerOf(0)` returns the minter address, `totalSupply()` returns 1, `tokenURI(0)` returns the IPFS URI
8. Deploy `FortyTwoSocietyArtOnChain` (no constructor args)
9. Call `mint()` from any account - should succeed
10. Verify: `tokenURI(0)` returns a `data:application/json;base64,...` URI. Copy it into a browser address bar to see the decoded JSON and embedded SVG
11. Once everything works, switch to Injected Provider and redeploy on Sepolia
