const { network } = require("hardhat")

module.exports = async function (hre) {
    const { getNamedAccounts, deployments } = hre
    const { deploy, log, get } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    let vrfCoordinatorAddress
    let subscriptionId

    const FUND_AMOUNT = "10000000000000000000"

    // if we are working with local networks we wont have 
    // we vrfCoordinator and linktoken
    // we need to configure it for the local network separately in that case
    if ( chainId === 31337 ) {
        log("if")
        // make a fake chainlink vrf node
        // mocking
        const vrfCoordinatorV2Mock = await hre.ethers.getContract("VRFCoordinatorV2Mock")
        vrfCoordinatorAddress = vrfCoordinatorV2Mock.address
        log(vrfCoordinatorAddress)

        const linkTokenMock = await hre.ethers.getContract("LinkToken")
        linkTokenAddress = linkTokenMock.address
        log(linkTokenAddress)

        // create subscription to fund our contract request
        const tx = await vrfCoordinatorV2Mock.createSubscription()
        const txReceipt = await tx.wait(1)
        //we get subscription id
        subscriptionId = txReceipt.events[0].args.subId
        // // now we fund it with fake tokens for mocking
        await vrfCoordinatorV2Mock.fundSubscription(subscriptionId, FUND_AMOUNT)
    } else {
        log("else")
        // use real chainlink vrf node
        vrfCoordinatorAddress = "0x6168499c0cFfCaCD319c818142124B7A15E857ab",
        subscriptionId =process.env.VRF_SUBSCRIPTION_ID,
        linkTokenAddress = "0x01BE23585060835E02B77ef475b0Cc51aA1e0709"

    }

    args = [
        subscriptionId,
        vrfCoordinatorAddress,
        linkTokenAddress,
        "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc",
        
    ]

    const randomNumberConsumerV2 = await deploy("RandomNumberConsumerV2", {
        from: deployer,
        log: true,
        args: args,
    })

    log("Then run RandomNumberConsumer contract with the following command")
    const networkName = network.name == "hardhat" ? "localhost" : network.name
    log(
        `yarn hardhat request-random-number --contract ${randomNumberConsumerV2.address} --network ${networkName}`
    )
    log("----------------------------------------------------")
    
}

module.exports.tags =["all"]