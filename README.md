# stableswap
An AMM for assets that are supposed to be the same price (aka stablecoins).

This AMM (automated market maker) specifically serves stablecoin swaps. In theory,
all stablecoins can be redeemed for one $1 USD in the traditional finance economy.
Because of this, when most users exchange stablecoins, they know the price in 
advance, and are mostly optimzing for fees.

Stableswap does not require any liquidity to operate - it simply waits for 
sufficient liquidity on the other side of the trade to execute. The mechanism
works by storing two queues of orders for each token. When a user makes a swap
request, it checks the other queue. If there is sufficient liquidity, it swaps
the tokens with the other order. This allows users to swap stablecoins quickly
with minimal fees.

The fees on stableswap are lower because it is much simpler than other swap contracts
and it makes assumptions about the user's request. Here are the assumptions it makes:
1. In the short term, users are indifferent to the price of different stablecoins.
2. Users are willing to wait a bit to pay lower fees (in the event that liquidity is 
not available).
3. Liquidity would organically be provided by the MEV that could be gained by buying/
selling stablecoins on other swap markets.

With these assumptions, stableswap could be particularly useful when fees are very 
high and users want to move between different types of stablecoins. Stableswap does
not require liquidity providers to operate.
