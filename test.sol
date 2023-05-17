// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DAD {
    function dad() public pure returns(string memory) {
        return "dad from DAD";
    }
}

contract MOM {
    function mom() public pure returns(string memory) {
        return "mom from MOM";
    }
}

contract CHILD is DAD {
    function child() public pure returns(string memory) {
        return "child from CHILD";
    }
}

contract CHILD2 is DAD, MOM {
    function child() public pure returns(string memory) {
        return "child from CHILD";
    }
}

contract CHILD3 is DAD {
    function child() public pure returns(string memory) {
        return "child from CHILD";
    }

    function dad(uint a) public pure returns(string memory, uint) {
        return ("dad from CHILD", a);
    }
}