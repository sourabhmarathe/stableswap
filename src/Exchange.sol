// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Queue.sol";

/*
This supports swaps between assets that are supposed to have the same
price. The way it works is the exchange custodies assets from a user
wishing to sell until there is enough supply on the other side of the
trade to satisfy the order. In other words, there are two queues 
available which store each assets supply. Orders are satisfied as they
get pushed onto the queue.
*/

contract Exchange {
    IERC20 token1;
    IERC20 token2;

    Queue sellToken1;
    Queue sellToken2;

    constructor(address _token1, address _token2) {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
    }
}