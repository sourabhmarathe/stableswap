// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import './Exchange.sol';

/*
* The factory contract is used to launch and track which asset pairs
* have been created.
*/
contract Factory {
    uint256 public tokenCount;
    struct TokenPair {
        address token1;
        address token2;
    }
    mapping(bytes32 => address) tokenPairToExchange;
    mapping(address => TokenPair) exchangeToTokenPair;
    mapping(uint256 => TokenPair) idToTokenPair;

    event NewExchange(address, address, address);

    function createExchange(address token1, address token2) public returns (address) {
        require(token1 != address(0));
        require(token2 != address(0));
        require(token1 != token2);
        TokenPair memory tokenPair = TokenPair(token1, token2);
        bytes32 tokenPairHash = keccak256(abi.encodePacked(token1, token2));
        require(tokenPairToExchange[tokenPairHash] != address(0));

        Exchange exchange = new Exchange(token1, token2);
        address exchangeAddr = address(exchange);

        uint256 tokenID = tokenCount + 1;
        tokenCount = tokenID;
        idToTokenPair[tokenID] = tokenPair;
        emit NewExchange(token1, token2, exchangeAddr);
        return exchangeAddr;
    } 

    function getExchange(TokenPair memory tokenPair) external view returns (address) {
        bytes32 tokenPairHash = keccak256(abi.encodePacked(tokenPair.token1, tokenPair.token2));
        return tokenPairToExchange[tokenPairHash];
    }

    function getTokenPair(address exchange) public view returns (TokenPair memory) {
        return exchangeToTokenPair[exchange];
    }

    function getTokenPairWithId(uint256 tokenID) public view returns (TokenPair memory) {
        return idToTokenPair[tokenID];
    }    
}