// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract A {
    uint public a;
    uint public b;
    constructor(uint _a, uint _b) {
        a = _a;
        b = _b;
    }
}

contract B {
    A a = new A(1, 2);
    A b;

    constructor(uint _a, uint _b) {
        // b = A(1, 2);  이렇게 실행하면 1,2가 아닌 주소값이 들어가야 됨.
        b = new A(_a, _b);
    }
}


contract C is A(3, 4) {

}