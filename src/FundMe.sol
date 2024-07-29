// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    uint public minimumUsd = 5e18;
    mapping(address funder => uint256 amount) public FundRecord;

    function fund() public payable{
        //Allows users to send $
        require(getConversionRate(msg.value) >= minimumUsd, "Funding must be greater than 1 ETH");
        FundRecord[msg.sender] += msg.value;
    }

    function getPrice() public view returns (uint256){
        //Initializes an instance of the Price Feed using the Interface and contract address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ETHamount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 EthAmountInUsd = (ethPrice * ETHamount) / 1e18;
        return EthAmountInUsd;
    }

    function getVersion() public view returns (uint){ 
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    function withdraw() public {}
}
