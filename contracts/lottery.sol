//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Lottery{
    address public owner;
    address payable [] public participants;
    uint public ID;

    mapping(uint => address payable) lotteryWinnerAddr;
    constructor (){
        owner = msg.sender;
        ID = 1;
    }

    modifier OnlyOwner(){
        require(msg.sender == owner, "This function can only be called by the contract owner");
        _;
    }

    function joinLottery() public payable{
        require(msg.value > 0.5 ether, "You need 0.5 ether or more to join this lottery");
        participants.push(payable (msg.sender));
    }

    function checkBalance() public view returns(uint){
        return address(this).balance;
    }

    function generateRandomNumber() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function getWinner() public OnlyOwner  {
        uint i = generateRandomNumber() % participants.length;
        participants[i].transfer( address(this).balance);

         lotteryWinnerAddr[ID] = participants[i];

        ID++;

        participants = new address payable [](0);
    }


}