// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, stdError} from "forge-std/Test.sol";
import {Campaign, CampaignHasEnded, CampaignStillRunning} from "../src/Campaign.sol";

contract CampaignTest is Test {
    event DonationReceived(address indexed donor, uint amount);
    Campaign c;
    Campaign fc;
    uint256 startTime;
    uint256 endTime;
    uint256 dayDuration = 4;
    uint goal = 400;
    string cid = "Mehak";
    Campaign.CampaignType ct = Campaign.CampaignType.FIXED;

    function setUp() public {
        startTime = block.timestamp;
        endTime = block.timestamp + dayDuration * 1 days;
        c = new Campaign(cid, goal, dayDuration, address(this), ct);

        fc = new Campaign(
            cid,
            goal,
            dayDuration,
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
        assertTrue(c.hasCampaignSucceed() == true, "campaing run successfully");
        c.withdraw();
        assertEq(address(c).balance, 0);
    }

    function testWithdrawFlexibleCampaignByOwner() public {
        hoax(address(1), 300);
        donate(300, address(fc));
        assertEq(address(fc).balance, 300);
        fc.endCampaign();
        assertTrue(c.hasCampaignSucceed() == false, "campaing failed");
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

    function testGetInfoshouldReturnCampaignInfo() public {
        hoax(address(1), 300);
        donate(300, address(c));
        (
            uint256 r_goal,
            uint256 r_totalDonation,
            uint256 r_campaignEndDate,
            bool r_hasCampaignEnded,
            bool r_hasCampaignSucceed,
            address r_owner,
            Campaign.CampaignType r_ct
        ) = c.getCampiagnInfo();
        assertEq(r_goal, goal);
        assertEq(r_totalDonation, 300);
        assertEq(r_campaignEndDate, endTime);
        assertEq(r_hasCampaignEnded, false);
        assertEq(r_hasCampaignSucceed, false);
        assertEq(r_owner, address(this));
        assertEq(uint8(r_ct), uint8(ct));
    }

    receive() external payable {}
}
