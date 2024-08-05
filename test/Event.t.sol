// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

contract EventTest is Test {
    Event ev;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function setUp() public {
        ev = new Event();
    }

    function testTransfer() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), address(1), 300);
        ev.transfer(address(1), 300);
    }

    function testFailTransfer() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), address(1), 300);
        ev.transfer(address(1), 5000);
    }
}
