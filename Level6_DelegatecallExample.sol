pragma solidity ^0.6.3;

contract SecondContract{

 uint d = 3;
 uint e = 4;
 uint f;

 function computeF() public{
 f = d+e;
 }

}

contract firstContract {

    uint public a=1;
    uint public b=2;
    uint public c;
    SecondContract sc;
    
    function computeC() public{
    	c = a*b;
    }

    function delegatecallToComputeF(address secondContractAddress) public  {  //use as input the address of the second contract this will allow delegatecallToComputeF to call the function computeF from this address 
        sc = SecondContract(secondContractAddress);
        address(sc).delegatecall(abi.encodeWithSignature("computeF()"));  //delegatecall returns success condition and return data hence the warning as we do not use this data
    }



}
