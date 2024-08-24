// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Campaign, CampaignHasEnded, CampaignStillRunning} from "../src/Campaign.sol";

contract CampaignTest is Test {
    event DonationReceived(address indexed donor, uint amount);
    Campaign c;
    Campaign fc;
    function setUp() public {
        c = new Campaign(
            "Mehak",
            400,
            4,
            address(this),
            Campaign.CampaignType.FIXED
        );

        fc = new Campaign(
            "Mehak",
            400,
            4,
            address(this),
            Campaign.CampaignType.FLEXIBLE
        );
    }

    function donate(uint amount, address _contract) internal {
        (bool success, ) = address(_contract).call{value: amount}(
            abi.encodeWithSignature("deposite()")
        );
        require(success);
    }

    function testDonarCanDonate() public {
        hoax(address(1), 100);
        donate(100, address(c));
        assertEq(address(c).balance, 100);
    }

    function testDonationRevertWhenCampignEnd() public {
        c.endCampaign();
        hoax(address(1), 100);
        vm.expectRevert(CampaignHasEnded.selector);
        donate(100, address(c));
    }

    function testDonationRevertWhenCampignEndTimePassed() public {
        vm.warp(block.timestamp + 5 days);
        hoax(address(1), 100);
        vm.expectRevert(CampaignHasEnded.selector);
        donate(100, address(c));
    }

    function testDonationEventShoudlEmit() public {
        hoax(address(1), 100);
        vm.expectEmit(true, false, false, true);
        emit DonationReceived(address(1), 100);
        donate(100, address(c));
    }

    function testWithdrawFixedCampaignByOwner() public {
        hoax(address(1), 400);
        donate(400, address(c));
        assertEq(address(c).balance, 400);
        c.endCampaign();
        assertTrue(c.isSuccess() == true, "campaing run successfully");
        c.withdraw();
        assertEq(address(c).balance, 0);
    }

    function testWithdrawFlexibleCampaignByOwner() public {
        hoax(address(1), 300);
        donate(300, address(fc));
        assertEq(address(fc).balance, 300);
        fc.endCampaign();
        assertTrue(c.isSuccess() == false, "campaing failed");
        fc.withdraw();
        assertEq(address(fc).balance, 0);
    }

    function testRevertWhenWithdrawonRunning() public {
        hoax(address(1), 300);
        donate(300, address(c));
        vm.expectRevert(CampaignStillRunning.selector);
        c.withdraw();
    }

    function testAllowDonarToWithdrawFromFixedCampaign() public {}

    receive() external payable {}
}
