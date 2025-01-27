
# Solidity Basics

## Modifiers
In Solidity, modifiers are reusable pieces of code used to alter the behavior of functions in a consistent and simple way. They are placed as labels on functions and are used to add restrictions or execute additional logic before or after the main logic of the function is executed.

----------------------------------------------------

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
----------------------------------------------------

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
----------------------------------------------------

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
----------------------------------------------------

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
----------------------------------------------------

### Anonymous
**Definition:** Used in events to make them anonymous, removing their signature from the blockchain logs.

**Characteristics:**
 - It makes the event lighter (less costly in gas).
 - It cannot be filtered by the event name in the logs.

```solidity
event MyEvent(uint indexed value) anonymous;
```
----------------------------------------------------

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
----------------------------------------------------

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

----------------------------------------------------


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




