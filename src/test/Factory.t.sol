// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import "ds-test/test.sol";
import "../Factory.sol";

contract FactoryTest is DSTest {
    Factory factory;

    function setUp() public {
        factory = new Factory();
    }

    function testDefaultFactory() public {
        assertEq(factory.tokenCount(), 0);

        address testTokenAddr = address(uint160(uint(keccak256(abi.encodePacked(block.number, blockhash(block.number))))));
        address exchangeAddr = factory.createExchange(testTokenAddr);
        assertEq(factory.tokenCount(), 1);
        assertEq(factory.tokenToExchange()[testTokenAddr])
    }
}
