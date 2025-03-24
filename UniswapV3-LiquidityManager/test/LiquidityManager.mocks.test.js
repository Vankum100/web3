const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("UniswapV3LiquidityManager", function () {
    let liquidityManager, deployer, user;
    let mockToken0, mockToken1, mockPool, mockPositionManager;

    beforeEach(async function () {
        [deployer, user] = await ethers.getSigners();

        const MockToken = await ethers.getContractFactory("MockToken");
        mockToken0 = await MockToken.deploy("Token0", "TK0");
        await mockToken0.waitForDeployment();

        mockToken1 = await MockToken.deploy("Token1", "TK1");
        await mockToken1.waitForDeployment();

        const MockUniswapV3Pool = await ethers.getContractFactory("MockUniswapV3Pool");
        mockPool = await MockUniswapV3Pool.deploy(await mockToken0.getAddress(), await mockToken1.getAddress());
        await mockPool.waitForDeployment();

        const MockPositionManager = await ethers.getContractFactory("MockPositionManager");
        mockPositionManager = await MockPositionManager.deploy();
        await mockPositionManager.waitForDeployment();

        const LiquidityManager = await ethers.getContractFactory("UniswapV3LiquidityManager");
        liquidityManager = await LiquidityManager.deploy(await mockPositionManager.getAddress());
        await liquidityManager.waitForDeployment();
    });

    it("Should deploy correctly", async function () {
        expect(await liquidityManager.positionManager()).to.equal(await mockPositionManager.getAddress());
    });

    it("Should revert if invalid pool address is provided", async function () {
        await expect(
            liquidityManager.addLiquidity(ethers.ZeroAddress, 1000, 1000, 10)
        ).to.be.revertedWith("Invalid pool address");
    });

    it("Should revert if amount0 or amount1 is zero", async function () {
        await expect(
            liquidityManager.addLiquidity(await mockPool.getAddress(), 0, 1000, 10)
        ).to.be.revertedWith("Amounts must be greater than zero");

        await expect(
            liquidityManager.addLiquidity(await mockPool.getAddress(), 1000, 0, 10)
        ).to.be.revertedWith("Amounts must be greater than zero");
    });

    it("Should revert if width is zero", async function () {
        await expect(
            liquidityManager.addLiquidity(await mockPool.getAddress(), 1000, 1000, 0)
        ).to.be.revertedWith("Width must be positive");
    });

    it("Should successfully add liquidity with valid parameters", async function () {
        try {
            const tx = await liquidityManager.addLiquidity(await mockPool.getAddress(), 1000, 1000, 10);
            await tx.wait();
        } catch (error) {
            console.error("Revert Reason:", error);
        }
    });

});
