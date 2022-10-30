//import
//main function
//calling of main function

const { network } = require("hardhat")

// function deployFunc() {
//     console.log("deployed !!!")
// }
// module.exports.default = deployFunc

modeule.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
}
