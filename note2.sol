// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract DAD {
    uint a;
    // 이상태로 디플로이하면 uint a; 를 확인하지 못함. 즉, 기본적으로 internal임.

    // 변수에도 visibility 선언 가능.
    uint public wallet=100;  // 공개한 지갑 잔액
    uint internal crypto=1000;  // 메모장에 private key가 있는 크립토 잔애
    uint private emergency=10000;  // 진짜 비상금

    function who() virtual public pure returns(string memory) {
        return "dad from DAD";
    }

    function name() internal pure returns(string memory) {
        return "David";
    }

    function password() private pure returns(uint) {
        return 1234;
    }

    function character() external pure returns(string memory) {
        return "not good";
    }
    function getAddress() public view returns(address) {
        return address(this);
    }

    function getMsgSender() public view returns(address) {
        return msg.sender;
    }

}

contract MOM {
    DAD husband = new DAD();
    function who() virtual public pure returns(string memory) {
        return "mom from MOM";
    }

    function getHusbandChar() public view returns(string memory) {
        return husband.character();
    }

    function getWallet() public view returns(uint) {
        return husband.wallet();  // 함수가 아니라도 함수처럼 () 적어줘야 됨.
    }
    /* 
        function getCrypto() public view returns(uint) {
            return husband.crypto();  // visibility 때문에 막힘.
        }
        function getEmergency() public view returns(uint) {
            return husband.emergency();  // visibility 때문에 막힘.
        }
    */

    function husbandAddress() public view returns(address) {
        return address(husband);
    }

    function husbandAddress2() public view returns(address) {
        return husband.getAddress();
    }

    function husGetMsgSender() public view returns(address) {
        return husband.getMsgSender();
    }
}

contract CHILD is DAD {
    function who() override public pure returns(string memory) {
        return super.who();
        // return "child from CHILD";
    }

    function fathersName() public pure returns(string memory) {
        return super.name();
    }

    function fathersWallet() public view returns(uint) {
        return DAD.wallet;
    }
    function fathersCryto() public view returns(uint) {
        return DAD.crypto;
    }

    DAD daddy = new DAD();
    DAD daddy2 = new DAD();
    // 이렇게 new로 선언하면 다른 DAD임(다른 컨트렉트임).
    function getDaddyAddress() public view returns(address) {
        return address(daddy);
    }
    function getDaddy2Address() public view returns(address) {
        return address(daddy2);
    }

    function fathersAddress() public view returns(address) {
        return super.getAddress();
        // super는 주소가 없음.
    }

    function dadGetMsgSender() public view returns(address) {
        return super.getMsgSender();
    }
    function daddyGetMsgSender2() public view returns(address) {
        return daddy.getMsgSender();
    }

    // 아들 컨트랙트에서 아빠 컨트랙 주소를 받아오는 방법은 없다.
    // 상속을 받아도 컨트렉트를 온전히 다 받은게 아님.


    /* emergency는 visibility = private에서 막힘
        function fathersEmergency() public view returns(uint) {
            return DAD.emergency;
        }
    */



    /*
    오류 발생 상속받은 아이는 external 접근 불가능
    function fathersChar() public pure returns(string memory) {
        return super.character();
    }
    */

    /*
    오류 발생 password는 private 함수
    function password_Dad() public pure returns(uint) {
        return super.password();
    }
    */
}

contract CHILD2 is DAD, MOM {
    function who() virtual override(DAD, MOM) public pure returns(string memory) {
        return super.who();
        // return "child from CHILD";
        
    }
}