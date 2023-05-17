// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
    1. DAD 배포
    2. DAD 주소 넣어서 MOM 배포
    3. MOM에서 getwallet, getRealwallet 실행해서 비교
    4. DAD에서 changewallet
    5. 2번 다시
*/

contract DAD {
    uint a;

    uint public wallet=100; // 공개한 지갑 잔액
    uint internal crypto=1000; // 메모장에 private key가 있는 크립토 잔액
    uint private emergency=10000; // 진짜 비상금

    function password() private pure returns(uint) {
        return 1234;
    }

    function changeWallet(uint _n) internal {
        wallet = _n;
    }

}


/*
    1. DAD 2번 배포
    2. MOM 배포(1번째 DAD 주소 넣어서)
    3. 2번 배포된 DAD에서 각각 다르게 변수 변화 주기
    4. MOM에서 setDad함수를 통해 잔액 변화 추적
*/
contract MOM {
    DAD husband = new DAD();
    DAD realHusband;

    constructor(address _a) {  // _a는 이미 배포된 DAD의 컨트렉트 주소 넣으면 됨.
        realHusband = DAD(_a);
    }

    function getWallet() public view returns(uint) {
        return husband.wallet();
    }

    function getRealWallet() public view returns(uint) {
        return realHusband.wallet();
    }

    function setDad(address _a) public view returns(uint) {
        DAD copyDad = DAD(_a);
        return copyDad.wallet();
    }

    /* DAD의 changeWallet이 internal이라 불가능해졌음. public이면 가능.
    function changeRealWallet(uint _a) public {
        realHusband.changeWallet(_a);
    }
    */

}

contract CHILD is DAD {

    function dadChangeWallet(uint _a) public {
        super.changeWallet(_a);
    }

    /* 아래처럼 하면, realDaddy는 CHILD가 DAD를 상속받았지만,
    realDaddy는 CHILD가 만들어낸 것임.
    DAD realDaddy;

    constructor(address _a) {
        realDaddy = DAD(_a);
    }

    function dadChangeWallet(uint _a) public {
        realDaddy.changeWallet(_a);
    }
    */

}