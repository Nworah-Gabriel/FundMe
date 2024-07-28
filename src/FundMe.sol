// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract FundMe{

    uint public minimumUsd = 5;
    
    function fund() public payable{
        require(msg.value > 1e18, "FUnding must be greater than 1 ETH");
    }

    function withdraw() public {}
}
