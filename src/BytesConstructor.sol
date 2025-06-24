// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BytesConstructor {
    bytes public data;

    constructor(bytes memory _data) {
        data = _data;
    }

    function getData() public view returns (bytes memory) {
        return data;
    }

    function getDataLength() public view returns (uint256) {
        return data.length;
    }

    function getDataAt(uint256 index) public view returns (bytes1) {
        require(index < data.length, "Index out of bounds");
        return data[index];
    }

    function getDataSlice(uint256 start, uint256 end) public view returns (bytes memory) {
        require(start <= end && end <= data.length, "Invalid slice bounds");

        bytes memory slice = new bytes(end - start);
        for (uint256 i = 0; i < slice.length; i++) {
            slice[i] = data[start + i];
        }
        return slice;
    }
}
