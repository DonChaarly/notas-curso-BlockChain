// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    /*
        Para obtener el precio del etherium en dolares utilizamos chainlink, en concreto los DataFeeds
        Estos dataFeeds nos pueden dar mucha informacion, hay que utlizar las funciones que necesitamos

        AggregatorV3Interface es de hecho un contrato el cual tiene las funciones que necesitamos
        Para acceder al contrato necesitamos el ABI y la direccion del contrato,
            esta direccion puede cambiar dependiendo de lo que necesitemos,
            aqui estan las direcciones disponibles: https://docs.chain.link/data-feeds/price-feeds/addresses
            
    */

    function getPrice() internal view returns (uint256) {
        /* 
            La direccion que elegimos nos da acceso a la conversion de goerli a dolares
            con esta tenemos obtenemos el contrato que nos da entre sus funciones la conversion
            Goerli ETH / USD Address
        
        */
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        /*
            La funcion latestRoundData nos devuelve una serie de variables, entre ellos el precio del Eth en dolares
            Podemos hacer una desestructuracion para obtener solo los datos que necesitamos, 
                dejando espacios vacios en las variables que no necesitamos
        */
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        /*
            Ahora tenemos el precio de ETH en terminos de dolares, para poder trabajar con el, 
            debemos hacer la multiplicacion para de esta forma obtener los 18 digitos que necesitamos
        */
        return uint256(answer * 10000000000);
    }

    /*
        Esta funcion va a recibir un value en eth y retornara la conversion en dolares de esta cantidad
    */
    function getConversionRate(uint256 ethAmount) internal view returns (uint256){
        /*
            Obtenemos el precio del etherium
            Hacemos la multiplicacion, y al tener ambos valores 18 digitos tendremos al final 36 digitos,
                por ello tenemos que hacer una division de 18 digitos para mantener el resultado con 18 digitos en vez de 36
            Finalmente retornamos la conversion
        */
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;

        return ethAmountInUsd;
    }
}