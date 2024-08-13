// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {BuymeCoffee} from "./BuymeCoffee.sol";

contract BuymeCoffeeFactory {
    error UserAlreadyExist();
    BuymeCoffee public bmc;

    mapping(address => address) alreadyUser;

    function createBymeCoffee(
        string calldata _name
    ) external returns (address) {
        if (alreadyUser[msg.sender] != address(0)) {
            revert UserAlreadyExist();
        }
        bmc = new BuymeCoffee(msg.sender, _name);
        alreadyUser[msg.sender] = address(bmc);
        return address(bmc);
    }

    function getBMCAddressByUserAddress(
        address user
    ) external view returns (address) {
        return alreadyUser[user];
    }
}
