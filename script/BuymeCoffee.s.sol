// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BuymeCoffee} from "../src/BuymeCoffee.sol";

contract BuymeCoffeeScript is Script {
    function run() public {
        uint privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        BuymeCoffee bmc = new BuymeCoffee(
            address(0x6b6249aB088A1C07f632a922BcDAD22733cBaf92),
            "Mehak"
        );
        vm.stopBroadcast();
    }
}
