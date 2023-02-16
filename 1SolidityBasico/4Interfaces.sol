// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Las interfaces en solidity se manejan igual que otro lenguaje
    Una interface se utiliza para declarar funciones y variables que pueden ser heredadas
    Pero no se tiene una implementacion para estas funciones, estas se quedan abstractas

    Para declarar una clase como interface se antepone la palabra interface antes del nombre de la clase
*/


interface AggregatorV3Interface {
    /*
        Se declaran las funciones con normalidad pero no se les coloca una implementacion
    */
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

    /*
        Se puede agregar una implementacion tambien si asi se desea
    */
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}