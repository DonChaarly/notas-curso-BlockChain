// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/*
    Las librerias son similares a los contratos, pero en las librerias 
        no se pueden declarar variables de estado ni mandar ehter
    Algo interesante de las librerias es que si delcaramos todas sus funciones como internal
        estas funciones estaran embebidas en el contrato en el que la importemos
        por ejemplo, en vez de utilizar una funcion asi...:
            getConversionRate(msg.value);
        Se podra utilizar de la siguiente forma:
            msg.value.getConversionRate();
        
        Con esto la libreria no necesitara ser deployada antes de que se utilice en el contrato
        al estar embebida esto se hara automaticamente
    
    Para utilizar una libreria dentro un contrato a parte de hacer el import
        import "./5Libreria.sol";
    Tambien se debe colocar dentro del contrato la palabra reservada usign seguido del nombre de la libreria, seguido de for y los valores que regresaran sus funciones
        using 5Liberria for uint256;


*/

library PriceConverter {

    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }


    /*
        Al llamar esta funcion como sigue
            msg.value.getConversionRate()
        No se pasa un parametro a la funcion ya que tomara lo que esta antes de la llamada a la funcion como primer parametro
        Si tuvieramos un segundo parametro en la definicion de la funcion, ahi si seria necesari especificar el segundo parametro dentro de los parentesis
    */
    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;

        return ethAmountInUsd;
    }
}