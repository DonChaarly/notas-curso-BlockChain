// SPDX-License-Identifier: MIT 

// Es importante asegurarse que las versiones de solidity sean compatibles en los diferentes contratos que utilicemos
pragma solidity ^0.8.7;

// Para hacer uso de un contrato externo se tiene que hacer la importacion
import "./1SimpleStorage.sol"; 
//Tambien se pueden hacer importaciones de github o npm
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract StorageFactory {

    // Se puede crear una instancia de un contrato igual que se hace con una variable
    SimpleStorage simpleStorageExample = new SimpleStorage();

    // Incluso se pueden hacer arrays de un contrato
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        //se agregan contratos al array de contratos con un push con normalidad
        simpleStorageArray.push(simpleStorage);
    }

    // se pueden utilizar los metodos definidos en el contrato importado
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}