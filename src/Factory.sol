// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

import './Exchange.sol';

/*
* The factory contract is used to launch and track which asset pairs
* have been created.
*/
contract Factory {
    address public exchangeTemplate;
    uint256 public tokenCount;
    mapping(address => address) tokenToExchange;
    mapping(address => address) exchangeToToken;
    mapping(uint256 => address) idToToken;

    event NewExchange(address, address);

    function createExchange(address token) public returns (address) {
        require(token != address(0));
        require(exchangeTemplate != address(0));
        require(tokenToExchange[token] != address(0));

        address exchange = address(Exchange(token));

        uint256 tokenID = tokenCount + 1;
        tokenCount = tokenID;
        idToToken[tokenID] = token;
        emit NewExchange(token, exchange);
        return exchange;
    } 

    function getExchange(address token) external view returns (address) {
        return tokenToExchange[token];
    }

    function getToken(address exchange) public view returns (address) {
        return exchangeToToken[exchange];
    }

    function getTokenWithId(uint256 tokenID) public view returns (address) {
        return idToToken[tokenID];
    }    
}