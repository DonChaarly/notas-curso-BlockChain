const { network } = require("hardhat")

//================================= SCRIPTS DE DEPLOY CON HARDHAT-DEPLOY ====================================
const DECIMALS = "8"
const INITIAL_PRICE = "200000000000" // 2000
// La funcion principal que se utilizara en el deploy tiene que ser exportada en el modulo.exports
/*
    A estas funciones se les pasa automaticamente el ojbeto hre que es lo mismo que el require("hardhat")
    Asi podemos desestrucutrar los metodos que hay en esta libreria y utilizarlos en nuestro codigo

 */
module.exports = async ({ getNamedAccounts, deployments }) => {
    // Desestrucutramos mas objetos de nuestros argumentos
    /*
        deploy: Sera la funcion de deploy
        log: para imprimir en la consola
        deployer: Nos devuelve las cuentas de donde se esta haciendo el deploy
            NOTA: si utilizar esto mejor ve de nuevo el video de solidity en el minuto: 10:21:00
        chainInd: Es el chainId de la network
    */
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    // If we are on a local development network, we need to deploy mocks!
    if (chainId == 31337) {
        log("Local network detected! Deploying mocks...")
        /* 
            Se utiliza el metodo deploy para hace el deploy del contrato 
            Se pasa como parametro el nombre del contrato a deployar y un objto con parametros como:
            contract: el nombre del contrato,
            from: la cartera del usario que esta lanzando el contrato
            log: es pera poder imprimir en la consola,
            arg: son los argmentos que tomara el contructor del contrato
        
        */
        await deploy("MockV3Aggregator", {
            contract: "MockV3Aggregator",
            from: deployer,
            log: true,
            args: [DECIMALS, INITIAL_PRICE],
        })
        log("Mocks Deployed!")
        log("------------------------------------------------")
        log(
            "You are deploying to a local network, you'll need a local network running to interact"
        )
        log(
            "Please run `npx hardhat console` to interact with the deployed smart contracts!"
        )
        log("------------------------------------------------")
    }
}
module.exports.tags = ["all", "mocks"]
