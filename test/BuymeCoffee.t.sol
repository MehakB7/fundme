// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, stdError} from "forge-std/Test.sol";
import {BuymeCoffee} from "../src/BuymeCoffee.sol";

contract BuymeCoffeeTest is Test {
    BuymeCoffee buymeCoffee;

    event BuyMeCoffeeEvent(
        string name,
        string message,
        address from,
        uint256 timestamp
    );

    function setUp() public {
        buymeCoffee = new BuymeCoffee(address(this), "Mehak");
    }

    function testuseBuyCoffee() public {
        hoax(address(1), 100);
        (bool success, ) = address(buymeCoffee).call{value: 100}(
            abi.encodeWithSignature(
                "buymeCoffee(string,string)",
                "John",
                "Hello from Mehak"
            )
        );

        require(success);

        (
            string memory name,
            string memory message,
            address from,
            uint256 timestamp
        ) = buymeCoffee.members(0);

        assertEq(name, "John");
        assertEq(message, "Hello from Mehak");
        assertEq(from, address(1));
        assertEq(timestamp, block.timestamp);
        assertEq(address(buymeCoffee).balance, 100);
    }

    function testRevertOnwithdrawByNonOwner() public {
        vm.expectRevert(BuymeCoffee.NotOwner.selector);
        vm.prank(address(1));
        buymeCoffee.withdraw();
    }

    function testBuyEventShouldEmit() public {
        vm.expectEmit(true, true, true, true);
        emit BuyMeCoffeeEvent(
            "Jane Doe",
            "Hey get going",
            address(1),
            block.timestamp
        );
        hoax(address(1), 100);
        (bool success, ) = address(buymeCoffee).call{value: 100}(
            abi.encodeWithSignature(
                "buymeCoffee(string,string)",
                "Jane Doe",
                "Hey get going"
            )
        );

        require(success);
    }

    function testRevertIfNoEthSend() public {
        vm.expectRevert(bytes("Can't buy me coffee for free"));
        vm.prank(address(1));
        buymeCoffee.buymeCoffee("Lazy", "It will fail");
    }
}
