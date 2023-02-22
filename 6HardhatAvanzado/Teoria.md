# Full Stack contratos

## Linting con Solhint

Linting es el proceso de deteccion de posibles errores y mejoramiento de codigo\
Solhint es una libreria que nos ayuda a hacer el lint de nuestros archivos solidity\

Para correr solhint en nuestros contratos se utiliza el siguiente comando:
```
npx solhint contracts/*.sol
```

## Hardhat-deploy

Hardhat-deploy package es un paquete que nos sirve para facilitar el trabajo de deployar contratos y testearlos\
En vez de crear un script con codigo para deployar un contrato, utilizaremos esta libreria\
Para instalarla se utiliza el siguiente comando:
```
npm install --dev hardhat-deploy
```

### Configuracion inicial

En el archivo hardhat.config.js se tiene que agregar la siguiente importacion:
```javascript
require("hardhat-deploy")
```
Al correr el comando `npx hardhat` se hara el deploy directamente de nuestro contrato, con las funciones que tengamos\
dentro de los scripts de deploy en la carpeta deploy

Creacion de carpeta deploy\
En esta carpeta tendremos diferentes mock de deploys
Para crear estos script de deploy de contratos necesitamos instalar una libreria:
```
npm install --save-dev @nomiclabs/hardhat-ethers@npm:hardhat-deploy-ethers ethers
```
Dentro de la carpeta deploy se tendran los scripts de deployado de contratos\
Se puede tener mas de uno, es buena practica enumerarlos de la forma en la que se tiene que hacer el deploy\