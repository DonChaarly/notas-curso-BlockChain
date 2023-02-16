const { task } = require("hardhat/config")

/*
  Las custom task son comandos como compile, run, etc, pero que nosotros vamos a poder crear y personalizar

  Utilizamos la funcion task para crear un nuevo task
  pasamos como parametro el nombre de nuestro task, como segundo parametro una breve descripcion de la task
  con el metodo .setAction especificamos el codigo que ejecutara y primer parametro tendra un callback
  el cual tendra los argumentos y el objeto hre el cual es lo mismo practicamente que el require('hardhat')
  con el cual podremos acceder a los objetos de la libreria, etc.
*/
task("block-number", "Prints the current block number").setAction(
  // const blockTask = async function() => {}
  // async function blockTask() {}
  async (taskArgs, hre) => {
    const blockNumber = await hre.ethers.provider.getBlockNumber()
    console.log(`Current block number: ${blockNumber}`)
  }
)

module.exports = {}
