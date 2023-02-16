const ethers = require("ethers")
const fs = require("fs-extra")
require("dotenv").config()

async function main() {
    /*
        Es buena idea encriptar nuestra wallet utilizando el metodo encrypt y pasando una contrasena 
        y guardar esta llave encriptada en un archivo utilizando la libreria fs, con este archivo ya no tendremos que tener nuestras privateKey drectamente en el codigo
        Solo sera necesario utilizar el archivo que creamos con fs
    */
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY)
    const encryptedJsonKey = await wallet.encrypt(
        process.env.PRIVATE_KEY_PASSWORD,
        process.env.PRIVATE_KEY
    )
    console.log(encryptedJsonKey)
    fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey)
    /*
        Nota: Es buena idea mantener todas las cadenas sensibles como las direcciones de las wallet o las private key y contrasenas 
        en un archivo .env y recuperandolas con la libreroa dotenv
        ej: process.env.PRIVATE_KEY
    */
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })