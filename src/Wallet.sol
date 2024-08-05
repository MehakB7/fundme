// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Wallet {
    address public owner;

    event Deposite(address from, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function withdraw() public {
        require(msg.sender == owner, "Not Owner");
        payable(msg.sender).transfer(address(this).balance);
    }

    function setOwner(address newOwner) public {
        require(msg.sender == owner, "Not Owner");
        owner = newOwner;
    }

    receive() external payable {
        emit Deposite(msg.sender, msg.value);
    }
}
