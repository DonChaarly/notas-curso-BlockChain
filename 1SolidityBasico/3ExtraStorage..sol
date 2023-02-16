// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./1SimpleStorage.sol";

// En solidity tambien se puede manejar la herencia
// Para indicar que se hereda de un contrato se coloca la palabra is seguida del nombre del contrato a heredar
// Al heredar de un contrato se tendran todos los metodos y variables del contrato padre
contract ExtraStorage is SimpleStorage {

    //Se puede sobreescribir una funcion del contrato padre colocando la palabra override en la definicion de la funcion
    // Tambien es necesario colocar la palabra virtual en la definicion de la funcion original en la clase padre
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber + 5;
    }
}