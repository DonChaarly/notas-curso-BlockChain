const { ethers } = require("hardhat")
const { expect, assert } = require("chai")

/*
  Para evitar vulnerabilidades en nuestros contratos la mejor forma es hacer pruebas de nuestros metodos,
  hardhat tiene la libreria MOCHA Framework la cual ya viene incluida en hardhat,

  Para crear una prueba se utiliza el metodo describe,
  Se coloca como primer parametro el nombre de la funcion y como segundo parametro un callback

*/
describe("SimpleStorage", function () {
  //las variables se deben delcara fuera del berforeEach para poder ser accedidas desde otros bloques
  let simpleStorageFactory, simpleStorage

  /*
    con la funcion `beforeEach()` obtenemos los objetos necesarios para correr las pruebas y que utilizaremos en los bloques it
  */
  beforeEach(async function () {
    simpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
    simpleStorage = await simpleStorageFactory.deploy()
  })

  /*
    con la funcion `it()`, se especifica lo que se espera que se obtenga
    Se coloca un identificador que nos dira que es lo que se supone que se espera de la prueba,
    como segundo parametro se coloca un callback en donde se ejecutara el codigo que se va a probar

    Finalmente se evalua los resultados con el objeto assert y la funcion equal(),
    Se coloca como primer parametro el resultado a evaluar y como segundo parametro el valor esperado

    Nota: assert tiene mas funciones a parte de equal para evaluar resultados
  */

  it("Should start with a favorite number of 0", async function () {
    const currentValue = await simpleStorage.retrieve()
    const expectedValue = "0"
    assert.equal(currentValue.toString(), expectedValue)

    //Tambien se tiene el objeto expect para evaluar los resultados
    // expect(currentValue.toString()).to.equal(expectedValue)
  })
  it("Should update when we call store", async function () {
    const expectedValue = "7"
    const transactionResponse = await simpleStorage.store(expectedValue)
    await transactionResponse.wait(1)

    const currentValue = await simpleStorage.retrieve()
    assert.equal(currentValue.toString(), expectedValue)
  })

  // Extra - this is not in the video
  it("Should work correctly with the people struct and array", async function () {
    const expectedPersonName = "Patrick"
    const expectedFavoriteNumber = "16"
    const transactionResponse = await simpleStorage.addPerson(
      expectedPersonName,
      expectedFavoriteNumber
    )
    await transactionResponse.wait(1)
    const { favoriteNumber, name } = await simpleStorage.people(0)
    // We could also do it like this
    // const person = await simpleStorage.people(0)
    // const favNumber = person.favoriteNumber
    // const pName = person.name

    assert.equal(name, expectedPersonName)
    assert.equal(favoriteNumber, expectedFavoriteNumber)
  })
})
