// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
    1. 📕 Define the difference between a _dynamic_ array and a _static_ array. Make an example of each.
    2. 📕 What is an _array_ and what is a _struct_?
    3. 🧑‍💻 Create a smart contract that can store and view a list of animals. Add manually three (3) animals and give the possibility to the user to manually add an indefinite number of animals into the smart contract.


    1. In a dynamic array we can add as many objects as we want, in a static array is defined when we initializes it.
        Example of dynamic array: 
            unit256[] numbers;
        Example of static array;
            unit256[3] staticNumbers;
    
    2. We can store a stack of variables in array, these variables has a type (uint, bytes, address...) and a struct is new type 
       defined by us.
*/
contract AnimalsStorage {

    struct Animal {
        string name;
        uint16 age;
    }

    Animal[] public listOfAnimals;

    constructor() {
        listOfAnimals.push(Animal("Peter Lion", 26));
        listOfAnimals.push(Animal("Mad shark", 4));
        listOfAnimals.push(Animal("Pluto dog", 8));
    }


    function add_animal(string memory _name, uint16 _age) public {
        listOfAnimals.push(Animal(_name, _age));
    }

}