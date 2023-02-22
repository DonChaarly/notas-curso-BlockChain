/*
  Para trabajar con ethers es necesario instalar la libreria con npm
  Pero una mejor practica crear un archivo llamado ethers-5.6.esm.min.js y ahi copiar
  el codigo de ethers que nos brindan: https://cdn.ethers.io/lib/ethers-5.1.esm.min.js

*/
import { ethers } from "./ethers-5.6.esm.min.js"
import { abi, contractAddress } from "./constants.js"

const connectButton = document.getElementById("connectButton")
const withdrawButton = document.getElementById("withdrawButton")
const fundButton = document.getElementById("fundButton")
const balanceButton = document.getElementById("balanceButton")
connectButton.onclick = connect
withdrawButton.onclick = withdraw
fundButton.onclick = fund
balanceButton.onclick = getBalance

/*
  Se tiene una funcion connect la cual verificara que tengamos instalado metamask y de ser asi conectara nuestra wallet
*/
async function connect() {
  /*
    Se necesita tener instalado en el navegador la aplicacion de metamask para que se pueda reconocer e interactuar con ella
    Cuando se tiene instalada se crea una instancia de esta en el objeto window automaticamente
    Se puede acceder a ella con window.ethereum, si no se tiene instalada esta instancia marcara undefine
    Por ello se hace la comprobacion de que se tiene una instancia primero que nada 
  */
  if (typeof window.ethereum !== "undefined") {
    try {
      /*
        Metamask tiene la funcion request en la cual se le especificara el metodo eth_requestAccounts
        Este metodo basicamente nos conectara a la cartera del cliente
      */
      await ethereum.request({ method: "eth_requestAccounts" })
    } catch (error) {
      console.log(error)
    }

    connectButton.innerHTML = "Connected"
    const accounts = await ethereum.request({ method: "eth_accounts" })
    console.log(accounts)
  } else {
    connectButton.innerHTML = "Please install MetaMask"
  }
}

/*
   Para interactuar con nuestro contrato ya desplegado, el cual se encuentra ya en la blockchain se necesitan algunas cuentas cosas:
   provider: Este provider nos lo dara alguna web3wallet como metamask y es el que estara conectada a la blockchain
   signer: sera la persona que estara conectada con metamask en el navegador
   wallet: sera la wallet del signer
   contract: Sera el contrato con el que estaremos interactuando
    Para establecer conexino con el contrato se necesitan:
      El ABI y el Address del contrato
*/

async function withdraw() {
  console.log(`Withdrawing...`)
  if (typeof window.ethereum !== "undefined") {
    //Para establecer un provider se trabaja con ehters con el siguiente metodo, el cual utilizara metamask para funcionar
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    await provider.send('eth_requestAccounts', [])
    //Para obtener el signer utilizaremos nuestro objeto provider y el metodo getSigner el cual retornara cualquier wallet que este conectada
    const signer = provider.getSigner()
    /*
      Para establecer una conexino con nuestro contrato, utilizamos ehters y la clase Contract
      Necesitamos pasarlem como parametros:
        La direccion del contrato
        el abi
        y un signer
    */
    const contract = new ethers.Contract(contractAddress, abi, signer)
    // Si la transaccion es rechazada tendremos un error, por eso es importante colocar un bloque trycatch para manejar este error
    try {
      //Una vez establecimos la conexino con nuestro contrato, podemos interactuar con los metodos que tiene
      const transactionResponse = await contract.withdraw()
      await listenForTransactionMine(transactionResponse, provider)
      // await transactionResponse.wait(1)
    } catch (error) {
      console.log(error)
    }
  } else {
    withdrawButton.innerHTML = "Please install MetaMask"
  }
}

async function fund() {
  const ethAmount = document.getElementById("ethAmount").value
  console.log(`Funding with ${ethAmount}...`)
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const signer = provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    try {
      //Para hacer la conversion a ehters se utiliza la libreria de ethers.utils.parseEther()
      const transactionResponse = await contract.fund({
        value: ethers.utils.parseEther(ethAmount),
      })
      await listenForTransactionMine(transactionResponse, provider)
    } catch (error) {
      console.log(error)
    }
  } else {
    fundButton.innerHTML = "Please install MetaMask"
  }
}

// Para saber el balance de un contrato utilizaremos la siguiente funcion
async function getBalance() {
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    try {
      // Con nuestro objeto provider utilizaremos el metodo getBalance para saber el balance de un contrato en especifico
      const balance = await provider.getBalance(contractAddress)
      console.log(ethers.utils.formatEther(balance))
    } catch (error) {
      console.log(error)
    }
  } else {
    balanceButton.innerHTML = "Please install MetaMask"
  }
}

//Para saber que una transaccion se completo implementaremos el siguiente metodo
function listenForTransactionMine(transactionResponse, provider) {
    console.log(`Mining ${transactionResponse.hash}`)

    return new Promise((resolve, reject) => {
        try {
          /* 
            Para escuchar por eventos se tiene varios metodos: https://docs.ethers.org/v5/api/providers/provider/#Provider-once
            el evento once se ejecuta el codigo dentro de su bloque una sola vez

            Se tiene que pasar como parametros el nombre del evento, el cual podremos obtener del hash de la transaccion
            y como segundo parametro un callback a ejecutar
          
          */
            provider.once(transactionResponse.hash, (transactionReceipt) => {
                console.log(
                    `Completed with ${transactionReceipt.confirmations} confirmations. `
                )
                resolve()
            })
        } catch (error) {
            reject(error)
        }
    })
}
