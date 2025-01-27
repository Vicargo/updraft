# Solidity Basics

## Variables

### Native types
Los tipos nativos son los tipos básicos incorporados en el lenguaje, como enteros, booleanos, y bytes. Estos son los bloques de construcción más simples para manipular datos.

**boolean (`bool`)**
 - Representa valores verdadero o falso.
 - Ocupa solo 1 bit.

```solidity
bool isActive = true;
```

**Enteros sin signo (`uint`)**
- Representa números enteros no negativos (solo positivos y cero).
- Tamaños disponibles: `uint8`, `uint16`, `uint32`, ..., hasta `uint256` (múltiplos de 8 bits).
- Por defecto, si usas uint sin especificar tamaño, será `uint256`.

```solidity
uint age = 25;        // Entero positivo (por defecto, uint256).
uint16 smallNumber = 100;  // Entero positivo de 16 bits.
```

**Enteros con signo (`int`)**
- Representa números enteros positivos y negativos.
- Tamaños disponibles: `int8`, `int16`, `int32`, ..., hasta `int256` (múltiplos de 8 bits).
- Por defecto, si usas int sin especificar tamaño, será `int256`.

```solidity
int balance = -10;  // Entero con signo.
int256 bigNumber = 123456; 
```

**Address (`address`)**
- Representa una dirección de Ethereum (160 bits).
- Se usa para almacenar la dirección de contratos o cuentas.
- Tiene funciones útiles como balance (consulta el saldo de una dirección) y transfer (envía Ether).

```solidity
address owner = 0x1234567890123456789012345678901234567890;

function getBalance() public view returns (uint) {
    return owner.balance; // Devuelve el saldo de la dirección.
}
```

**Bytes (`bytes`)**
 - Representa secuencias de bytes (arreglos de datos binarios).
 - Hay dos variantes:
   1. Bytes fijos: `bytes1`, `bytes2`, ..., hasta `bytes32`.
   2. Bytes dinámicos: `bytes`.

```solidity
bytes32 fixedBytes = "Hello, Solidity!";  // Hasta 32 bytes.
bytes dynamicBytes = "Hello, World!";     // Tamaño flexible.
```

**String (`string`)** 
- Representa texto de longitud dinámica.
- Usa mucho espacio de almacenamiento, así que úsalo solo cuando sea necesario.
- A diferencia de bytes, no se puede manipular directamente cada carácter individual.

```solidity
string public greeting = "Hello, Solidity!";
```

**Enum (`enum`)**
- Define un conjunto de valores constantes llamados "enumeraciones".
- Útil para manejar estados finitos.

```solidity
enum Status { Active, Inactive, Pending }

Status public currentStatus = Status.Active;

function setStatus(Status _status) public {
    currentStatus = _status;
}
```

**Arrays (`[]`)**
- Representan colecciones de elementos del mismo tipo.
- Pueden ser estáticos (tamaño fijo) o dinámicos (tamaño variable).

```solidity
uint[3] fixedArray = [1, 2, 3]; // Array de tamaño fijo.
uint[] dynamicArray;           // Array de tamaño dinámico.

function addElement(uint element) public {
    dynamicArray.push(element); // Add an element to the dynamic array.
}

```

**Structs (`User`)**
- Permiten definir un conjunto de variables agrupadas bajo un solo nombre.
  
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
- Representa estructuras de datos de tipo `clave-valor`.
- Las claves pueden ser de cualquier tipo básico, pero no pueden ser iteradas.

```solidity
mapping(address => uint) public balances;

function deposit() public payable {
    balances[msg.sender] += msg.value; // Actualiza el saldo del remitente.
}
```
----------------------------------------------------
  
## Data Locations
El compilador de Solidity sabe manejar la memoria de los tipos primitivos. Sin embargo, para cadenas (strings), arrays, structs y mappings, es necesario especificar la ubicación de los datos. Solidity proporciona tres ubicaciones de datos: memory, calldata y storage.

**Memory (`memory`)** 

Se usa comúnmente para declarar variables temporales que pueden ser modificadas durante la ejecución.

```solidity
function concatenateAlias(string memory aliasName) internal pure returns (string memory) {
   return string(abi.encodePacked("@", aliasName));
}
```

**Calldata (`calldata`)**

Es inmutable y se utiliza para manejar parámetros de entrada en funciones. Es más eficiente en términos de gas, pero no se puede modificar.

```solidity
function printMessage(string calldata message) public pure returns (string memory) {
    return message;
}
```

**Storage (`storage`)**  
Es persistente y se usa para variables declaradas en el ámbito del contrato, las cuales, por defecto, se asignan implícitamente a storage.

```solidity
string public storedName;

function setName(string memory name) public {
    storedName = name;
}
```

----------------------------------------------------

## Modifiers
En Solidity, los modificadores son piezas de código reutilizables que se utilizan para alterar el comportamiento de las funciones de manera consistente y sencilla. Se colocan como etiquetas en las funciones y sirven para agregar restricciones o ejecutar lógica adicional antes o después de que se ejecute la lógica principal de la función.

### Pure
**Definición:** Una función marcada como `pure` no puede leer ni modificar el estado de la blockchain.

**Características:**
 - No interactúa con variables de estado (almacenadas en el contrato).
 - No lee información de la blockchain (como `block.timestamp` o `msg.sender`).
 - Solo puede operar con parámetros proporcionados o datos locales.

**Uso común:** Realizar cálculos o transformar datos.

```solidity
function add(uint a, uint b) public pure returns (uint) {
    return a + b;
}
```


### View
**Definición:** Una función marcada como `view` puede leer valores del estado de la blockchain pero no puede modificarlos.

**Características:**
 - No puede cambiar valores en el contrato.
 - Permite consultar variables de estado o información de la blockchain.
 - Se puede ejecutar sin consumir gas (si es llamada externamente).

**Uso común:** Consultar datos almacenados en el contrato.

```solidity
uint public myValue;

function getMyValue() public view returns (uint) {
    return myValue;
}
```


### Payable 
**Definición:** Una función marcada como `payable` permite recibir ether (o fondos en general) en el contrato.

**Características:**
 - Sin este modificador, una función no puede aceptar pagos.
 - Es necesaria para funciones que permiten transferencias de ether hacia el contrato.
   
**Uso común:** Recibir pagos o transferir fondos dentro de contratos.

```solidity 
  function deposit() public payable {
      require(msg.value > 0, "Debe enviar fondos mayores a 0"); // Asegura que se envíen fondos.
  }
```


### Immutable
**Definición:** Las variables marcadas como `immutable` se inicializan una sola vez (normalmente en el constructor) y no pueden cambiar después.

**Características:**
 - Se utiliza para optimizar variables que son constantes tras la inicialización.
 - Ofrece mayor flexibilidad que `constant`, ya que permite inicializar el valor en tiempo de ejecución (no solo en la declaración).

```solidity
uint public immutable startTime;

constructor() {
    startTime = block.timestamp; // Inicializado en el constructor.
}
```


### Anonymous
**Definición:** Se usa en eventos para hacerlos anónimos, eliminando su firma del registro de logs en la blockchain.

**Características:**
 - Hace que el evento sea más ligero (menos costoso en gas).
 - No se puede filtrar por el nombre del evento en los logs.

```solidity
event MyEvent(uint indexed value) anonymous;
```


### Indexed
**Definición:** Se utiliza en eventos para permitir que ciertos parámetros sean indexados y se puedan buscar en los logs de la blockchain.

**Características:**
 - Máximo 3 parámetros por evento pueden ser indexados.
 - Facilita la búsqueda de eventos en exploradores de blockchain.

```solidity
event MyEvent(uint indexed value, address indexed sender);

function emitEvent(uint value) public {
    emit MyEvent(value, msg.sender);
}
```


### Virtual
**Definición:** Permite que una función sea sobreescrita en contratos heredados.

**Características:**
 - Se utiliza en contratos base para funciones que deben ser personalizables.
 - Si una función no es `virtual`, no puede ser modificada.

```solidity
contract Base {
    function greet() public virtual returns (string memory) {
        return "Hello from Base!";
    }
}
```


### Override
**Definición:** Indica que una función sobrescribe una versión anterior definida en un contrato base.

**Características:**
 - Se usa junto con funciones `virtual`.
 - Es obligatorio especificar `override` para funciones que modifican otras heredadas.

```solidity
contract Derived is Base {
    function greet() public override returns (string memory) {
        return "Hello from Derived!";
    }
}
```
