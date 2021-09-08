pragma solidity ^0.5.16;

contract DappToken {
    // Constructor
    // set the total number of tokens
    // read the total number of tokens

    uint256 public totalSupply;

    // function DappToken () public {
    //     totalSupply = 1000000;
    // }

    constructor () public {
        totalSupply = 1000000;
    }
}
