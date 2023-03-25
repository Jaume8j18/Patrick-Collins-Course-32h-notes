//             Fundme

//Get funds from user
//withdraw funds
//set a minimum fundiNg value in USD
//Smart contracts can hold funs just like how wallets can 

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import"./PriceConverter.sol";

//this is created directly from de chainlink github repository

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 50*1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund() public payable{
        //want to set a minimum amount in usd
        //1. How do we send eth to this contract?
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't sent enough"); //in terms of wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;

        //if a required is not accomplished the actions before it that should be cancelled will be so and the gas will be returned

    }

   

    function withdraw() public {
        //require(msg.sender == owner, "Sender is not owner!!"); equivalente a modifier creo
        /* starting index, ending indez, step amount*/
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset array
        funders = new address[](0);
        //withdraw funds
        //we can transfer
        // payable(msg.sender) = payable adress
        //if this way of withdraw the money doesnt work it gives an error
        //payable(msg.sender).transfer(adress(this).balance);
         //send
         //it returns a boolean with the success information of the operation 
        //bool sendSuccess = payable(msg.sender).call(adress(this).balance);
        //require(sendSuccess,"Send failed");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call failed");
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Sender is not owner!!");
        _;  //it means that executes the code AFTER ensuring the caller is an owner
    }
}

//          Price converter
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//this is created directly from de chainlink github repository

library PriceConverter{
 function getPrice() internal view returns(uint256){
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

    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        // 3000_000000000000000000 =ETH / USDprice
        // 1_000000000000000000 ETH
        uint256 ehtAmountInUsd = (ethPrice*ethAmount)/1e18; //porque esta en wei de esos raros
        //3000
        return ehtAmountInUsd;
    }
}
