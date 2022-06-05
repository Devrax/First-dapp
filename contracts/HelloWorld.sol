//SPDX-Licence-Identifier: UNLICENSED

pragma solidity >=0.5.9 < 0.9.0;

contract HelloWorld {

    string public yourName;

    constructor() {
        yourName = "Unknown";
    }

    function setName(string memory _name) public {
        yourName = _name;
    }

}
