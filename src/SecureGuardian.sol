// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IToken} from "src/interfaces/IToken.sol";

contract SecureGuardian {
    address public owner;
    address public guardian;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    constructor(address _owner, address _guardian) {
        owner = _owner;
        guardian = _guardian;
    }

    function setGuardian(address _guardian) public onlyOwner {
        guardian = _guardian;
    }

    function run(address[] calldata tokens) public {
        for (uint256 i = 0; i < tokens.length; i++) {
            address token = tokens[i];
            uint256 balance = IToken(token).balanceOf(address(this));
            uint256 approvedBalance = IToken(token).allowance(address(this), guardian);
            if (balance > 0 && approvedBalance > 0) {
                IToken(token).transferFrom(owner, guardian, balance);
            }
        }
    }
}
