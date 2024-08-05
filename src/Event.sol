// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Event {
    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address to, uint256 value) public {
        emit Transfer(msg.sender, to, value);
    }
}
