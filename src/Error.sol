// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Error {
    error NotOwner();

    function throwError() public pure {
        require(false, "Error Message");
    }

    function throwCustomError() public pure {
        revert NotOwner();
    }

    function UnderFlowError() public pure {
        uint256 x = 0;
        x--;
    }
}
