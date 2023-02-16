// SPDX-License-Identifier: MIT

/* 
    Este contrato se encargara principalmanete de que un cliente 
    pueda enviar etherium u otra moneda a este contrato y alguien mas que le 
    pertenezca el contrato pueda retirar este dinero cuando quiera
*/

/*
    Cosas a entender

    Todo contrato tiene los siguientes campos siempre que se hace una transaccion
    Nonce: es la llave que se genera al hacer la transaccion y sirve para verificar el hash de la transaccion
    Gas Price: Es el precio por unidad de gas (en wei)
    Gas Limit: Maximo gas que la transaccion puede utilizar
    To: direccion de la cartera a la que se enviara la transaccion
    Value: cantidad de wei que se enviara
    Data: Alguna informacion que se enviara a la direccion
    v, r, s: comonentes de la firma de la transaccion

    Debido a que se trabaja descentralizadamente, no se puede obtener datos del exterior
    tan facilmente, para eso se utilizan herramientas como chainlink
    La cual nos brinda cosas como los DataFeeds, VRF, chainlink keepers o Chainlink ANY API
    ChainLink: Es una teconologia capaz de brindarnos informacion del exterior y ejecutar
                funciones en un contexto descentralizado para nuestros smart contracts 
    DataFeeds: Son formas de leer informacion de precios o cualquier otro tipo del mundo real
               que ya esta concensada y descentralizada para que nosotros la podamos utilizar en nuestros smart contracts
    VRF: Es una forma de obtener numeros aleatorios de probabilidad del mundo real para nuestros smart contracts
    Chainlink Keepers: Chainlink Keepers son una forma de realizar eventos descentralizados
    Chainlink ANY API`s: Nos permite conectar con cualquier cosa fuera mediante peticiones como cualquier otra api

    Hay tres formas diferentes de retirar los fondos que se hayan metido a este contrato
    tranfer: Es la forma mas simple de hacerlo, en caso de fallar retornara un error
    send: Esta funcion es similar a tranfer pero en caso de fallar retornara un boolean
    call: Esta funcion es mas poderosa debido a que podemos mandar a llamar cualquier funcion de etherium sin siquiera tener un ABI


*/

pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./2PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public /* immutable */ i_owner;
    // Se puede hacer constante una variable agregando la palabra constant
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;
    
    //Haciendo uso del contructor estamos seteando la variable ownew con la direccion de la persona que haya hecho el deploy de este contrato
    constructor() {
        i_owner = msg.sender;
    }

    /* 
        fund sera la funcion principal del contrato y permitira al cliente enviar cryptos al contrato
        Para indicar que una funcion puede recibir alguna crypto se coloca la palabra payable
     
     */
    function fund() public payable {

        /* 
            Con msg.value podemos acceder al VALUE que se indica al hacer la transaccion
            require() evaluea le expresion mandada y en caso de no ser cierta se manda el mensaje y se revierten los cambios hecho antes
        */
        /*
            La funcion getConversionRate nos devuelve la conversion del valor del etherium en dolares considerando los decimales
            Esta funcion se encuentra en 2Priceconverter.sol
        */
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");

        /*
            Con msg.sender podemos recuperar la direccion de la persona que haya hecho la transaccion
            Podemos guardar esta informacion en un mapa o un array para mantener rastreadas las transacciones que se hacen a nuestro contrato
        */
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    /* Esta funcion solo devuelve la version del contrato Aggregator no hace nada mas, mas informacion sobre esta funcion en 2PriceConverter.sol*/
    function getVersion() public view returns (uint256){
        // ETH/USD price feed address of Goerli Network.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }
    

    /*
        Este modificador nos ayudara  a verificar que el que llama a la funcion es el dueno
    */
    modifier onlyOwner {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    /*
        La funcion withdraw nos permitira retirar el ehterium u cualquier otra moneda que los inversionistas hayan metido a este contrato
    */
    function withdraw() public onlyOwner {
        //El siguiente codigo es solo para resetaar los valores de los inversionistas en nuestro array y mapa
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        /*
            Se tiene tres formas para retirar los fondos que tenga este contrato
            
            Transfer: Es la forma mas simple de hacerlo, se tiene la funcion
                            msg.sender.transfer()
                      Antes de esto se tiene que hacer un cast al sender para tener un address payable de la siguiente forma
                            payable(msg.sender)
                      Ahora si podemos utilizar la funcion transfer

                      Como primer argumento toma el balance o saldo que se va a transferir del contrato al sender
                      En caso de fallar la transaccion, la funcion retornara un throw error y revertira la transaccion

        */
        // payable(msg.sender).transfer(address(this).balance);

        /*
            send: es muy similiar a tranfer, se llama igual que transfer
                  La unica diferencia es que en caso de fallar la transaccion, la funcion retornara un bool
                  pero no revertira la transaccion y no retornara el dinero
                  Para esto el resultado de la funcion se guarda en un bool y con un require se revierte la transaccion en caso de fallar

        */
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        /*
            call: Esta funcion es mas poderosa debido a que podemos mandar a llamar cualquier funcion de etherium sin siquiera tener un ABI
                  Se coloca entre llaves el value que sera la cantidad de eth que mandaremos
                  La funcion regresa dos variables, la que nos interesa es el booleano que indica si fallo la transaccion
                  pero tambien regresa informacion sobre la transaccion
                  Al fallar se tiene que hacer lo mismo que con send
        */
        // call
        (bool callSuccess, bytes dataReturned) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    /*
        Establecemos las fallback y receive function para que en caso de que se ejeucte una transaccoin
        sin llamas explicitamente la funcion found
        esta se ejecute de todos modos
    */

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly