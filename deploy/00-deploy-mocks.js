const { network } = require("hardhat")

const BASE_FEE = "250000000000000000000"
const GAS_PRICE_LINK = 1e9 // link per gas

module.exports = async({ getNamedAccounts, deployments }) => {
    console.log("Helooo")

    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    if (chainId == 31337) {
        await deploy("LinkToken", { from: deployer, log: true })

        await deploy("VRFCoordinatorV2Mock", {
            from: deployer,
            log: true,
            args: [BASE_FEE, GAS_PRICE_LINK],
        })
    }
}

module.exports.tags = ["all", "mocks"]