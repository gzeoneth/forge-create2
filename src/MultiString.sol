// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiString {
    string public name;
    string public symbol;
    uint256 public totalSupply;

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
    }
}