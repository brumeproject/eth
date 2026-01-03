// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Timelocked } from "./Timelocked.sol";

contract Timelocker is Timelocked {

    /**
     * @dev Ownable contract to lock ownership of
     */
    Ownable public target;

    constructor(
        Ownable target_
    )
        Timelocked(msg.sender)
    {
        target = target_;
    }

    function dispose(address to) public onlyOwner timelocked {
        target.transferOwnership(to);
    }

}