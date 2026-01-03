// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Token } from "../../libs/token/Token.sol";
import { Timelocked } from "../../libs/timelock/Timelocked.sol";
import { INonfungiblePositionManager } from "../../libs/uniswap/Manager.sol";

contract Seller is Timelocked {

    Token public immutable token;

    INonfungiblePositionManager public manager;

    constructor(Token token_) Timelocked(msg.sender) {
        token = token_;
    }

    function dispose(address to) public onlyOwner timelocked {
        token.transferOwnership(to);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        token.mint(to, amount);
    }

    function buy(uint256 amount) public payable {

    }

}
