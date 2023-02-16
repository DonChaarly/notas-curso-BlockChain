# HardHat

Hardhat es un framework el cual nos facilita el desarrollo de smart contract\
asi como express con node\
nos facilita la conexion a testnet y demas cosas\


## Crear un nuevo proyecto con hardhat

Siempre es bueno hechar un vistazo a la documentacion oficial de hardhat:\ 
https://hardhat.org/tutorial/setting-up-the-environment\

Los comandos a ejecutar para crear un nuevo proyecto e instalar hardhat:

```
npm init
npm install --save-dev hardhat
```

Para correr el proyecto:

```
npx hardhat
```

## Comando utilies que nos facilitan la vida con hardhat

* npx hardhat accounts: nos muestra la lista de cuentas falsas que tenemos para hacer pruebas
* npx hardhat complie: Para compilar nuestros contratos
* npx hardhat run: para correr nuestrso scripts


## Compilar un contrato

Para compilar un contrato se utiliza el comando:
```
npx hardhat compile
```
Esto creara una carpeta llamada artifacts en done se crearan los contratos 


## Archivo para deployar un contrato

Este archivo cuenta con las partes principales
* **imports**: todos las librerias que necesitamos importar de
* **Funcion principal asincrona**: sera la encargada de llamar a las funciones principales de ethers y desplegar el contrato
* **Llamada a la funcion**: finalmente al final del archivo se llama a la funcion asincrona con el then y catch


## Networks

Para hacer el deploy de un contrato, este tiene que estar conectada a una network de ethereum o alguna otra blockchain\
A la hora de ejecutar un archivo de deploy se hace mediante el siguiente comando:
```
npx hardhat run (nombre del script)
```
El comando anterior hara el deploy en el network por defautl que tengamos especificado en hardhat.config.js
Para especificar un network se utiliza el siguiente comando:
```
npx hardhat run (nombre del script) --network (nombre del network)
```

### Hardhat network (para desarrollo)

Hardhat tiene un network incluido de ethereum disenado para desarrollo\
el cual viene ya con rpc url y un private key preconfigurado\
esto nos permite correr test y debugear nuestro codigo\
Si no se tiene especificado ningun rcp de algun network en el module.exports del archivo hardhat.config.js\
se utilizara el network por defecto de hardhat\
Podemos especificar explicitamente el network de hardhat con la siguiente propiedad:
```javascript
module.exports = {
  ...
  defaultNetwork: "hardhat",
  ...
}
```

### Configurar network

Para definir algun network con su rcp url y su private key, esto se hace desde el archivo hardhat.config.js\
Se debe especificar el nombre del network y dentro como un objeto el url(rcp url), accounts(private key), y el chainId del network
```javascript
module.exports = {
  ...
  networks: {
    hardhat: {},
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
    },
    localhost: {
      url: "http://localhost:8545",
      chainId: 31337,
    },
  },
  ...
}
```

## Verificacion de contratos de manera programatica

Al hacer el deploy de un contrato a una network es necesario hacer una verificacion\
Para hacer la verificacion necesitamos al menos el contratAdress/
Podemos tener args vacios pero algunos de nuestros contratos tendran contructores a los que les pasaremos argumentos\
asi que es bueno dejar esta propiedad en la funcion

Para facilitar la verificacion de los contratos se puede utilizar la libreria de @nomiclabs/hardhat-etherscan
```
npm i @nomiclabs/hardhat-etherscan
```

Necesitamos crear una cuenta en ethersScan tambien: https://etherscan.io/login

Y necesitamos crear una API KEY: este proceso esta en el minuto 8:55:00 del curso: https://www.youtube.com/watch?v=gyMwXuJrbJQ&t=27827s

Tenemos que agregar la configuracon de etherscan a nuestro archivo hardhat.config.js:
```javascript
module.exports = {
  ....
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  ...
}

```

### Verificacion con comando verify

Ya que tenemos configurada nuestra etherscan, con el comando verify podemos correr la verificacion del contrato:
```
npx hardhat verify --network (nombre del network) DEPLOYED_CONTRACT_ADDRESS "(address del contrato)"
```

### Verificacion de forma programatica

Podemos crera una funcion en nuestro archivo deploy que al hacer un deploy haga la verificacion automaticamente\
con el objeto run de ehters podemos correr cualquier comando de hardhat directamente en el codigo



## Errores que pueden aparecer al compilar contrtatos

* Error HH606: The project cannot be compiled\ the solidity version pragma statement in these files doesn't mathc any of the conifg ured compilers in you config...
  * Para solucionar esto se necesita  establecer un compildador que coincida con las versiones del contrato, esto se puede configurar en el archivo hardhat.config.js
```javascript
module.exports = {
  ...
  solidity: "0.8.8",
  ...
}
  ```

* Error: ENOENT: no such file or directory, open '/Users/..../artifacts/'....
  * Puede ser que el contrato no se haya compilado correctamente, hay que eliminar la carpeta artifacts y la carpeta cache
  * y vamos a correr nuevamente run

## Custom task

Las custom task son comandos como compile, run, etc, pero que nosotros vamos a poder crear y personalizar

Para esto creamos una carpeta task en donde se alojaran nuestros task

## Hardhat network node (en nuestra terminal)

Si corremos el comando:
```
npx hardhat node
```
Tendremos en nuestra consola un network como lo teniamos en ganache, se nos mostraran las cuentas y privateKeys de estas cuentas de prueba\
Tambien nos mostrara el rcp del localhost en donde esta corriendo\
Para correr nuestros contratos en alguna de estas networks tendremos que especificarla en el archivo hardhat.config.js como lo hacemos con cualquier otra network externa\
```javascript
module.exports = {
  ....
  networks: {
    ...
    localhost: {
      url: "http://localhost:8545",
      chainId: 31337,
    },
  },
  ....
}
```
Nota: no es necesario colocar las cuentas, ya que hardhat tiene diez cuentas falsas preestablecidas.

## Test con hardhat

Para evitar vulnerabilidades en nuestros contratos la mejor forma es hacer pruebas de nuestros metodos,
hardhat tiene la libreria MOCHA Framework la cual ya viene incluida en hardhat,

Como buena practica se crea una carpeta test en donde se almacenan los scripts de nuestros test

Para crear un test se utiliza el metodo describe, se le pasa como parametro el nombre del test y como segundo parametro un callback
```javascript
describe("SimpleStorage", function () {
    beforeEach();

    it();
    it();
})
```
con la funcion `beforeEach()` obtenemos los objetos necesarios para correr las pruebas y que utilizaremos en los bloques it\
con la funcion `it()`, se especifica lo que se espera que se obtenga\

para correr las pruebas se utiliza el comando:
```
npx hardhat test
```
Para correr una prueba en especifico, se coloca --grep y alguna parte de la descripcion que tenga la prueba para que la encuentre
```
npx hardhat test --grep (descripcion completa o parcial)
```

### Test del gas utilizado

Para probar el gas utilizado en las transacciones podemos utilizar la libreria hardhat-gas-reporter\
para instalarlo
```
npm i hardhat-gas-reporter --dev
```

Es necesario configurar el gasReporter en el archivo hardhat.config.js:
Se importa la libreria de gasReporter
```javascript
require("hardhat-gas-reporter")

```
Y se agrega la configuracoin al module.exports
```javascript
module.exports = {
  ....
  gasReporter: {
    enabled: true,
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    coinmarketcap: COINMARKETCAP_API_KEY,
  },
}
```
El unico parametro obligatorio es **enabled**\, los demas son opcionales:
* currency: para  
* outputFile: desborda la informacion en el archivo que indiques
* noColors: Se agrega porque podemos tener problemas con los colores en el archivo donde desbordamos
* currency: obtenemos el valor del gas en la moneda que especifiquemos
* coinmarketcap: tenemos que colocar esto si especificamos un currency
  * Para esto necesitamos colocar un api key de la pagin coinMarketCap, necesitamos tener una cuenta y crear esta api key: https://coinmarketcap.com/


Al hacer las pruebas con `npx hardhat test`, veremos una tabla con informacion sobre el gas




