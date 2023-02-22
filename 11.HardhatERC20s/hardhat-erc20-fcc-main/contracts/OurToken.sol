// contracts/OurToken.sol
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
