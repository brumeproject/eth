// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "../../libs/token/Token.sol";
import { Timelocked } from "../../libs/timelock/Timelocked.sol";
import { IUniswapV3Pool } from "../../libs/uniswap3/Pool.sol";
import { Math } from "@openzeppelin/contracts/utils/math/Math.sol";

contract Seller {
    using Math for uint256;
    using Math for uint128;

    IUniswapV3Pool public pool;

    Token public immutable token0;
    Token public immutable token1;

    constructor(IUniswapV3Pool pool_) {
        pool = pool_;
    }

    function buy(uint256 amount0, uint256 minAmount1) public payable {
        require(amount0 > 0, "Amount must be positive");

        // Get current state
        (uint160 sqrtPriceX96,,,,,,) = IUniswapV3Pool(pool).slot0();
        uint128 liquidity = IUniswapV3Pool(pool).liquidity();

        // Compute virtual reserves
        uint256 Q96 = 1 << 96;
        uint256 sqrtPrice = uint256(sqrtPriceX96);
        uint256 virtual0 = liquidity.mulDiv(Q96, sqrtPrice);
        uint256 virtual1 = liquidity.mulDiv(sqrtPrice, Q96);

        // Compute new virtuals using constant product (no fee deduction)
        uint256 newVirtual0 = virtual0 + amount0;
        uint256 newVirtual1 = virtual0.mulDiv(virtual1, newVirtual0);

        // Expected amount out (positive)
        uint256 amount1 = virtual1 - newVirtual1;
        require(amount1 >= minAmount1, "Slippage exceeded");

        // Transfer token0 to this contract
        token0.transferFrom(msg.sender, address(this), amount0);

        // Mint token1 to caller (assumes this contract has minting rights)
        token1.transfer(msg.sender, amount1);
    }

}
