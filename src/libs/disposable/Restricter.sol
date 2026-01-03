// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ToDisposable } from "./ToDisposable.sol";
import { Disposable } from "./Disposable.sol";

/**
 * Wrap a ToDisposable into a Disposable
 */
contract Restricter is Ownable, Disposable {

    ToDisposable public disposable;

    address public to;

    constructor(
        ToDisposable disposable_,
        address to_
    )
        Ownable(msg.sender)
    {
        disposable = disposable_;
        to = to_;
    }

    function dispose() override public onlyOwner {
        disposable.dispose(to);
    }

}