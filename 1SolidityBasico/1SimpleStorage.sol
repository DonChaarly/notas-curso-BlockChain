//SPDX-License-Identifier: MIT

//  Siempre se tiene primero la version de silidity que se esta utilizando
pragma solidity ^0.8.0;

//    Se coloca la palabra reservada contract par definir un nuevo contrato
//    viene siendo como la palabra class en javascript
contract SimpleStorage {

    //////////////////////////// CONSTRUCTOR ///////////////////////////////////

    /*
        Un constructor en solidity funciona igual que en cualquier otro lenguaje
        Pero debido a que los contratos son deployados una vez y no pueden ser modificados,
        los constructores ejecutaran codigo que solo sera ejecutado una unica vez durante la vida del contrato

    */
    address public owner;
    constructor(){
        // Con esto estamos seteando la variable owner con la direccion de la persona que este haciendo el deploy de este contrato
        owner = msg.sender;
    }

    /////////////////////////// TIPOS DE DATOS EN SOLIDITY  ////////////////////
    /*
    boolean: Boleano como siempre
    uint: para numeros pero sin signo
    int: para numero con signo
         Para uint y int se puede especificar el tamano del entero colocando un numero despues
         puede ir de 8 bits a 256, ejemplo: int8
    address: Tipo especial de solidity para especificar direcciones de cartera
    bytes: lo que vendria siendo un String
    string: string como siempre
    */

    bool hasFavoriteNumber = true;
    uint favoriteNumber = 123;
    int favoriteNumberWhitSign = -123;
    string favoriteNumberInText = "123";
    address myAddress = 0x201eFF2f6A945ed49853E4A6cFF6c031caE76AeB;
    bytes favoriteBytes = "cat";
    // Si no se espcifica un valor a una variable se le da automaticamente un valor por fedault com 0 o ""
    uint enteroSinValor;


    ///////////////////////////// ESTRUCTURAS U OBJETOS ///////////////////////////////////////

    /*  Existen tambien las estrucutras en solidity que seria los objetos en javascript
        algo intersante es que las propiedades de una estructura tendran siempre un index como si fueran un array
    */
    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // Ahora se pueden crear variables de la estructura creada anteriormente
    People public person = People({favoriteNumber: 2, name: "carlos" });
    People public person2 = People(2, "carlos");
    
    /////////////////////////// ARRAYS EN SOLIDITY /////////////////////////////////////////

    /* Para crear un array se coloca unos corchetes [] despues de tipo de dato
       Dentro de los corchetes se coloca el tamano del array, si no se coloca tamano, este puede ser de cualquier tamano
    */
    int[] public arrayNumeros; 
    /*
        Tambien se puede crear un array de cierto tamano con valores vacios
        En este caso inicializamos un array con 4 elementos
    */
    int[] public arrayVacio = new int[](4);


    function agregarNumero() public{
        //Para agregar un nuevo elemento a un array se utiliza la funcion push
        arrayNumeros.push(1);
        /*
            Podemos resetear un array de la siguiente forma
        */
        arrayVacio = new int[](0);
    }

    ////////////////////////// MAPPING ///////////////////////////////////////////////////

    /*
    Se tiene variables tipo map en solidity
    Se especifica el tipo de dato de la llave y el tipo de dato del valor
    */
    mapping(string => uint256) public nameToFavoriteNumber;
    
    function agregarAArray(string memory _name, uint256 _favoriteNumber) public {
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

     ////////////////////////// FUNCIONES EN SOLIDITY  ////////////////////////////////////
    /*
    Las funciones:
    Se les coloca la palabra reservada function seguido del nombre de la funcion
    Entre parentesis se delcaran los parametros 
    se coloca el modificador de acceso a la funcion, publico o privado
    */
    function store(uint _enteroPublico) public virtual{
        enteroPublico = _enteroPublico;
    }

    // Entre mas cosas haga una funcion mas gas utilizara para ser ejecutada
    function storeHeavy(uint _enteroPublico) public returns(int8){
        enteroPublico = _enteroPublico;
        enteroPublico = enteroPublico + 1;
        /*
         Las variables solo pueden ser accedidas dentro del alcance en el que fueron delcaradas
        Las vairables fuera de una funcion pueden ser accedidas dentro de cualquier funcion
        pero las variables declaradas dentro de una funcion solo pueden ser accedidas dentro de ese bloque
        */
        int8 variableDeBloque = 1;
        // Para retornar algun valor se coloca la palabra return, tambien se tiene que colocar en la definicion de la funcion
        return variableDeBloque;
    }

    /*
         Las funciones que tiene view o pure no gastaran nada de gas porque estas 
        solo leeran el estado del contrato
        Solo se gastara gas por estas funciones si estas son llamadas dentro de una funcion que si gaste gas
    */
    /*   View deshabilitar cualquier modificacion del estado del contrato*/
    function retrieve() public view returns(uint){
        return enteroPublico;
    }
    /*   Pure aparte de lo anterior deshabilita la lectura del estado */
    function add() public pure returns(uint256){
        return 1+1;
    }
     

    //////////////////////////  MODIFICADORES DE ACCESO //////////////////////////////////

    /*
    Los modificadores permitiran ver o no algunas variables o funciones
    Estos modificadores son:
    public: visible internamente y externamente
    private: Solo visible en el contrato actual
    external: solo visible externamente (solo para funciones)
    internal: Solo visible internamente

    Si no se especifica una visibilidad se coloca internal automaticamente
    */

    uint public enteroPublico;

    ////////////////////////// FORMAS DE GUARDAR INFORMACION EN LOS CONTRATOS ////////////

    /*
    Se tiene diversas formas de guardar informacion
    Stack:
    Memory: La informacion existira solo temporalmente durante la transaccion
            El valor de estas variables puede ser cambiado
    Storage: La informacion existira incluso fuera de la ejecucion de la funcion
            El valor de estas variables puede ser cambiado 
    Calldata: La informacion existira solo temporalmente durante la transaccion
            El valor de estas variables no puede ser cambiado
    Code:
    Logs:

    Estos modificadores se colocan solo a variables en funciones que sean array, struct, string o mapping
    */

    function cambiarNumberText(string memory _favoriteNumberInText) public{
        favoriteNumberInText = _favoriteNumberInText;
    }

    ////////////////////////////// FOR ///////////////////////////////////////
    /*
    El for es muy parecido a javascript o java
    */

    function functionFor() public{
        for (uint256 index=0; index < arrayNumeros.length; index++){
            //codigo a ejecutar dentro del for
            int256 numero = arrayNumeros[index];
        }
    }

    //////////////////////////// MODIFIERS ////////////////////////////////

    /*
        Los modificadores nos sirven para establecer condiciones a las 
        funciones que tenemos dentro de nuestro contrato
        
        Para crear un modificador se coloca la palabra reservada modifier seguido del nombre del modificador
        y dentro de los corchetes la condicion que evaluara
        Al final de las condiciones se coloca un _;
            este simbolo representa el resto del codigo de la funcion,
            podemos colocarlo al principio o al final de las condiciones

        Para utilizar este modificador, se tiene que colocar en la definicion de las funciones
        en las que queramos aplicacrlos
            por ejemplo:
            function functionFor() public onlyOwner {
                ...
            }

    */

    modifier onlyOwner {
        require(msg.sender == owner, "El mensajero no es el dueno");
        _;
    }
     
}