// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity 0.8.8;
// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {

    uint256 favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}







//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFacotry {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public{
        //new is used to call a contract inside other contract
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);

    }

    function sfStore(uint256 _SimpleStorageIndex, uint256 _SimpleStorageNumber) public{
        //To interact with other contracts we will need to basic things:
        //Adress of the contract
        //ABI Application Binnary Interface
        simpleStorageArray[_SimpleStorageIndex].store(_SimpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }
}
