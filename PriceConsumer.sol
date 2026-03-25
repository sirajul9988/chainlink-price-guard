// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumer {
    AggregatorV3Interface internal immutable priceFeed;
    uint256 public immutable heartbeat;

    /**
     * @param _priceFeed The address of the Chainlink Aggregator
     * @param _heartbeat The maximum time (in seconds) between updates (e.g. 3600 for 1hr)
     */
    constructor(address _priceFeed, uint256 _heartbeat) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        heartbeat = _heartbeat;
    }

    /**
     * @notice Returns the latest price after performing safety checks
     * @return price The asset price scaled to 18 decimals
     */
    function getLatestPrice() public view returns (uint256) {
        (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        // 1. Check for stale data
        require(updatedAt > 0, "Round not complete");
        require(answeredInRound >= roundId, "Stale price: round mismatch");
        require(block.timestamp - updatedAt <= heartbeat, "Stale price: heartbeat exceeded");
        
        // 2. Check for negative/zero price
        require(answer > 0, "Invalid price: non-positive");

        // 3. Scale to 18 decimals
        uint8 decimals = priceFeed.decimals();
        return uint256(answer) * (10 ** (18 - decimals));
    }
}
