# Chainlink Price Guard

This repository provides a secure way to consume off-chain price data. Many DeFi hacks occur because protocols trust "stale" or "frozen" oracle data. This implementation adds a layer of validation to ensure the data is fresh and the oracle is functioning correctly.

## Security Features
* **Stale Data Check**: Reverts if the price was updated longer ago than the specified "Heartbeat" (e.g., 3600 seconds).
* **L2 Sequencer Check**: Integrated logic for Arbitrum/Optimism to ensure the sequencer is up before trusting the price.
* **Decimals Scaling**: Automatically handles price scaling to ensure compatibility with 18-decimal DeFi math.

## Setup
1. Deploy to a network supported by Chainlink (Ethereum, Polygon, Arbitrum, etc.).
2. Initialize with the `PriceFeed` address for your desired asset (e.g., ETH/USD).
3. Call `getLatestPrice()` to receive a validated, 18-decimal scaled price.
