// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {CampaignFactory} from "../src/CampaignFactoryTest.sol";
import {Campaign} from "../src/Campaign.sol";

contract CampaignFactoryTest is Test {
    CampaignFactory cf;
    function setUp() public {
        cf = new CampaignFactory();
    }

    function testShouldCreateACampaign() public {
        address c = cf.createCampain(
            "heheehhehehe",
            200,
            10,
            Campaign.CampaignType.FIXED
        );
        assertEq(c, cf.campaigns(address(this), 0));
    }

    function testShouldReturnCampaignCount() public {
        cf.createCampain("heheehhehehe", 200, 10, Campaign.CampaignType.FIXED);
        uint count = cf.getCampaignCounts();
        assertEq(count, 1);
    }
}
