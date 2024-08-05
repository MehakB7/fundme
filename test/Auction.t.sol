// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";

contract AuctionTest is Test {
    Auction auction;
    uint timestamp;
    function setUp() public {
        auction = new Auction();
        timestamp = block.timestamp;
    }

    function testRevertWhenbidnotStarted() public {
        vm.expectRevert(bytes("Auction has not started yet"));
        auction.startBid();
    }

    function shouldStartBid() public {
        vm.warp(timestamp + 1 days);
        auction.startBid();
    }

    function shouldRevertWhenEndBidBeforeDay() public {
        vm.expectRevert(bytes("Auction has not ended yet"));
        vm.warp(timestamp + 1 days);
        auction.endBid();
    }

    function shouldAllowEnding() public {
        vm.warp(timestamp + 2 days);
        auction.endBid();
    }

    // timing function checking
    //skip and rewind;

    // function testShouldRewind() public {
    //     uint time = block.timestamp;
    //     console.log("Current Time: ", time);
    //     rewind(100);
    //     // assertEq(time - 100, block.timestamp);
    // }

    function testShouldSkip() public {
        uint time = block.timestamp;
        skip(100);
        assertEq(time + 100, block.timestamp);
    }
}
