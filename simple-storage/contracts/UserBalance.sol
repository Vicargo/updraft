// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    1. 📕 In which cases is better to use an array instead of a mapping?
    2. 🧑‍💻 Create a Solidity contract with a mapping named `addressToBalance`. Implement functions to add and retrieve data from this mapping.

    // Answers
    1. When we need to iterate it, we have to know that iterates an array is expensive and time-consuming
    2. Contract: 
*/

contract UserBalance {

    struct User {
        address account;
        uint256 balance;
    }

    User[] public users;
    mapping(address => uint256) public addressToBalance;

    function addUser (address _address, uint256 _balance) public {
        addressToBalance[_address] = _balance;
    } 

}