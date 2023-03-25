//Get funds from user
//withdraw funds
//set a minimum fundiNg value in USD
//Smart contracts can hold funs just like how wallets can 

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//this is created directly from de chainlink github repository

contract FundMe {

    uint256 public minimumUsd = 50*1e18;

    function fund() public payable{
        //want to set a minimum amount in usd
        //1. How do we send eth to this contract?
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't sent enough"); //in terms of wei

        //if a required is not accomplished the actions before it that should be cancelled will be so and the gas will be returned

    }

    function getPrice() public view returns(uint256){
        //we are interacting with a contract outside our project so we are gonna need
        // ABI of the contract
        // adress of the contract 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e   
        //taken from chainlink https://docs.chain.link/data-feeds/price-feeds/addresses#Goerli%20Testnet
        // we are calling this contract https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol 
        //and we want to use an specific function
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        //this function from the contract gives us a lot of variables but we just want the price so we write it like that
        (,int price,,,) = priceFeed.latestRoundData();
        //price of ETH in terms of usd
        //3000.00000000
        return uint256(price * 1e10); //we multiply as the units are different
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        // 3000_000000000000000000 =ETH / USDprice
        // 1_000000000000000000 ETH
        uint256 ehtAmountInUsd = (ethPrice*ethAmount)/1e18; //porque esta en wei de esos raros
        //3000
        return ehtAmountInUsd;
    }
    //function withdraw() {

    //}
}
