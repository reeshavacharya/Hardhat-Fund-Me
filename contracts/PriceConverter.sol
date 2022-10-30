//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConverter{
     function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256){
        // //ABI
        // //Address 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        // AggregatorV3Interface priceFeed= AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (,int256 price,,,)=priceFeed.latestRoundData();
        //the above statement will return eth in terms of USD
        return uint256(price * 1e10);   
    }
    // function getVersion() internal view returns(uint256) {
    //     AggregatorV3Interface priceFeed= AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
    //     return priceFeed.version();
    // }
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns(uint256){
        uint256 price= getPrice();
        uint256 ethAmountInUsd= (price * ethAmount)/1e18;
        return ethAmountInUsd;
    } 
}
