pragma solidity ^0.4.22;

contract Car {
    string brand;
    uint public price;

    // set init values using constructor
    constructor(string initBrand, uint initPrice) public {
        brand = initBrand;
        price = initPrice;
    }

    function setBrand(string newBrand) public {
        brand = newBrand;
    }
    function getBrand() public view returns(string) {
        return brand;
    }
    function setPrice(uint newPrice) public {
        price = newPrice;
    }
    function getPrice() public view returns(uint) {
        return price;
    }
}
