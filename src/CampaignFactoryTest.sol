// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Campaign} from "./Campaign.sol";

contract CampaignFactory {
    mapping(address => address[]) public campaigns;
    function createCampain(
        string calldata cid,
        uint target,
        uint daysToEnd,
        Campaign.CampaignType campaignType
    ) public returns (address) {
        Campaign c = new Campaign(
            cid,
            target,
            daysToEnd,
            msg.sender,
            campaignType
        );
        campaigns[msg.sender].push(address(c)); // a good way would be storging this off chain
        return address(c);
    }

    function getCampaignCounts() public view returns (uint) {
        return campaigns[msg.sender].length;
    }
}
