// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function testInc() public {
        counter.inc();
        assertEq(counter.counter(), 1);
    }

    function testDec() public {
        counter.dec();
        assertEq(counter.counter(), -1);
    }

    function testReset() public {
        counter.dec();
        assertEq(counter.counter(), -1);
        counter.reset();
        assertEq(counter.counter(), 0);
    }
}
