// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, stdError} from "forge-std/Test.sol";
import {BuymeCoffeeFactory} from "../src/BuymeCoffeeFactory.sol";

contract BuymeCoffeeFactorTest is Test {
    BuymeCoffeeFactory bmcf;

    function setUp() external {
        bmcf = new BuymeCoffeeFactory();
    }

    function testContractShouldCreate() external {
        vm.prank(address(1));
        address a = bmcf.createBymeCoffee("Mehak");
        assertEq(bmcf.getBMCAddressByUserAddress(address(1)), a);
    }

    function testBuyMeContractShouldFail() external {
        vm.prank(address(1));
        bmcf.createBymeCoffee("Mehak");
        vm.expectRevert(BuymeCoffeeFactory.UserAlreadyExist.selector);
        vm.prank(address(1));
        bmcf.createBymeCoffee("Mehak");
    }

    function testShouldreturnZeroIfUserHaveNoContract() external view {
        assertEq(bmcf.getBMCAddressByUserAddress(address(1)), address(0));
    }
}
