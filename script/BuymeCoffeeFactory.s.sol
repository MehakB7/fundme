// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BuymeCoffeeFactory} from "../src/BuymeCoffeeFactory.sol";

contract BuymeCoffeeFactoryScript is Script {
    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        new BuymeCoffeeFactory();
        vm.stopBroadcast();
    }
}
