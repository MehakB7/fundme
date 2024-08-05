// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract ErrorTest is Test {
    Error error;

    function setUp() public {
        error = new Error();
    }

    function testThrowError() public {
        vm.expectRevert(bytes("Error Message"));
        error.throwError();
    }

    function testThrowCustomError() public {
        vm.expectRevert(Error.NotOwner.selector);
        error.throwCustomError();
    }

    function testUnderFlowError() public {
        vm.expectRevert(stdError.arithmeticError);
        error.UnderFlowError();
    }
}
