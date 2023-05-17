// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract VISIBILITY {

    function publicF() public pure returns(string memory) {
        return "public";
    }

    function privateF() private pure returns(string memory) {
        return "private";
    }

    function testprivateF() public pure returns(string memory) {
        return privateF();
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
        internal : 내부 및 상속한 곳에만 접근 가능
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

contract Child is VISIBILITY  {
    function testInternal2() public pure returns (string memory) {
        return internalF();
    }
    function testPublic() public pure returns (string memory) {
        return publicF();
    }
    /* private, external 사용 불가능.
        function testPrivateF() public pure returns(string memory) {
            return privateF();
        }
    private를 사용하려면?
    */

    function testprivateF2() internal pure returns(string memory) {
        return testprivateF();
    }
    // 위처럼 작성하면 private 함수 privateF()함수를 감추지만 testprivateF()를 통해 사용할 수 있음.
}

// 그럼 external은 어떻게 부르나? -> instance화 시켜야 함.
contract Outsider {
    // 인스턴스화 : 구체적이게 적어야 함. 그냥 VISIBILITY vs; 만 선언하면 리턴값 못불러옴.
    VISIBILITY vs = new VISIBILITY();   // new = VSIBILITY의 값들을 초기화 시켜서 받음.

    function getExternalFromVS() public view returns(string memory) {
        return vs.externalF();
    }

    function getPublicFromVS() public view returns(string memory) {
        return vs.publicF();
    }
}







// 상속
contract Parent {
    function add(uint a, uint b) public pure returns(uint) {
        return a + b;
    }

}

contract Dad {
    function add(uint a, uint b) public pure returns(uint) {
        return a + b;
    }
}

// 아래와 같이 작성하면 Child는 Parent를 상속 받는다는 것. 배포하면 Parent의 add()와 Child의 mul()함수를 쓸 수 있음.
contract Childs is Dad {
    function mul(uint a, uint b) public pure returns(uint) {
        return a * b;
    }
    function mul2(uint a, uint b) public pure returns(uint) {
        return a * b * 2;
    }
    function addDoubleTime(uint a, uint b) public pure returns(uint) {
        return Dad.add(a, b);
        // Dad의 add함수만 받아오기.
    }

}

// 그럼 부모-자식이 아닌 손자도 가능할까? 가능함. 아래 배포하면 add, divide, mul 3개의 함수 사용 가능.
contract Child2 is Child {
    function divide(uint a, uint b) public pure returns(uint) {
        return a / b;
    }

}

// 상속 여러개도 가능. Child3를 배포하면 add(), add2(), divide(), mul() 함수 총 4개 사용 가능함.
contract sub {
    function add2(uint a, uint b) public pure returns(uint) {
        return a + b;
    }
}
contract Child3 is Child, sub {
    function divide(uint a, uint b) public pure returns(uint) {
        return a / b;
    }

}


/*
    상속받은 컨트렉트의 함수와 이름이 같다면, 상속 받는 컨트랙트의 함수가 더 중요함.
    따라서 상속 받는 함수에 override, 상속하는 함수에는 virtual 쓰면 됨.
    특정 함수만 골라서 상속받는건 불가능함.
    특정하게 골라서 하러면 Dad.add(a,b)와 같이 가능함. Dad컨트랙트의 add함수만 불러옴.
*/
contract DAD {
    function dad() virtual public pure returns(string memory) {
        return "dad from DAD";
    }
}
contract MOM {
    function mom() public pure returns(string memory) {
        return "mom from MOM";
    }
}
contract CHILD is DAD {
    function add() public pure returns(string memory) {
        return "child from CHILD";
    }
}
contract CHILD2 is DAD, MOM {
    function add() public pure returns(string memory) {
        return "child from CHILD";
    }
}
contract CHILD3 is DAD {
    function add() public pure returns(string memory) {
        return "child from CHILD";
    }
    function dad() override public pure returns(string memory) {
        return "dad from CHILD";
    }
    /* 위의 dad()함수를 아래처럼 작성하면 override안써도 됨. 이유는 함수는 input으로 구분하기 때문에 다른 함수로 인식함.
        function dad(uint a) public pure returns(string memory) {
            return ("dad from CHILD", a);
        }
    */
}


/*
    CHILD4는 override를 했는데도 왜 에러가 발생할까? -> 두 개이상 상속을 받기 때문.
    띠리사 override(DAD, MOM) 으로 써줘야 함.
    변수는 override 불가능함.
    만약, CHILD4를 상속받는 컨트렉트가 있다면, virtual override(DAD, MOM)으로 해야 함. -> virtual와 override 같이 쓸 수 있음.
    아래는 틀린 예시
    contract CHILD2 is DAD, MOM {
        function who() override public pure returns(string memory) {
            return "child from CHILD";
    }
*/
contract DADs {
    function who() virtual public pure returns(string memory) {
        return "dad from DAD";
    }
    function who2() public pure returns(string memory) {
        return who();  // 내부에서도 위의 함수를 불러내는게 가능함.
    }
    function name() internal pure returns(string memory) {
        return "David";
    }
    function cal(uint a) internal pure returns(uint) {
        return a * 2;
    }
    function character() external pure returns(string memory) {
        return "not good";
    }
    /* private이라 상속받는애가 불러가지 못함.
    function password() private pure returns(uint) {
        return 1234;
    }
    */
}

contract MOMs {
    function who() virtual public pure returns(string memory) {
        return "mom from MOM";
    }
}

// 키워드 : super : 윗사람으로부터 받아온 함수를 하겠다. 2개를 상속받을 경우 상속 순서가 먼저인 것(is DADs)만 받아옴.
contract CHILD4 is DADs, MOMs {
    function who() override(DADs, MOMs) public pure returns(string memory) {
        // return "child from CHILD";
        return super.who();
    }
    function fathersName() public pure returns(string memory) {
        return super.name();
    }
    function cal_Dad(uint _b) public pure returns(uint) {
        return super.cal(_b);
        //DADs의 cal에 인풋값이 1개 있기 때문에, 인풋값 있어야 에러가 안남.
    }
    /* 아래의 password 함수는 불러오지 못함. 이유는 받아오는 password는 private이기 때문.
        function password() public pure returns(uint) {
            return super.password();
        }
    */

}

