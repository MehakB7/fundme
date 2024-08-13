// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BuymeCoffee {
    address public owner;
    string public owenrName;
    error NotOwner();
    event BuyMeCoffeeEvent(
        string name,
        string message,
        address from,
        uint256 timestamp
    );

    struct Members {
        string name;
        string message;
        address from;
        uint256 timestamp;
    }

    Members[] public members;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    constructor(address _owner, string memory _name) {
        owner = _owner;
        owenrName = _name;
    }

    function buymeCoffee(
        string calldata _name,
        string calldata _message
    ) public payable {
        require(msg.value > 0, "Can't buy me coffee for free");

        Members memory member = Members(
            _name,
            _message,
            msg.sender,
            block.timestamp
        );
        members.push(member);

        emit BuyMeCoffeeEvent(_name, _message, msg.sender, block.timestamp);
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getMembersCount() public view returns (uint256) {
        return members.length;
    }
}
