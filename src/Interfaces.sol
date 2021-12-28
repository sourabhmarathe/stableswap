// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.11;

interface IERC20 {
	function approve(address, uint256) external returns (bool);
	function transfer(address, uint256) external returns (bool);
	function balanceOf(address) external returns (uint256);
	function transferFrom(address, address, uint256) external returns (bool);
}