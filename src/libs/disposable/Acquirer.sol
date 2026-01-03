// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Disposable } from "./Disposable.sol";
import { ToDisposable } from "./ToDisposable.sol";

/**
 * Wrap a Disposable into a ToDisposable
 */
contract Acquirer is Ownable, ToDisposable {

    Disposable public disposable;

    Ownable public ownable;

    constructor(
        Disposable disposable_,
        Ownable ownable_
    )
        Ownable(msg.sender)
    {
        disposable = disposable_;
        ownable = ownable_;
    }

    function dispose(address to) override public onlyOwner  {
        /**
         * Acquire ownership
         */
        disposable.dispose();

        /**
         * Transfer ownership
         */
        ownable.transferOwnership(to);
    }

}