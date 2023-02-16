/* 
  ========================================= IMPORTS ========================================================
  Se tiene que importar las siguientes librerias
  Y ya que agregamos la libreria: @nomiclabs/hardhat-ethers
  en vez de importar de require("ethers")
  es mejor importar de require("hardhat")
  cualquiera de las dos funcionara igual pero es mejor hardhat
*/
const { ethers, run, network } = require("hardhat")

async function main() {
  /* 
  =============================== CREACION DE CONTRACT FACTORY Y DESPLIEGUE =================================
    Con hardhat podemos directamente crear un contratctFactory 
    pasandole como parametro el nombre del contrato
    Para que getContractFactory pueda reconocer el contrato simplemente pasandole el nombre
    es necesario haber importado ethers de hardhat, ya que este sabe de la existencia de la carpeta contracts y ethers no
  
  */
  const SimpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
  console.log("Deploying contract...")
  /*
    Con el objeto SimpleStorageFactory podemos finalmente hacer el deploy del contrato
    llamando  al metodo deploy
  */
  const simpleStorage = await SimpleStorageFactory.deploy()
  await simpleStorage.deployed()
  console.log(`Deployed contract to: ${simpleStorage.address}`)

  // ================================== VERIFICACION DEL CONTRATO ==============================================
  // verificamos que no estamos haciendo el deploy en el network de hardhat ya que esto no tiene sentido y marcaria error
  if (network.config.chainId === 5 && process.env.ETHERSCAN_API_KEY) {
    console.log("Waiting for block confirmations...")
    //Esperamos seis bloques de la transaccion para asegurarnos de tener un adress
    await simpleStorage.deployTransaction.wait(6)
    // Finalmente llamamos a nuestra funcion verify y le pasamos el adress del contrato y los args
    await verify(simpleStorage.address, [])
  }


  /* ================================= INTERACCION CON NUESTRO CONTRATO =========================================
     
    Una vez echo el deploy de nuestro contrato podemos interactura con el y con sus metodos
  */
  const currentValue = await simpleStorage.retrieve()
  console.log(`Current Value is: ${currentValue}`)

  // Update the current value
  const transactionResponse = await simpleStorage.store(7)
  await transactionResponse.wait(1)
  const updatedValue = await simpleStorage.retrieve()
  console.log(`Updated Value is: ${updatedValue}`)
}

/*
  ================================== VERIFICACION DEL CONTRATO ==============================================

  Al hacer el deploy de un contrato a una network es necesario hacer una verificacion\
  Para hacer la verificacion necesitamos al menos el contratAdress
  Podemos tener args vacios pero algunos de nuestros contratos tendran contructores a los que les pasaremos argumentos
  asi que es bueno dejar esta propiedad en la funcion

  Para facilitar la verificacion de los contratos se puede utilizar la libreria de @nomiclabs/hardhat-etherscan
  Despues de hacer todas las configuraciones necesarias de ethers-scan

*/
const verify = async (contractAddress, args) => {
  console.log("Verifying contract...")
  try {
    /*
      Con la funcion run, podemos correr cualquier comando de hardhat directamente en el codigo

      como primer parametro colocamos el nombre del comando, adicionalmente tenemos que colocar que vamos a verificar, tenemos diferentes opciones
      Como segungo parametro colocamos el objeto de propiedades en donde especificaremos el adress del contrato y los argumentos
    */
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    })
  } catch (e) {
    /*
      Si el contrato ya esta verificado entrara al catch
    */
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already Verified!")
    } else {
      console.log(e)
    }
  }
}

// main
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
