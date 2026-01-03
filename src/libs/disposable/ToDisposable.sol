// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

abstract contract ToDisposable {
    function dispose(address to) external virtual;
}