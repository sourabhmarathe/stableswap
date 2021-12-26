// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

contract Queue {
    mapping(uint256 => bytes32) queue;
    uint256 first = 1;
    uint256 last = 0;

    function push(bytes32 data) public {
        last += 1;
        queue[last] = data;
    }

    function pop() public returns (bytes32 data) {
        require(last >= first); 

        data = queue[first];

        delete queue[first];
        first += 1;
    }
}