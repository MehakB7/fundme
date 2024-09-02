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

    address private owner;
    bool private hasCampaignEnded;
    bool private hasCampaignSucceed;
    CampaignType private campaignType = CampaignType.FIXED;

    uint256 private goal;
    uint256 private endDate;
    uint256 private startTime;
    uint256 private totalDonation;

    string private cid;

    mapping(address => uint) private donars;
    address[] private donarAddress;

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
            hasCampaignEnded = true;
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
        if (hasCampaignEnded) {
            revert CampaignHasEnded();
        }
        if (donars[msg.sender] == 0) {
            donarAddress.push(msg.sender);
        }
        donars[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, msg.value);
        totalDonation += msg.value;
    }

    function withdraw() public onlyOwner {
        if (!hasCampaignEnded) {
            revert CampaignStillRunning();
        }

        if (!hasCampaignSucceed && campaignType == CampaignType.FIXED) {
            revert CampaignFailed();
        }

        (bool success, ) = address(owner).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    function withdrawByDoner() public {
        if (!hasCampaignEnded) {
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
        hasCampaignEnded = true;
        if (goal <= address(this).balance) {
            hasCampaignSucceed = true;
        }

        emit CampaginEnded(hasCampaignSucceed);
    }

    receive() external payable {}

    function totalDonars() external view returns (uint256) {
        return donarAddress.length;
    }

    function getGoal() external view returns (uint256) {
        return goal;
    }

    function getTotalDonation() external view returns (uint256) {
        return totalDonation;
    }

    function getCId() external view returns (string memory) {
        return cid;
    }

    function getCampiagnInfo()
        external
        view
        returns (uint256, uint256, uint256, bool, bool, address, CampaignType)
    {
        return (
            goal,
            totalDonation,
            endDate,
            hasCampaignEnded,
            hasCampaignSucceed,
            owner,
            campaignType
        );
    }
}
