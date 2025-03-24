const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contract with account:", deployer.address);

    const PositionManagerAddress = process.env.POSITION_MANAGER_ADDRESS;
    const LiquidityManager = await ethers.getContractFactory("UniswapV3LiquidityManager");

    const liquidityManager = await LiquidityManager.deploy(PositionManagerAddress);
    await liquidityManager.waitForDeployment();

    console.log("LiquidityManager deployed at:", await liquidityManager.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
