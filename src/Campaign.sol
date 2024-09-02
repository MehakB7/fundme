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

    address private s_owner;
    bool private s_hasCampaignEnded;
    bool private s_hasCampaignSucceed;
    CampaignType private s_campaignType = CampaignType.FIXED;

    uint256 private s_goal;
    uint256 private s_endDate;
    uint256 private s_startTime;
    uint256 private s_totalDonation;

    string private s_cid;

    mapping(address => uint) private donars;
    address[] private donarAddress;

    constructor(
        string memory _cid,
        uint _goal,
        uint _daysToend,
        address _owner,
        CampaignType _campaignType
    ) {
        s_cid = _cid;
        s_goal = _goal;
        s_endDate = block.timestamp + (_daysToend * 1 days);
        s_campaignType = _campaignType;
        s_owner = _owner;
        s_startTime = block.timestamp;
    }

    modifier isWithinDate() {
        if (block.timestamp > s_endDate) {
            s_hasCampaignEnded = true;
            revert CampaignHasEnded();
        }
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != s_owner) {
            revert NotAutorized();
        }
        _;
    }

    function deposite() public payable isWithinDate {
        if (s_hasCampaignEnded) {
            revert CampaignHasEnded();
        }
        if (donars[msg.sender] == 0) {
            donarAddress.push(msg.sender);
        }
        donars[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, msg.value);
        s_totalDonation += msg.value;
    }

    function withdraw() public onlyOwner {
        if (!s_hasCampaignEnded) {
            revert CampaignStillRunning();
        }

        if (!s_hasCampaignSucceed && s_campaignType == CampaignType.FIXED) {
            revert CampaignFailed();
        }

        (bool success, ) = address(s_owner).call{value: address(this).balance}(
            ""
        );
        require(success);
    }

    function withdrawByDoner() public {
        if (!s_hasCampaignEnded) {
            revert CampaignStillRunning();
        }

        require(
            s_campaignType == CampaignType.FLEXIBLE,
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
        s_hasCampaignEnded = true;
        if (s_goal <= address(this).balance) {
            s_hasCampaignSucceed = true;
        }

        emit CampaginEnded(s_hasCampaignSucceed);
    }

    receive() external payable {}

    function totalDonars() external view returns (uint256) {
        return donarAddress.length;
    }

    function getGoal() external view returns (uint256) {
        return s_goal;
    }

    function getTotalDonation() external view returns (uint256) {
        return s_totalDonation;
    }

    function getCId() external view returns (string memory) {
        return s_cid;
    }

    function getCampiagnInfo()
        external
        view
        returns (uint256, uint256, uint256, bool, bool, address, CampaignType)
    {
        return (
            s_goal,
            s_totalDonation,
            s_endDate,
            s_hasCampaignEnded,
            s_hasCampaignSucceed,
            s_owner,
            s_campaignType
        );
    }
}
