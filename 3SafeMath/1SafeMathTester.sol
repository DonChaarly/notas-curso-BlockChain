// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/*
    Antes de la version 8 de solidity no se tenian tantas verificaciones en las variables numericas
    Por ejemplo: 
        Cuando se tiene un numero con valor de 255 que es el maximo y se le suma un 1
        en las versiones de solidity antes de la 8 lo que pasaria es que este numero haria un overflow y regresaria a 0
        En las versiones superiores a la 8 cuando pasa esto, la transaccion marca un error
        a menos que se le coloque un uncheck que seria rodear la operacion con unchecked { (operacoin) }
    
    Utilizar el unchecked ahorra gas, asi que si se esta completamente seguro que las operacoines no fallaran es buena idea utilizarlo

*/
contract SafeMathTester{
    uint8 public bigNumber = 255; // unchecked

    function add() public {
        bigNumber = bigNumber + 1;
    }
}