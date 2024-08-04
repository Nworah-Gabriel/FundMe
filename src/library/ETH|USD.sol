//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library AggregatorV3InterfaceLib {
    
    function getPrice() internal view returns (uint256){
        //Initializes an instance of the Price Feed using the Interface and contract address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ETHamount) internal view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 EthAmountInUsd = (ethPrice * ETHamount) / 1e18;
        return EthAmountInUsd;
    }

    function getVersion() internal view returns (uint){ 
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}