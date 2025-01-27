# Solidity Basics

## Modifiers
En Solidity, los modificadores son piezas de código reutilizables que se utilizan para alterar el comportamiento de las funciones de manera consistente y sencilla. Se colocan como etiquetas en las funciones y sirven para agregar restricciones o ejecutar lógica adicional antes o después de que se ejecute la lógica principal de la función.

----------------------------------------------------

### Pure
**Definición:** Una función marcada como pure no puede leer ni modificar el estado de la blockchain.

**Características:**
 - No interactúa con variables de estado (almacenadas en el contrato).
 - No lee información de la blockchain (como block.timestamp o msg.sender).
 - Solo puede operar con parámetros proporcionados o datos locales.

**Uso común:** Realizar cálculos o transformar datos.

```solidity
function add(uint a, uint b) public pure returns (uint) {
    return a + b;
}
```
----------------------------------------------------

### View
**Definición:** Una función marcada como view puede leer valores del estado de la blockchain pero no puede modificarlos.

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
----------------------------------------------------

### Payable 
**Definición:** Una función marcada como payable permite recibir ether (o fondos en general) en el contrato.

**Características:**
 - Sin este modificador, una función no puede aceptar pagos.
 - Es necesaria para funciones que permiten transferencias de ether hacia el contrato.
   
**Uso común:** Recibir pagos o transferir fondos dentro de contratos.

```solidity 
  function deposit() public payable {
      require(msg.value > 0, "Debe enviar fondos mayores a 0"); // Asegura que se envíen fondos.
  }
```
----------------------------------------------------

### Immutable
**Definición:** Las variables marcadas como immutable se inicializan una sola vez (normalmente en el constructor) y no pueden cambiar después.

**Características:**
 - Se utiliza para optimizar variables que son constantes tras la inicialización.
 - Ofrece mayor flexibilidad que constant, ya que permite inicializar el valor en tiempo de ejecución (no solo en la declaración).

```solidity
uint public immutable startTime;

constructor() {
    startTime = block.timestamp; // Inicializado en el constructor.
}
```
----------------------------------------------------

### Anonymous
**Definición:** Se usa en eventos para hacerlos anónimos, eliminando su firma del registro de logs en la blockchain.

**Características:**
 - Hace que el evento sea más ligero (menos costoso en gas).
 - No se puede filtrar por el nombre del evento en los logs.

```solidity
event MyEvent(uint indexed value) anonymous;
```
----------------------------------------------------

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
----------------------------------------------------

### Virtual
**Definición:** Permite que una función sea sobreescrita en contratos heredados.

**Características:**
 - Se utiliza en contratos base para funciones que deben ser personalizables.
 - Si una función no es virtual, no puede ser modificada.

```solidity
contract Base {
    function greet() public virtual returns (string memory) {
        return "Hello from Base!";
    }
}
```

----------------------------------------------------


### Override
**Definición:** Indica que una función sobrescribe una versión anterior definida en un contrato base.

**Características:**
 - Se usa junto con funciones virtual.
 - Es obligatorio especificar override para funciones que modifican otras heredadas.

```solidity
contract Derived is Base {
    function greet() public override returns (string memory) {
        return "Hello from Derived!";
    }
}
```




