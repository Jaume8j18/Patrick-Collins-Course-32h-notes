//synchronous [solidity]
//asynchronous [javascript]

//bignumber es una libreria para trabajar con numeros

//jaleo https://stackoverflow.com/questions/74197765/i-am-experiencing-a-could-not-detect-network-event-nonetwork-code-network-e

const ethers = require("ethers")
const fs = require("fs")
require("dotenv").config()
//fs is used to read the abi and bin docs of the contracts so we can execute them

async function main() {
  //compile them in our code
  //or separately
  //HTTP://192.168.128.1:7545

  //if we dont want to use evm we can type the private key and the url on the terminal
  const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL)
  //const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  const encryptedJson = fs.readFileSync("./.encryptedKey.json", "utf8")
  let wallet = new ethers.Wallet.fromEncryptedJsonSync(
    encryptedJson,
    process.env.PRIVATE_KEY_PASSWORD
  )
  wallet = await wallet.connect(provider)
  const abi = fs.readFileSync("./SimpleStorage_sol_SimpleStorage.abi", "utf-8")
  const binary = fs.readFileSync(
    "./SimpleStorage_sol_SimpleStorage.bin",
    "utf-8"
  )

  //contractfactory is an nobjetc u can use to deploy contracts

  const contractFactory = new ethers.ContractFactory(abi, binary, wallet)
  console.log("Deploying, please wait...")
  const contract = await contractFactory.deploy() //STOP HERE, wait for our contract to deploy
  await contract.deployTransaction.wait(1)
  console.log(`Contract Address: ${contract.address}`)

  //analogo al boton para devolver el valor de la variable en remix
  //retrieve function es view function, check simplestorage.sol
  const currentFavoriteNumber = await contract.retrieve()
  //java doesnt underestand big numbers so we will work with strings instead
  console.log(`Current Favorite Number: ${currentFavoriteNumber.toString()}`)
  const transactionResponse = await contract.store("7")
  const transactionReceipt = await transactionResponse.wait(1)
  const updatedFavoriteNumber = await contract.retrieve()
  console.log(`Updated Favorite Number: ${updatedFavoriteNumber.toString()}`)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
