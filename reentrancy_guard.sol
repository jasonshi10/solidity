// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ReentrancyGuard {
    // Count stores number of times the function test was called
    uint public count;
    bool private locked;

    modifier lock() {
        require(!locked, "locked");
        locked = true;
        _;
        locked = false;
    }

    function test(address _contract) external lock {
        (bool success, ) = _contract.call("");
        require(success, "tx failed");
        count += 1;
    }
}
