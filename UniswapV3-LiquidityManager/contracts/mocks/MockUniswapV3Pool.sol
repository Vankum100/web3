// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MockUniswapV3Pool {
    address public token0;
    address public token1;

    constructor(address _token0, address _token1) {
        token0 = _token0;
        token1 = _token1;
    }

    function slot0() external pure returns (uint160, int24, uint16, uint16, uint16, uint8, bool) {
        return (79228162514264337593543950336, 0, 0, 0, 0, 0, false);
    }

    function fee() external pure returns (uint24) {
        return 3000;
    }

    function tickSpacing() external pure returns (int24) {
        return 60;
    }
}
