// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StructConstructor {
    struct UserInfo {
        string name;
        uint256 age;
        address wallet;
        bool isActive;
    }

    UserInfo public user;

    constructor(UserInfo memory _user) {
        user = _user;
    }

    function getUser() public view returns (UserInfo memory) {
        return user;
    }

    function getUserName() public view returns (string memory) {
        return user.name;
    }

    function getUserAge() public view returns (uint256) {
        return user.age;
    }

    function getUserWallet() public view returns (address) {
        return user.wallet;
    }

    function isUserActive() public view returns (bool) {
        return user.isActive;
    }
}
