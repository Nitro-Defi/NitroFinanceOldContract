//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface IUniswapV3Twap {
    function estimateAmountOut(
        address tokenIn,
        uint128 amountIn,
        uint32 secondsAgo
    ) external view returns (uint amountOut);

    function getInverseConvertion(
        address tokenIn,
        uint128 amountIn,
        uint32 secondsAgo
    ) external view returns (uint amount);
}
