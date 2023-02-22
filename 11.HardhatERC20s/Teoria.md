# Tokens ERC20

## Ethereum Improvement Proposals (EIPs)

Los EIP son ideas que la comunidad puede tener para mejorar los protocolos en ethereum, las personas vendrian al repositorio de github de ethereum y presentrian estas mejoras,\
Estas mejoras pueden ser desde una actualizacion a la blockchain a un nuevo estandar hasta una nueva practica para la comunidad para adoptar

## Ethereum Request for Comments (ERC)

Cuando se tiene un EIP que sea importante, se crea un ERC el cual sera tambien propuestas generadas por la comunidad o los desarrolladores de Ethereum con el fin de impulsar la blockchain

## ERC-20

ERC-20 es el estandar mas utilizado y con mayor relevancia debido a su gran interoperabilidad en el entorno.

Los ERC-20s son tokens que son desplegados en una blockchain utilizando el ERC-20 estandar\
**Basicamente es un smart contract que representa un token**

## Como crear un ERC-20 Token

Para crear un ERC-20 realmente solo se tiene que crear un smart contract utilizando el estandar del ERC-20 

Para facilitar la creacion de ERC-20s utilizamos la libreria de OPENZEPPELIN: https://docs.openzeppelin.com/contracts/4.x/erc20-supply

El codigo del contrato deberia verse como sigue:
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Para facilitar la creacion de ERC-20s utilizamos la libreria de OPENZEPPELIN
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//Se crea un contrato utilizando la interface ERC20
contract OurToken is ERC20 {

  //Se debe especificar un constructor pasando como parametros el nombre de nuestro token y su identificador
  constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
    //Finalmente la canitdad de wei que se minteara en la creacion del token
    _mint(msg.sender, initialSupply);
  }
}
```


