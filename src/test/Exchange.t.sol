// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "../Exchange.sol";

contract ExchangeTest is DSTest {
    function setUp() public {
        address tokenA = address(uint160(uint(keccak256(abi.encodePacked(block.number, blockhash(block.number))))));
        address tokenB = address(uint160(uint(keccak256(abi.encodePacked(block.number, blockhash(block.number + 1)))))); 
        Exchange exchange = new Exchange(tokenA, tokenB);
    }

    function testExample() public {
    }
}
