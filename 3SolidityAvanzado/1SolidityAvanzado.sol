//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Cuando se mejora la calidad de codigo de nuestros contratos y se hacen mas eficientes
    podemos ahorrarnos una cantiad importante de gas para hacer nuestras transacciones
*/


//////////////////////////////// CUSTOM ERRORS //////////////////////////////////////
/*
    En vez utilizar require para evaluar condiciones y que revierta la transaccion
    se puede utilizar un if para evaluar la condicion y si no pasa ejecutamos un revert con el 
    custom error que especifiquemos

    Los custom error se definen fuera del bloque de contrato

*/

error NotOwner();

contract SolidityAvanzado{

    modifier onlyOwner {
        if(msg.sender != i_owner) { revert NotOwner();}
    }

    ////////////////////////////// CONSTANTS & IMMUTABLE //////////////////////////

    /*
        Las variables que son constantes una vez definido su valor no pueden ser cambiadas
            para hacer constante una variable se le agrega la palabra reservada constant
            Las variables constantes normalmente se nombran en mayusculas
        
        Las variables que son inmutables o immutable son variables que son definidas sin valor
        y una vez asignado un valor no vuelven a cambiar
            para hacer immutable una variable se le agrega la palabra reservada immutable
            Las variables immutable normalmente se les agrega una i_ al principio del nombre
    */

    uint256 public constant PRECIO_MINIMO = 50;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    ///////////////////////////// RECEIVE & FALLBACK /////////////////////////////////

    /*
        Se podria dar el caso en que un usuario mande monedas al contrato sin utilizar los metodos 
        especializados que definimos para esto
        
        Para asegurarnos de que se utilice alguna funcion en especifico al hacer una transaccion
        se utiliza receive o fallback

        receive se ejecuta cada vez que se hace una transaccion y no se coloca nada de data en
        el calldata

        fallback se ejecuta cada vez que se hace una transaccion y se coloca alguna informacion
        en el calldata 
    */
    uint256 public result;

    receive() external payable{
        result = 1;
    }

    fallback() external payable{
        result = 2;
    }





}