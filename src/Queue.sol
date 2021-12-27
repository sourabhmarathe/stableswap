// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

contract Queue {
    mapping(uint256 => address) private addrQueue;
    mapping(uint256 => uint256) public amountQueue;
    uint256 private first = 1;
    uint256 private last = 0;
    uint256 public availableBalance = 0;

    function push(address owner, uint256 amount) public {
        last += 1;
        addrQueue[last] = owner;
        amountQueue[last] = amount;
        availableBalance += amount;
    }

    function pop() public returns (address, uint256) {
        if (last < first) {
            return (address(0), 0);
        }
        first += 1;
        address owner = addrQueue[first];
        uint256 amount = amountQueue[first];
        delete addrQueue[first];
        delete amountQueue[first];
        first += 1;
        availableBalance -= amount;
        return (owner, amount);
    }
}