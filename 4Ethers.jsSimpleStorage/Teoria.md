# Ethers y Simple Storage

## Diferencias de trabajar en remix y en visual Studio o local

En Remix para compliar un contrato simplemente nos ibamos a la seccion de compilacion y oprimiamos un boton\
En visual studio para compilar nuestro contrato utilizamos la terminar\
Podemos correr el siguiente comando ya sea en npm o yarn

```
"yarn solcjs --bin --abi --include-path node_modules/ --base-path . -o . 1SimpleStorage.sol"
```

en vez de utilizar este comando cada vez que compilemos los contratos lo podemos agregar a los scripts
```
"scripts": {
    ...
    "compile": "yarn solcjs --bin --abi --include-path node_modules/ --base-path . -o . 1SimpleStorage.sol"
}
```
Esto nos creara un archivo .abi y otro .bin los cuales necesitamos para hacer el deploy de nuestros contratos

En remix para hacer el deploy de un contrato se hace la conexion con un blockchain ya sea uno de prueba como el que tenia remix o una conexion real con meteamask on Injected Provider\
En remix se hacia el deploy simplemente con un boton y seleccionando el enviroment, este hacia lo necesario para establecer estas conexiones\
Para hacer esto en nuestros archivos es necesario utilizar Ehters u otra libreria que nos ayude a esto\

## Ethers

Ethers es una libreria que nos sirve para establecer la conexion con alguna blockchain y establecer las wallets con las que se haran las transacciones

Con ethes finalmente podemos hacer un deploy de nuestros contratos, el codigo basico para lograr esto es el siguiente
```javascript
async function main() {
  const provider = new ethers.providers.JsonRpcBatchProvider(
    "http://127.0.0.1:7545"
  );
  const wallet = new ethers.Wallet(
    "8f3aa3aa2c683abf58effeb970b93ed057586e5876034496c0c852f4b43f271f",
    provider
  );

  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying, please wait...");
  const contract = await contractFactory.deploy();
  console.log(contract);
}
```



