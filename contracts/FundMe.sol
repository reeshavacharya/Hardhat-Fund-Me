//get funds from users, 
//withdraw funds, 
//set a minimum fund in USD

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PriceConverter.sol";
error NotOwner();
contract    FundMe
{
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD=50*1e18;
    address[] public funders;
    address public immutable i_owner;

    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress){
        i_owner=msg.sender;
        priceFeed= AggregatorV3Interface(priceFeedAddress);
    }
    mapping(address=> uint256) public addressToAmountFunded;
    //just like digital wallets, contracts can hold funds as well
    //payable keyword is used to make a function hold some value
    //payble keyword allows us to access the value attribute in the deployment section
    //value can be accessd by the global keyword msg.value;
    function fund() public payable{
        //library has the function getConversionRate. 
        //msg.value is passed as an argument as: msg.value.getConversionRate()
        //this is the way arguments are passed in library functions
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!");
        //require(if this section is false, revert with this section)
        //reverting will undo any action that hapenned before and sends the remainig gas back
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender]+=msg.value;
    }
   
    function withdraw() public onlyOwner {
        //for(start_index, end_index, steps)
        for(uint256 funderIndex=0; funderIndex<funders.length; funderIndex++){
            address funder= funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }
        //reset the array
        funders= new address[](0);
        //withdraw the funds
        //3 ways: transfer, send, call
        //transfer
        // payable(msg.sender).transfer(address(this).balance); 
        //msg.sender= address 
        //payable(msg.sender)=payable address
        //send
        // bool sendSuccess= payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "SEND FAILED!!");
        //call
        (bool callSuccess,)= payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "CALL FAILED!!");
    }
    modifier onlyOwner{
        
        if(msg.sender!=i_owner){revert NotOwner();}
        _;
    }
    //what happens when someone sends this contract eth without calling the fund function
    //special functions: receive and fallback
    receive() external payable{
        fund();
    }
    fallback() external payable{
        fund();
    }

}