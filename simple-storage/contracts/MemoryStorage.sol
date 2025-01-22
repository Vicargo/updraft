// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
    1. 📕 How does the Solidity compiler handle primitive types and strings in terms of memory management?
    2. 📕 Why can't the storage keyword be used for variables inside a function?
    3. 🧑‍💻 Write a smart contract that uses storage, memory and calldata keywords for its variables.

    // Answers
    1. The Solidity compiler knows how to handle the memory of primitive types. However, for strings, arrays, structs, and mappings, we need to specify the data location.
    Solidity provides three data locations: memory, calldata, and storage.
    Memory is commonly used to declare temporary variables that can be modified during execution.
    Calldata is immutable and is used to handle input parameters for functions.
    Storage is persistent and used for variables declared at the contract scope, which are implicitly assigned to storage by default. 
   
    2. Variables inside a function only exist when the function is called and storage variables are persistent

    3. The contract: 
*/

contract MemoryStorage {

    // Storage variable
    struct Person {
        string name;
        string aliasName;
        uint256 favoriteNumber;
    }

    Person[] public people;

    function addPerson (string calldata _name, string calldata _aliasName, uint256 _favoriteNumber) public {
        // _name is recived by input and cant be rewrited thats why is defined as calldata
        // _alias is recived by input and we will add an '@' at the begining of the name
        // _favoriteNumber is a primitive type and we dont need to specify what type of memory needs to use. 
        people.push(Person(_name, concatenateAlias(_aliasName), _favoriteNumber));
    }


    function concatenateAlias(string memory aliasName) internal pure returns (string memory) {
        return string(abi.encodePacked("@", aliasName));
    }
}