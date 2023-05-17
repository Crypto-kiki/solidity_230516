// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
/*
간단한 게임이 있습니다.
유저는 번호, 이름, 주소, 잔고, 점수를 포함한 구조체입니다. 
참가할 때 참가비용 1ETH를 내야합니다. (payable 함수)
4명까지만 들어올 수 있는 방이 있습니다. (array)
선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

예) 
간단한 게임이 있습니다.

참가할 때 참가비용 0.01ETH를 내야합니다.
4명까지만 들어올 수 있는 방이 있습니다.
선착순 4명에게는 각각 4,3,2,1점의 점수를 부여하고 4명이 되는 순간 방이 비워져야 합니다.

예) 
방 안 : "empty" 
-- A 입장 --
방 안 : A 
-- B, D 입장 --
방 안 : A , B , D 
-- F 입장 --
방 안 : A , B , D , F 
A : 4점, B : 3점 , D : 2점 , F : 1점 부여 후 
방 안 : "empty" 

유저는 10점 단위로 점수를 0.1ETH만큼 변환시킬 수 있습니다.
예) A : 12점 => A : 2점, 0.1ETH 수령 // B : 9점 => 1점 더 필요 // C : 25점 => 5점, 0.2ETH 수령

* 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
* 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
* 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
* 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
* 관리자 인출 기능 - 관리자는 0번지갑으로 배포와 동시에 설정해주세요, 관리자는 원할 때 전액 혹은 일부 금액을 인출할 수 있음 (따로 구현)
---------------------------------------------------------------------------------------------------
* 예치 기능 - 게임할 때마다 참가비를 내지 말고 유저가 일정금액을 미리 예치하고 게임할 때마다 자동으로 차감시키는 기능.
*/

contract Game {

    mapping(address => uint) point;
    address[4] room;

    struct User {
        string name;
        uint number;
        address ad;
        uint point;
    }

    User[] users;

    // modifier pushUsers

    address payable owner;
    constructor() {
        // 0번 지갑
        owner = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    }


    // * 유저 등록 기능 - 유저는 이름만 등록, 번호는 자동적으로 순차 증가, 주소도 자동으로 설정, 점수도 0으로 시작
    // * 게임 참가시 참가비 제출 기능 - 참가시 0.01eth 지불 (돈은 smart contract가 보관)
    function join(string memory _name) payable public {
        require(msg.value == 0.01 ether, "must pay 0.01 ether");

        address empty = 0x0000000000000000000000000000000000000000;
        for(uint i = 0; i < room.length; i++) {
            // 1 게임당 1번만 참여 가능
            require(room[i] != msg.sender, "you already joined");
            if(room[i] == empty) {
                room[i] = msg.sender;
                if(room[0] == msg.sender) {
                    point[msg.sender] += 4;
                    users.push(User(_name, i, msg.sender, point[msg.sender]));
                    return;
                } else if (room[1] == msg.sender) {
                    point[msg.sender] += 3;
                    users.push(User(_name, i, msg.sender, point[msg.sender]));
                    return;
                } else if(room[2] == msg.sender) {
                    point[msg.sender] += 2;
                    users.push(User(_name, i, msg.sender, point[msg.sender]));
                    return;
                } else if(room[3] == msg.sender) {
                    point[msg.sender] += 1;
                    users.push(User(_name, i, msg.sender, point[msg.sender]));
                    // 4명 다 차면 초기화.
                    delete users;
                    delete room;
                }
            }
        }
    }

    // 0.01eth = 10000000000000000
    // a지갑 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

    // * 유저 조회 기능 - 유저의 전체정보 번호, 이름, 주소, 점수를 반환. 
    function checkUser() public view returns(User[] memory) {
        return users;
    }

    // 컨트렉트 보유 금액 확인
    function ethInContract() public view returns(uint) {
        return address(this).balance;
    }

    // * 점수를 돈으로 바꾸는 기능 - 10점마다 0.1eth로 환전
    function pointToCash() public {
        address payable my_wallet = payable(msg.sender);
        if(point[msg.sender] >= 10) {
            uint prize = (point[msg.sender] / 10);
            my_wallet.transfer(prize * 10 ** 17);
            point[msg.sender] -= prize * 10;
        } else {
            revert("you don't have over 10 point.");
        }
    }

    // 유저 총 포인트 조회
    function check_point(address _a) public view returns(uint){
        return point[_a];
    }

    // * 관리자 인출 기능 - 전액 인출
    function getAllBalance() public {
        require(msg.sender == owner, "you are not owner.");
        owner.transfer(address(this).balance);
    }

    // * 관리자 인출 기능 - amount 만큼
    function getAmount(uint _amount) public {
        owner.transfer(_amount);
    }

}