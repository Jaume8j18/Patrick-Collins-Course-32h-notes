//Get funds from user
//withdraw funds
//set a minimum fundiNg value in USD
//Smart contracts can hold funs just like how wallets can 

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import"./PriceConverter.sol";

//this is created directly from de chainlink github repository

 //913969 
    //constant, inmutable
    //891440 

error NotOwner();

contract FundMe {

   
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50*1e18;
    //2451 no constant
    //351 constant

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    // 444  immutable
    //2580 no immutable
    //10ctms de diferencia

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable{
        //want to set a minimum amount in usd
        //1. How do we send eth to this contract?
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't sent enough"); //in terms of wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;

        //if a required is not accomplished the actions before it that should be cancelled will be so and the gas will be returned

    }

   

    function withdraw() public onlyOwner{
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
        //require(msg.sender == i_owner, "Sender is not owner!!");
        //doing this we save a lot of gas as we dont have to save the whole string
        //revert is equal to conditional dispite the conditional inside
        if(msg.sender != i_owner){revert NotOwner(); }
        _;  //it means that executes the code AFTER ensuring the caller is an owner
    }

    //this just makes sense if we deploy the contract but someone could fund the contract jus sending founds to the contracts address
    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }
}
