// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Queue.sol";

/*
This supports swaps between assets that are supposed to have the same price. 
The way it works is the exchange custodies assets from a user wishing to sell 
until there is enough supply on the other side of th trade to satisfy the order. 
In other words, there are two queues available which store each assets supply. 
Orders are satisfied as the get pushed onto the queue.
*/
contract Exchange {
    IERC20 token1;
    IERC20 token2;

    Queue pendingOrders1;
    Queue pendingOrders2;

    constructor(address _token1, address _token2) {
        token1 = IERC20(_token1);
        token2 = IERC20(_token2);
    }

    event OrderQueued(address, uint256);
    event OrderFilled(address, uint256);

    // Allows caller of this function to sell {amount} for equivalent amount in 
    // {token2}. If there isn't sufficient {token2} avaialable, queues the 
    // order. When suffcient balance comes online, it will get transferred and 
    // an {OrderFilled} event is emitted. If there is enough liquidity, pops the 
    // order queue until sufficient balances have been accounted for. For 
    // partial account, puts the remaining amount back on the queue.
    function sellToken1(uint256 amount) payable external {
        require(token1.balanceOf(msg.sender) > amount);
        bool sufficientLiquidity = pendingOrders2.availableBalance() > amount;
        if (sufficientLiquidity) {
            token2.transfer(msg.sender, amount);
            token1.transferFrom(msg.sender, address(this), amount);
            uint256 removedBalance = 0;
            while(removedBalance < amount) {
                (address owner, uint256 value) = pendingOrders2.pop();
                removedBalance += value;
                if (removedBalance + value > amount) {
                    pendingOrders2.push(owner, removedBalance + value - amount);
                } else {
                    emit OrderFilled(owner, value);
                }
            }
            emit OrderFilled(msg.sender, amount);
        } else {
            token1.transferFrom(msg.sender, address(this), amount);
            pendingOrders1.push(msg.sender, amount);
            emit OrderQueued(msg.sender, amount);
        }
    }

    // Same function as {sellToken1} except it allows caller to sell {token2}.
    function sellToken2(uint256 amount) payable external {
        require(token2.balanceOf(msg.sender) > amount);
        bool sufficientLiquidity = pendingOrders1.availableBalance() > amount;
        if (sufficientLiquidity) {
            token1.transfer(msg.sender, amount);
            token2.transferFrom(msg.sender, address(this), amount);
            uint256 removedBalance = 0;
            while(removedBalance < amount) {
                (address owner, uint256 value) = pendingOrders1.pop();
                removedBalance += value;
                if (removedBalance + value > amount) {
                    pendingOrders1.push(owner, removedBalance + value - amount);
                } else {
                    emit OrderFilled(owner, value);
                }
            }
            emit OrderFilled(msg.sender, amount);
        } else {
            token2.transferFrom(msg.sender, address(this), amount);
            pendingOrders2.push(msg.sender, amount);
            emit OrderQueued(msg.sender, amount);
        }
    }
}