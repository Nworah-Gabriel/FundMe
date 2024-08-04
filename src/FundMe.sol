// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {AggregatorV3InterfaceLib} from "./library/ETH|USD.sol";



contract FundMe{
    //Attaching the AggregatorV3InterfaceLib library to uint256 methods
    using AggregatorV3InterfaceLib for uint256;
    uint public constant MINIMUM_USD = 5e18;
    mapping(address funder => uint256 amount) public FundRecord;
    address public owner;
    mapping(address => uint256) private s_addressToAmountFunded;
    address[] private s_funders;
    event Message(string message, uint amount, address senderAddress);

    //defininga custom error
    error NotOwner();

    constructor(){
        owner = msg.sender;
    }

    receive() external payable{
        fund();
        emit Message("Recieved ETH", msg.value, msg.sender);
    }

    fallback() external payable{
        fund();
        emit Message("Recieved ETH", msg.value, msg.sender);
    }

    function fund() public payable{
        //Allows users to send $
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Funding must be greater than 1 ETH");
        FundRecord[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        //sending all tokens existing in the contract to the contract owner via the 'call' function
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success);
    }

    modifier onlyOwner{
        if (msg.sender != owner){
            revert NotOwner();
        }
        // require(msg.sender == owner, "msg.sender is not the owner");
        _;
    }
}
