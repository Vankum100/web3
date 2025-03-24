// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IUniswapV3PositionManager.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UniswapV3LiquidityManager is Ownable {
    IUniswapV3PositionManager public immutable positionManager;

    constructor(address _positionManager) {
        require(_positionManager != address(0), "Invalid Position Manager address");
        positionManager = IUniswapV3PositionManager(_positionManager);
    }

    function addLiquidity(address pool, uint256 amount0, uint256 amount1, uint256 width) external {
        require(pool != address(0), "Invalid pool address");
        require(amount0 > 0 && amount1 > 0, "Amounts must be greater than zero");
        require(width > 0, "Width must be positive");

        IUniswapV3Pool uniswapPool = IUniswapV3Pool(pool);
        (uint160 sqrtPriceX96,,,,,,) = uniswapPool.slot0();

        uint160 lowerPrice = sqrtPriceX96 - (sqrtPriceX96 * uint160(width) / 10000);
        uint160 upperPrice = sqrtPriceX96 + (sqrtPriceX96 * uint160(width) / 10000);

        int24 tickSpacing = uniswapPool.tickSpacing();
        int24 lowerTick = _nearestTick(lowerPrice, tickSpacing);
        int24 upperTick = _nearestTick(upperPrice, tickSpacing);

        positionManager.mint(IUniswapV3PositionManager.MintParams({
            token0: uniswapPool.token0(),
            token1: uniswapPool.token1(),
            fee: uniswapPool.fee(),
            tickLower: lowerTick,
            tickUpper: upperTick,
            amount0Desired: amount0,
            amount1Desired: amount1,
            amount0Min: 0,
            amount1Min: 0,
            recipient: msg.sender,
            deadline: block.timestamp + 1 hours
        }));
    }

    function _nearestTick(uint160 price, int24 tickSpacing) internal pure returns (int24) {
        return int24(int256(uint256(price) / uint256(int256(tickSpacing))) * tickSpacing);
    }

}
