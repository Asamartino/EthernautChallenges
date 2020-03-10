pragma solidity ^0.6.3;


contract ShutUpAndTakeMyMoney{
    address payable owner;
    
    function setOwner(address payable _owner) public{
        owner = _owner;
    }
     
    function destroy() public{  //this conctract need to have a positive balance -> can do that by inputing a value in remix at deployement 
        selfdestruct(owner);
    }
    
    constructor() public payable{ // used so we can use the Value filed of RemixIDE and send Ether at creation of the contract
    }
  
    function giveMeMoney() public payable{ //to send money if you didn't send it at initiation
    
    }

}
