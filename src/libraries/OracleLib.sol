// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/*
* @title OracleLib
* @author Patrick Collins
* @notice This library is used to check the Chainlink Oracle for stale data.
* the function will revert, and render the DSCEngine unusable
* We want the DSCEngine to freeze if prices become stale.
* So if the chainlink network explodes and you have a lot of money locked in the protocol.. that will be too bad
*/
library OracleLib {
    error OracleLib_StalePrice();

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInfund) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) revert OracleLib_StalePrice();
        return (roundId, answer, startedAt, updatedAt, answeredInfund);
    }
}
