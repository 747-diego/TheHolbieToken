// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./DappToken.sol";
// import "./DappTokenSale.js";

contract DappTokenSale {
    address payable admin;
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;
    // address payable addr = address(admin);

    event Sell(address _buyer, uint256 _amount);

    constructor (DappToken _tokenContract, uint256 _tokenPrice) public {
        // ASSIGN AN ADMIN
        admin = msg.sender;
        // TOKEN CONTRACT
        tokenContract = _tokenContract;
        // TOKEN PRICE
        tokenPrice = _tokenPrice;
    }

    // MULTIPLY
    function multiply(uint x, uint y)  internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    // BUY TOKENS
    function buyTokens(uint256 _numberOfTokens) public payable {
        // REQUIRIE THAT VALUE IS EQUAL TO TOKENS
        require(msg.value == multiply(_numberOfTokens, tokenPrice));
        // REQUIRE THAT THE CONTRACT HAS ENOUGH TOKENS
        require(address(tokenContract).balance >= _numberOfTokens);
        // REQUIRE THAT A TRANSFER IS SUCCESSFUL
        require((tokenContract).transfer(msg.sender, _numberOfTokens));
        // KEEP TRACK OF TOKENS SOLD
        tokensSold += _numberOfTokens;
        //TRIGGER SELL EVENT
        emit Sell(msg.sender, _numberOfTokens);
    }

    // ENDING THE SALE
    function endSale() public {
        // REQUIRE ADMIN
        require(msg.sender == admin);
        // TRANSFER REMAINING TOKENS TO ADMIN
        require(tokenContract.transfer(admin, address(tokenContract).balance));
        // DESTROY CONTRACT
        // admin.transfer(address(tokenContract).balance);
        admin.transfer(address(this).balance);
    }

}
