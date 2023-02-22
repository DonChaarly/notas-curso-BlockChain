# Front End para interactuar con nuestros contratos

Cuado se trabaja con aplicaciones normalmente se tiene dos repositorios 
* Uno para los smart contracts
* Uno para el front end / website

## Funcionamiento general de un website con web3 wallets

Las web3 wallets son aplicaciones como metamask que nos ayudan a conectar nuestras wallets con nuestro proyecto
Nos ayudan a tener una conexion con la blockchain

El funcionamiento general que tendra el frontEnd con las webWallets sera el siguiente:
* Se tendra un boton que conectara a la wallet con nuestra aplicacion
* El boton abrira la web3Wallet como metamask
* Se concedera el permiso desde metamask para conectar a la aplicacion
* Se tendran otros botones que ejecutaran funciones del contrato y necesitaran de metamask para confirmar las transacciones

Para utilizar las web3Wallets es necesario que se tengan instaladas estas aplicacines en el navegador que se este utilizando\
Cuando se tiene instaladas estas extenciones, se tendran instancias se podran encontrar en el objeto window\
Se podra acceder a estas con `window.ethereum` para metamask

## Conexion de metamask con nuestro proyecto

Como dijimos al tener instalado metamask en nuestro navegador tendremos en el objeto window\
una instancia de metamask que nos servira para conectarnos a la wallet del cliente y realizar transaccinoes\

Para conectarnos a metamask se utiliza el siguiente metodo: 

```javascript
await ethereum.request({ method: "eth_requestAccounts" })
```
al ejecutar esta linea de codigo se nos abrira automaticamente metamask si es que no estamos conectados\
y nos pedira que establezcamos la conexion

## Mandar transacciones desde el frontEnd

Una vez que tenemos metamask conectado a la blockchain por nosotros, ahora es mas sencillo interactura con nuestro contrato\

Para interactuar con nuestro contrato ya desplegado, el cual se encuentra ya en la blockchain se necesitan algunas cuentas cosas:
* provider: Este provider nos lo dara alguna web3wallet como metamask y es el que estara conectada a la blockchain
* signer: sera la persona que estara conectada con metamask en el navegador
* wallet: sera la wallet del signer
* contract: Sera el contrato con el que estaremos interactuando
  * Para establecer conexino con el contrato se necesitan: El ABI y el Address del contrato