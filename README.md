
# Solidity Basics
This document contains notes from [Patrick Collins](https://www.youtube.com/c/PatrickCollins) course [Solidity Smart Contract Development](https://updraft.cyfrin.io/courses/solidity) hosted in Updraft.

## Variables

### Native types
Native types are the basic types built into the Solidity language, such as integers, booleans, and bytes. These are the simplest building blocks for manipulating data.

**Boolean (`bool`)**
 - Represents true or false values.
 - Occupies only 1 bit.

```solidity
bool isActive = true;
```

**Unsigned Integers (`uint`)**
- Represents non-negative integers (only positive values and zero).
- Available sizes: `uint8`, `uint16`, `uint32`, ..., up to `uint256` (multiples of 8 bits).
- By default, using `uint` without specifying the size makes it `uint256`.

```solidity
uint age = 25;        // Positive integer (default is uint256).
uint16 smallNumber = 100;  // 16-bit positive integer.
```

**Signed Integers (`int`)**
- Represents integers, both positive and negative.
- Available sizes: `int8`, `int16`, `int32`, ..., up to `int256` (multiples of 8 bits).
- By default, using `int` without specifying the size makes it `int256`.

```solidity
int balance = -10;  // Signed integer.
int256 bigNumber = 123456; 
```

**Address (`address`)**
- Represents an Ethereum address (160 bits).
- Used to store the address of contracts or accounts.
- Includes useful functions like `balance` (to check the balance of an address) and `transfer` (to send Ether).

```solidity
address owner = 0x1234567890123456789012345678901234567890;

function getBalance() public view returns (uint) {
    return owner.balance; // Returns the balance of the address.
}
```

**Bytes (`bytes`)**
 - Represents sequences of bytes (binary data arrays).
 - Two variants:
   1. Fixed bytes: `bytes1`, `bytes2`, ..., up to `bytes32`.
   2. Dynamic Bytes: `bytes`.

```solidity
bytes32 fixedBytes = "Hello, Solidity!";  // Up to 32 bytes.
bytes dynamicBytes = "Hello, World!";     // Flexible size.
```

**String (`string`)** 
- Represents dynamically-sized text.
- Uses significant storage space, so use it only when necessary.
- Unlike `bytes`, you cannot directly manipulate each character.

```solidity
string public greeting = "Hello, Solidity!";
```

**Enum (`enum`)**
- Defines a set of constant values called "enumerations."
- Useful for managing finite states.

```solidity
enum Status { Active, Inactive, Pending }

Status public currentStatus = Status.Active;

function setStatus(Status _status) public {
    currentStatus = _status;
}
```

**Arrays (`[]`)**
- Represents collections of elements of the same type.
- Can be static (fixed size) or dynamic (variable size).

```solidity
uint[3] fixedArray = [1, 2, 3]; // Fixed-size array.
uint[] dynamicArray;           // Dynamic-size array.

function addElement(uint element) public {
    dynamicArray.push(element); // Add an element to the dynamic array.
}
```

**Structs (`User`)**
- Allows grouping a set of variables under a single name.
  
```solidity
struct User {
    string name;
    uint age;
}

User public user;

function createUser(string memory _name, uint _age) public {
    user = User(_name, _age);
}
```

**Mappings (`mapping`)**
- Represents key-value pair data structures.
- Keys can be any basic type, but mappings cannot be iterated.

```solidity
mapping(address => uint) public balances;

function deposit() public payable {
    balances[msg.sender] += msg.value; // Updates the sender's balance.
}
```
  
## Data Locations
The Solidity compiler knows how to handle the memory of primitive types. However, for strings, arrays, structs, and mappings, we need to specify the data location. Solidity provides three data locations: memory, calldata, and storage.

**Memory (`memory`)** 

Commonly used to declare temporary variables that can be modified during execution.

```solidity
function concatenateAlias(string memory aliasName) internal pure returns (string memory) {
   return string(abi.encodePacked("@", aliasName));
}
```

**Calldata (`calldata`)**

Immutable and is used to handle input parameters for functions. More efficient in term of gas, it cant be modified. 

```solidity
function printMessage(string calldata message) public pure returns (string memory) {
    return message;
}
```

**Storage (`storage`)**  
Persistent and used for variables declared at the contract scope, which are implicitly assigned to storage by default. 

```solidity
string public storedName;

function setName(string memory name) public {
    storedName = name;
}
```

----------------------------------------------------

## Visibility: 
In Solidity, functions and variables can have one of these four visibility specifiers:

* 🌎 **`public`**: accessible from both inside the contract and from external contracts
* 🏠 **`private`**: accessible only within the _current contract_. It does not hide a value but only restricts its access.
* 🌲 **`external`**: used only for *_functions_*. Visible only from *_outside_* the contract.
* 🏠🏠 **`internal`**: accessible by the current contract and any contracts *_derived_* from it.

----------------------------------------------------

## Modifiers
In Solidity, modifiers are reusable pieces of code used to alter the behavior of functions in a consistent and simple way. They are placed as labels on functions and are used to add restrictions or execute additional logic before or after the main logic of the function is executed.


### Pure
**Definition:** A function marked as `pure` cannot read or modify the state of the blockchain.

**Characteristics:**
 - It does not interact with state variables (stored in the contract).
 - It does not read information from the blockchain (such as `block.timestamp` or `msg.sender`).
 - It can only operate with provided parameters or local data.

**Common use:** Perform calculations or transform data.

```solidity
function add(uint a, uint b) public pure returns (uint) {
    return a + b;
}
```

### View
**Definition:** A function marked as `view` can read values from the blockchain state but cannot modify them.

**Characteristics:**
 - It cannot change values in the contract.
 - It allows querying state variables or blockchain information.
 - It can be executed without consuming gas (if called externally).

**Common use:** Query data stored in the contract.

```solidity
uint public myValue;

function getMyValue() public view returns (uint) {
    return myValue;
}
```


### Payable 
**Definition:** A function marked as `payable` allows receiving ether (or funds in general) into the contract.

**Characteristics:**
 - Without this modifier, a function cannot accept payments.
 - It is necessary for functions that allow ether transfers to the contract.
   
**Common use:** Receive payments or transfer funds within contracts.

```solidity 
  function deposit() public payable {
      require(msg.value > 0, "Debe enviar fondos mayores a 0"); // Asegura que se envíen fondos.
  }
```


### Immutable
**Definition:** Variables marked as `immutable` are initialized only once (usually in the constructor) and cannot be changed afterwards.

**Características:**
 - It is used to optimize variables that are constant after initialization.
 - It offers more flexibility than `constant`, as it allows initializing the value at runtime (not just during declaration).

```solidity
uint public immutable startTime;

constructor() {
    startTime = block.timestamp; // Initialized in the constructor.
}
```


### Anonymous
**Definition:** Used in events to make them anonymous, removing their signature from the blockchain logs.

**Characteristics:**
 - It makes the event lighter (less costly in gas).
 - It cannot be filtered by the event name in the logs.

```solidity
event MyEvent(uint indexed value) anonymous;
```

### Indexed
**Definition:** Used in events to allow certain parameters to be indexed and searchable in the blockchain logs.

**Características:**
 - A maximum of 3 parameters per event can be indexed.
 - It facilitates searching for events in blockchain explorers.

```solidity
event MyEvent(uint indexed value, address indexed sender);

function emitEvent(uint value) public {
    emit MyEvent(value, msg.sender);
}
```


### Virtual
**Definition:** Allows a function to be overridden in derived contracts.

**Characteristics:**
 - It is used in base contracts for functions that need to be customizable.
 - If a function is not marked as `virtual`, it cannot be modified.

```solidity
contract Base {
    function greet() public virtual returns (string memory) {
        return "Hello from Base!";
    }
}
```

### Override
**Definition:** Indicates that a function overrides a previous version defined in a base contract.

**Characteristics:**
 - It is used alongside `virtual` functions.
 - It is mandatory to specify `override` for functions that modify others inherited from a base contract.

```solidity
contract Derived is Base {
    function greet() public override returns (string memory) {
        return "Hello from Derived!";
    }
}
```

## Send Native crypto from a contract
We can use three different methods to send native crypto from one account to another: `transfer`, `send` and `call`.

### Transfer
The `transfer` function is the simplest way to send Ether to a recipient address:

```solidity
payable(msg.sender).transfer(amount); // the current contract sends the Ether amount to the msg.sender
```

### Send
The `send` function is similar to `transfer`, but it differs in its behaviour. 

Like `transfer`, `send` also has a gas limit of 2300. If the gas limit is reached, it will not revert the transaction but return a boolean value (`true` or `false`) to indicate the success or failure of the transaction. It is the developer's responsibility to handle failure correctly, and it's good practice to trigger a **revert** condition if the `send` returns `false`.


```solidity
bool success = payable(msg.sender).send(address(this).balance);
require(success, "Send failed");
```

### Call
The `call` function is flexible and powerful. It can be used to call any function **without requiring its ABI**. It does not have a gas limit, and like `send`, it returns a boolean value instead of reverting like `transfer`.

```solidity
(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
require(success, "Call failed");
```
To send funds using the `call` function, we convert the address of the receiver to `payable` and add the value inside curly brackets before the parameters passed.

The `call` function returns two variables: a boolean for success or failure, and a byte object which stores returned data if any.

> 👀❗**IMPORTANT**:
> 
> `call` is the recommended way of sending and receiving Ethereum or other blockchain native tokens.

