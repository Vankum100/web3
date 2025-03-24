// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IUniswapV3PositionManager.sol";

contract MockPositionManager {
    event Mint(
        address indexed token0,
        address indexed token1,
        uint24 fee,
        int24 tickLower,
        int24 tickUpper,
        uint256 amount0,
        uint256 amount1,
        uint256 tokenId
    );

    function mint(IUniswapV3PositionManager.MintParams calldata params)
    external
    returns (uint256 tokenId, uint128 liquidity, uint256 amount0, uint256 amount1)
    {
        tokenId = uint256(keccak256(abi.encodePacked(params.token0, params.token1, block.timestamp)));
        liquidity = 1000;
        amount0 = params.amount0Desired;
        amount1 = params.amount1Desired;

        emit Mint(params.token0, params.token1, params.fee, params.tickLower, params.tickUpper, amount0, amount1, tokenId);
    }
}
