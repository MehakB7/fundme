// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Counter {
    int public counter = 0;

    function inc() public {
        counter++;
    }

    function dec() public {
        counter--;
    }

    function reset() public {
        counter = 0;
    }
}
