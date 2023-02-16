/*
  Ethers es una libreria que nos sirve para establecer la conexion con 
  alguna blockchain y establecer las wallets con las que se haran las transacciones
*/
const ethers = require("ethers");
/*
  Para hacer los deploy necesitamos los archivos .abi y .bin 
  Y para leer de estos dos archivos ocupamos la libreria fs-extra
*/
const fs = require("fs-extra");

async function main() {
  /*==================================== CONEXION A BLOCKCHAIN CON ETHERS ================================= */
  /*
    Cada blockchain tiene una ruta o URL de RPC en la que esta funcionando, para hacer una conexion a alguna blockchain se
    necesita esta ruta, 
      La siguiente ruta es en donde esta corriendo la blockchain que tenemos localmente con ganache:
           HTTP://127.0.0.1:7545
  */

  // Con ehters podemos establecer una conexion con un provedor con el metodo JSONRpcBatchProvider(), pasandole la URL de RPC
  const provider = new ethers.providers.JsonRpcBatchProvider(
    "http://127.0.0.1:7545"
  );
  /* 
    Con ethers podemos establecer una conexion con una billetera o wallet tambien con el metodo Wallet() 
    pasandole el adress de esta wallet y un provider
  */
  const wallet = new ethers.Wallet(
    "7e8a846c26b8a04393442e39f4e34d7a0faa55e578ebf2386ca5970bf3ed11ea",
    provider
  );

  /*========================================= DEPLOY DE CONTRATOS ============================================ */
  /*
    Para hacer el deploy de los contratos necesitamos los archivos .abi y .bin 
    para leer de estos archivos utilizamos fs.readFileSync(), se le pasa la ruta del archivo y el encode en el que estan
  */
  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );
  /*
    Finalmente para hacer el deploy de un contrato se crea un objeto llamado ContractFactory
    A este se le pasa el abi, el bin y la billetera
    Con este objeto podremos llamar la funcion deploy();
 */
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying, please wait...");
  /*
    En nuestro metodo deploy podemos dejar sin argumentos o agregar un objeto con porpiedades 
    como el limite de gas de la transaccion, el precio del gas, etc

  */
  const contract = await contractFactory.deploy();
  /*========================================== TRANSACTION RECEIPT ================================= */
  /*
    El metodo deployTransaction.wait() nos devuelve algo parecido al deloy pero este espera a que un bloque se ejecute
    y nos duelve informacion mas relacionada con si fallo o no
  */
  const transactionReceipt = await contract.deployTransaction.wait(1);
  console.log({ contract });
  console.log({ transactionReceipt });
  
  /*======================================== TRANSACCIONES EN CRUDO ================================ */
  /*
    Se pueden hacer transacciones simplemente definiendo los valores de las propiedades de la transaccion en un objeto
    nonce: numero unico que utiliza la transaccion
    gasPrice: Precio del en wei por unidad de gas
    gasLimit: Limite que puede gastar la transaccion en gas
    to: direccion de la cuenta a la que se va a mandar la transaccion
    value: 
    data: binario de nuestro contrato (.bin)
    chainId: cada EVM Chains ya sea goerli, ethereum, kovan, etc tiene un chain id, es  el que se tiene que colocar

    Ya que necesitamos saber el nonce correcto de la trasnaccion, lo podemos obtener con el metodo .getTransactioncount()
  */
  // const nonce = await wallet.getTransactionCount();
  // const tx = {
  //   nonce: nonce,
  //   gasPrice: 100000000000,
  //   gasLimit: 1000000,
  //   to: null,
  //   value: 0,
  //   data: "0x608060405234801561001057600080fd5b50610771806100206000396000f3fe608060405234801561001057600080fd5b50600436106100575760003560e01c80632e64cec11461005c5780636057361d1461007a5780636f760f41146100965780638bab8dd5146100b25780639e7a13ad146100e2575b600080fd5b610064610113565b604051610071919061035c565b60405180910390f35b610094600480360381019061008f91906103b7565b61011c565b005b6100b060048036038101906100ab919061052a565b610126565b005b6100cc60048036038101906100c79190610586565b6101b6565b6040516100d9919061035c565b60405180910390f35b6100fc60048036038101906100f791906103b7565b6101e4565b60405161010a929190610657565b60405180910390f35b60008054905090565b8060008190555050565b6001604051806040016040528083815260200184815250908060018154018082558091505060019003906000526020600020906002020160009091909190915060008201518160000155602082015181600101908051906020019061018c9291906102a0565b505050806002836040516101a091906106c3565b9081526020016040518091039020819055505050565b6002818051602081018201805184825260208301602085012081835280955050505050506000915090505481565b600181815481106101f457600080fd5b906000526020600020906002020160009150905080600001549080600101805461021d90610709565b80601f016020809104026020016040519081016040528092919081815260200182805461024990610709565b80156102965780601f1061026b57610100808354040283529160200191610296565b820191906000526020600020905b81548152906001019060200180831161027957829003601f168201915b5050505050905082565b8280546102ac90610709565b90600052602060002090601f0160209004810192826102ce5760008555610315565b82601f106102e757805160ff1916838001178555610315565b82800160010185558215610315579182015b828111156103145782518255916020019190600101906102f9565b5b5090506103229190610326565b5090565b5b8082111561033f576000816000905550600101610327565b5090565b6000819050919050565b61035681610343565b82525050565b6000602082019050610371600083018461034d565b92915050565b6000604051905090565b600080fd5b600080fd5b61039481610343565b811461039f57600080fd5b50565b6000813590506103b18161038b565b92915050565b6000602082840312156103cd576103cc610381565b5b60006103db848285016103a2565b91505092915050565b600080fd5b600080fd5b6000601f19601f8301169050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b610437826103ee565b810181811067ffffffffffffffff82111715610456576104556103ff565b5b80604052505050565b6000610469610377565b9050610475828261042e565b919050565b600067ffffffffffffffff821115610495576104946103ff565b5b61049e826103ee565b9050602081019050919050565b82818337600083830152505050565b60006104cd6104c88461047a565b61045f565b9050828152602081018484840111156104e9576104e86103e9565b5b6104f48482856104ab565b509392505050565b600082601f830112610511576105106103e4565b5b81356105218482602086016104ba565b91505092915050565b6000806040838503121561054157610540610381565b5b600083013567ffffffffffffffff81111561055f5761055e610386565b5b61056b858286016104fc565b925050602061057c858286016103a2565b9150509250929050565b60006020828403121561059c5761059b610381565b5b600082013567ffffffffffffffff8111156105ba576105b9610386565b5b6105c6848285016104fc565b91505092915050565b600081519050919050565b600082825260208201905092915050565b60005b838110156106095780820151818401526020810190506105ee565b83811115610618576000848401525b50505050565b6000610629826105cf565b61063381856105da565b93506106438185602086016105eb565b61064c816103ee565b840191505092915050565b600060408201905061066c600083018561034d565b818103602083015261067e818461061e565b90509392505050565b600081905092915050565b600061069d826105cf565b6106a78185610687565b93506106b78185602086016105eb565b80840191505092915050565b60006106cf8284610692565b915081905092915050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602260045260246000fd5b6000600282049050600182168061072157607f821691505b60208210811415610735576107346106da565b5b5091905056fea2646970667358221220ca0819476698c2f9c7ae9470d72ad13a8d1a180e4b7dbfa054fe8518cec716f964736f6c63430008080033",
  //   chainId: 1337,
  // };
  /* 
    Una vez que tenemos la informacion de la transaccion la firmamos y mandamos con el metodo sendTransaction
    tambien utilizamos .wait para esperar a la confirmacion de la transaccion    
  */
  // const sentTxResponse = await wallet.sendTransaction(tx);
  // await sentTxResponse.wait(1);
  // console.log({sentTxResponse})

  /*================================== UTILIZAR LAS FUNCIONES DE NUESTRO CONTRATO ===================================== */
  /*
    Para interactura con nuestro contrato como lo haciamos en remix con los botones de las funciones que teniamos
    utilizamos el objeto contrato que creamos, ahi tendremos los metoodos que tiene definido
  */
  const currentFavoriteNumber = await contract.retrieve();
  /*
    Ya que la siguiente funcion de nuestro contrato si hace modificaciones en los estados del contrato,
    es buena idea esperar por el transactionReceipt de la trasnaccion
    Nota: Es mejor mandar numeros como un string, ya que javascript a veces no puede manejar numeros grandes 
  */
  const transactionResponse = await contract.store("7");
  const transactionReceipt2 = await transactionResponse.wait(1);

  /*
    Nota: Al ejecutar este codigo veremos que ethers utiliza la clase BigNumber para manerjar los numberos de 18 digitos 
    que manejamos en los contratos, esto porque javascript no puede manjear por si solo numeros asi de grandes
  */
  console.log(`Current Favorite Number: ${currentFavoriteNumber}`)

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
