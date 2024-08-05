// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract WalletTest is Test {
    Wallet wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    function testOwner() public view {
        assertEq(wallet.owner(), address(this));
    }

    function testFailonOwnerChange() public {
        vm.prank(address(1));
        wallet.setOwner(address(3));
    }

    function testFailOnOwnerChangeAgain() public {
        wallet.setOwner(address(1));
        vm.startPrank(address(1));
        wallet.setOwner(address(2));
        vm.stopPrank();
        wallet.setOwner(address(1));
    }

    function _send(uint amount) internal {
        (bool success, ) = payable(wallet).call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    //Sending Ether to the contact

    function testSendEther() public {
        _send(100);
        assertEq(address(wallet).balance, 100);
    }

    // send ether using deal function

    function testDeal() public {
        deal(address(1), 100);
        assertEq(address(1).balance, 100);
    }

    function testHoax() public {
        uint balance = address(wallet).balance;
        hoax(address(1), 100);
        _send(100);
        assertEq(address(wallet).balance, balance + 100);
    }
}
