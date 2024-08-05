// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Auction {
    uint startDay = block.timestamp + 1 days;
    uint endDay = startDay + 2 days;

    function startBid() public view {
        require(block.timestamp >= startDay, "Auction has not started yet");
        require(block.timestamp < endDay, "Auction has ended");
    }

    function endBid() public view {
        require(block.timestamp >= startDay, "Auction has not started yet");
        require(block.timestamp >= endDay, "Auction has not ended yet");
    }
}
