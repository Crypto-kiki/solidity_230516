// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract VISIBILITY {

    function publicF() public pure returns(string memory) {
        return "public";
    }

    function privateF() private pure returns(string memory) {
        return "private";
    }

    function internalF() internal pure returns(string memory) {
        return "internal";
    }

    function externalF() external pure returns(string memory) {
        return "external";
    }
    // 위 4가지 경우가 있음. 배포하면 external과 public만 뜸. 즉, 우리는 외부에 있다는 것
    // 캡슐화, 추상화
    /*
        public : 모든곳에서 접근 가능
        external : 외부에서 만 접근 가능
        internal : 내부에서 상속한 곳에만 접근 가능
        private : 내부에서만 가능
    */

    // private과 internal 사용하려면 아래처럼. *privateF(), internalF()에 retrun이 있어도 return 을 적어야 함.아니면 return값x
    function testPrivateF() public pure returns(string memory) {
        return privateF();
    }
    function testInternalF() public pure returns(string memory) {
        return internalF();
    }

}


contract Parent {

    function add(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

}

// 아래와 같이 작성하면 Child는 Parent를 상속 받는다는 것. 배포하면 Parent의 add()와 Child의 mul()함수를 쓸 수 있음.
contract Child is Parent {
    function mul(uint a, uint b) public pure returns(uint) {
        return a * b;
    }

}