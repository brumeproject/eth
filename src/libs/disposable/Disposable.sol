// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract Disposable {
    function dispose() external virtual;
}