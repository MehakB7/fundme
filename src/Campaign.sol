// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {console} from "forge-std/Test.sol";

error CampaignHasEnded();
error NotAutorized();
error CampaignStillRunning();
error CampaignFailed();

contract Campaign {
    event DonationReceived(address indexed donor, uint amount);
    event CampaginEnded(bool isSuccess);

    enum CampaignType {
        FIXED,
        FLEXIBLE
    }

    uint public goal;
    uint public endDate;
    uint public startTime;
    address public owner;
    bool public campaignEnded;
    bool public isSuccess;
    string public cid;

    CampaignType public campaignType = CampaignType.FIXED;
    mapping(address => uint) public donars;
    address[] public donarAddress;

    constructor(
        string memory _cid,
        uint _goal,
        uint _daysToend,
        address _owner,
        CampaignType _campaignType
    ) {
        cid = _cid;
        goal = _goal;
        endDate = block.timestamp + (_daysToend * 1 days);
        campaignType = _campaignType;
        owner = _owner;
        startTime = block.timestamp;
    }

    modifier isWithinDate() {
        if (block.timestamp > endDate) {
            campaignEnded = true;
            revert CampaignHasEnded();
        }
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotAutorized();
        }
        _;
    }

    function deposite() public payable isWithinDate {
        if (campaignEnded) {
            revert CampaignHasEnded();
        }
        if (donars[msg.sender] == 0) {
            donarAddress.push(msg.sender);
        }
        donars[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        if (!campaignEnded) {
            revert CampaignStillRunning();
        }

        if (!isSuccess && campaignType == CampaignType.FIXED) {
            revert CampaignFailed();
        }

        (bool success, ) = address(owner).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    function withdrawByDoner() public {
        if (!campaignEnded) {
            revert CampaignStillRunning();
        }

        require(
            campaignType == CampaignType.FLEXIBLE,
            "can't withdraw money from fixed campagin"
        );

        uint donataion = donars[msg.sender];
        if (donataion != 0) {
            donars[msg.sender] = 0;
            (bool success, ) = msg.sender.call{value: donataion}("");
            require(success);
        }
    }

    function endCampaign() public onlyOwner {
        campaignEnded = true;
        if (goal <= address(this).balance) {
            isSuccess = true;
        }

        emit CampaginEnded(isSuccess);
    }

    receive() external payable {}
}
