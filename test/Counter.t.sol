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

    function testFailDec() public {
        counter.dec();
    }

    function test_revert_dec_on_zero() public {
        vm.expectRevert(stdError.arithmeticError);
        counter.dec();
    }
}
