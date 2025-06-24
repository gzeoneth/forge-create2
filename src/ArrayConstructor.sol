// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayConstructor {
    uint256[] public numbers;
    
    constructor(uint256[] memory _numbers) {
        numbers = _numbers;
    }
    
    function getNumbers() public view returns (uint256[] memory) {
        return numbers;
    }
    
    function getNumberAt(uint256 index) public view returns (uint256) {
        require(index < numbers.length, "Index out of bounds");
        return numbers[index];
    }
    
    function getLength() public view returns (uint256) {
        return numbers.length;
    }
}