# EthernautChallenges
The following are the solutions to the Ethernaut Levels. For a detailed walkthrough please have a look at the videos:
https://www.youtube.com/channel/UCCk-bj8IXoWDLzu7Hjf3GLQ

As mentioned in the Solidity documentation : "When deploying contracts, you should use the latest released version of Solidity. This is because breaking changes as well as new features and bug fixes are introduced regularly."


Here are some useful links:
* [Nicole Zhu's Walkthrough](https://hackernoon.com/ethernaut-lvl-0-walkthrough-abis-web3-and-how-to-abuse-them-d92a8842d71b)
* [OpenZeppelin Forum](https://forum.openzeppelin.com/t/ethernaut-community-solutions/561)
* [Solidity documentation](https://solidity.readthedocs.io/en/latest/)
* [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)
* [Mastering Ethereum](https://github.com/ethereumbook/ethereumbook)

All the comments I made are subject to my own interpretation of how things work. Please feel free to contact me if something is not clear to you or needs to be corrected.

## Solution:
### Level 1 Fallback:
Solidity documentation release 0.6.4 :<br/>
*"A contract can have at most one fallback function, declared using fallback () external [payable] (without the function keyword). This function cannot have arguments, cannot return anything and must have external visibility. It is executed on a call to the contract if none of the other functions match the given function signature, or if no data was supplied at all and there is no receive Ether function. The fallback function always receives data, but in order to also receive Ether it must be marked payable."* p. 99

*"msg.value (uint): number of wei sent with the message"* p. 73

In the case of this contract, in order to execute the fallback function we need to pass the require condition: <br/>
*require (msg.value > 0 && contributions[msg.sender] > 0)*<br/>
Therefore, before calling the fallback function with an amount attached to it, we also need to increase our contributions (using the *contribute* function). Once that’s done we will become the new owner of the contract. We can then use the *withdraw* function to reduce its balance to 0.

We will solve this challenge using the following command in the console (can be access by clicking F12):<br/>
*await contract.owner()*<br/>
*player*<br/>
*await contract.contributions(player)*<br/>
*await contract.contribute({value:1})*<br/>
*await contract.contributions(player)*<br/>
*await contract.sendTransaction({value:1})*<br/>
*await contract.owner()*<br/>
*player*<br/>
*await contract.withdraw()*<br/>

### Level 2 Fallout:
Solidity documentation release 0.6.4 :<br/>
*"A constructor is an optional function declared with the constructor keyword which is executed upon contract 
creation, and where you can run contract initialisation code."* p. 110 <br/>
*“Prior to version 0.4.22, constructors were defined as functions with the same name as the contract. This syntax 
was deprecated and is not allowed anymore in version 0.5.0.”* p. 110

In this contract, the constructor syntax is deprecated and misspelled (fal1out written with the number 1 instead of 
the letter l). Therefore, to claim ownership of this contract you just need to call the *fal1out* function.

### Level 3 Token:
Solidity documentation release 0.6.4 :<br/>
*“A blockchain is a globally shared, transactional database. This means that everyone can read entries in the database
just by participating in the network”* p. 10<br/>
*“Everything you use in a smart contract is publicly visible, even local variables and state variables marked private.
Using random numbers in smart contracts is quite tricky if you do not want miners to be able to cheat.”* p. 153

Ethereum Yellow paper:<br/>
*“Providing random numbers within a deterministic system is, naturally, an impossible task. However, we can approximate with pseudo-random numbers by utilising data which is generally unknowable at the time of transacting. Such data might include the block’s hash, the block’s timestamp and the block’s beneficiary address”.*

In this case, the block number is knowable at the time of transacting. Thus, we can create a malicious contract (Level3_CoinFlipSolution.sol) that computes the right guess and use this value to call the *flip* function of the CoinFlip contract (before a new block gets mined). Therefore, we are able to guess the right outcome everytime.

### Level 4 Telephone:
Solidity documentation release 0.6.4 :<br/>
*“msg.sender (address payable): sender of the message (current call)”* p. 73<br/>
*“tx.origin (address payable): sender of the transaction (full call chain)”* p. 73 

In other words, *tx.origin* is the original address that sends a transaction while *msg.sender* is the current (i.e. last, closest) sender of a message. For instance, assume user/contract A calls contract B which triggers it to call contract C which triggers it to call contract D, we have the following: 

![tel_graph2](https://user-images.githubusercontent.com/61462365/76195000-a9109f80-61e7-11ea-81ab-585464e51b3d.png)

To solve this level, we (the user) will call the function of a malicious contract (Level4_TelephoneSolution.sol) that will call the *changeOwner* function of the Telephone contract. Thus, for the Telephone contract: *tx.origin* (= user’s address)  *≠* *msg.sender* (= malicious contract’s address). This will allow us to pass the if statement and become the new owner of the contract. 

### Level 5 Token:
Solidity documentation release 0.6.4 :<br/>
*“As in many programming languages, Solidity’s integer types are not actually integers. They resemble integers when the values are small, but behave differently if the numbers are larger. For example, the following is true: uint8(255)+ uint8(1) == 0.  This situation is called an overflow.  It occurs when an operation is performed that requires a fixed size variable to store a number (or piece of data) that is outside the range of the variable’s data type. An underflow is the converse situation:uint8(0) - uint8(1) == 255”* p. 156<br/>

As suggested by the level, it’s similar to how an odometer (instrument measuring the distance traveled by a vehicle)
works:

![Explanation2](https://user-images.githubusercontent.com/61462365/76195124-e9701d80-61e7-11ea-8102-d60b79b4b89b.png)

To solve this level we will perform an underflow by using the *transfer* function with the following two inputs: another address (than the one we are currently using) and a number bigger than 20 (= amount of tokens given). We used the following command in the console:<br/>
*await contract.balanceOf(player)* <br/>
*await contract.transfer("0x6E0B06770144b7b5923f3d759C19E1938Fe67807", 21)* <br/>
*await contract.balanceOf(player)* <br/>

### Level 6 Delegation:
Solidity documentation release 0.6.4 :<br/>
*“There exists a special variant of a message call, named delegatecall which is identical to a message call apart from 
the fact that the code at the target address is executed in the context of the calling contract and msg.sender and
msg.value do not change their values. This means that a contract can dynamically load code from a different address 
at runtime.  Storage, current address and balance still refer to the calling contract, only the code is taken from the 
called address. This makes it possible to implement the “library” feature in Solidity:  Reusable library code that can be
applied to a contract’s storage, e.g. in order to implement a complex data structure”* p. 13<br/>
*“The first four bytes of the call data for a function call specifies the function to be called. It is the first (left, high-order in big-endian) four bytes of the Keccak-256 (SHA-3) hash of the signature of the function. The signature is defined as 
the canonical expression of the basic prototype without data location specifier”* p. 179  <br/>
*“Any interaction with another contract imposes a potential danger, especially if the source code of the contract  
is not known in advance.”* p. 78<br/>

In other words, by using a delegatecall you let another contract’s code run inside the calling contract. This code is 
executed using the calling contract state (i.e. data, variables) and can potentially modify it. It’s a double-edged sword. 
Here is an example:

![Explanation2](https://user-images.githubusercontent.com/61462365/76687833-f77acf80-6627-11ea-9839-da28720ee233.png)

To solve this level we will use the pwn function in the context of the Delegation contract by using a delegatecall
(located in its fallback function). In order to precisely call the pwn function, we need to pass its function signature 
(i.e. first four bytes of the Keccak-256 hash). 



### Level 7 Force:
Solidity documentation release 0.6.4 :<br/>
*“A contract without a receive Ether function can receive Ether as a recipient of a coinbase transaction (aka miner 
block reward) or as a destination of a selfdestruct. A contract cannot react to such Ether transfers and thus also 
cannot reject them. This is a design choice of the EVM and Solidity cannot work around it.”* p. 99<br/>

To solve this level we will deploy a malicious contract (Level7_Force.sol) and send some fund to it. Then, we will designate the Force contract as owner of the malicious contract and destroy our malicious contract. Thus, sending fund to the Force 
contract that cannot be rejected.


### Level 8 Vault:
Solidity documentation release 0.6.4 :<br/>
*“Everything that is inside a contract is visible to all observers external to the blockchain. Making something private
only prevents other contracts from reading or modifying the information, but it will still be visible to the whole world 
outside of the blockchain.”* p. 90<br/>
*“Even if a contract is removed by “selfdestruct”, it is still part of the history of the blockchain and probably retained 
by most Ethereum nodes. So, using “selfdestruct” is not the same as deleting data from a hard disk.”* p. 14<br/>
*“Statically-sized variables (everything except mapping and dynamically-sized array types) are laid out contiguously in
storage starting from position 0. Multiple, contiguous items that need less than 32 bytes are packed into a single 
storage slot if possible [...] ”.* p. 123<br/>

Everything you use in a smart contract is publicly visible. Moreover, keep in mind that a blockchain is an **append-only
ledger**. If you change the state of your contract or even destroy it, it will still be part of the history of the blockchain. 
Thus, everyone can have access to it. <br/>

To solve this level we will unlock the vault by using the function unlock with the value of password as argument. 
To get the value of password we need to access the state and get the value stored at slot 1 (slot 0 contains the bool 
value).

### Level 9 King:<br/>
Solidity documentation release 0.6.4 :<br/>
*“The transfer function fails if the balance of the current contract is not large enough or if the Ether transfer is rejected
by the receiving account. The transfer function reverts on failure. Note: If x is a contract address, its code (more specifically:  its Receive Ether Function, if present, or otherwise its Fallback Function, if present) will be executed together with the transfer call (this is a feature of the EVM and cannot  be prevented). If that execution runs out of gas or fails in any way, the Ether transfer will be reverted and the current contract will stop with an exception.”* p. 49-50<br/>
*“Any interaction with another contract imposes a potential danger, especially if the source code of the contract  
is not known in advance.”* p. 78<br/>

In order to solve this level we first need to become the new King by sending an amount >= 1 Ether. Then, we must
prevent others of dethroning us by forcing the transfer function to revert. This can be implemented in several ways. 
We will create a malicious contract (Level9_King.sol) with a fallback function that will revert anytime it’s called.

### Level 10 Re-entrancy:<br/>
Solidity documentation release 0.6.4 :<br/>
*“You should avoid using .call() whenever possible when executing another contract function as it bypasses type 
checking, function existence check, and argument packing.”* p. 76 <br/>
*“Any interaction with another contract imposes a potential danger, especially if the source code of the contract  
is not known in advance. The current contract hands over control to the called contract and that may potentially do 
just about anything.”* p. 78<br/>
<br/>
In order to solve this level we will create a malicious contract with a fallback function that calls back the withdraw 
function. Thus, this will prevent the withdraw function completion until all the contract funds are drained (as shown 
below). Before calling the withdraw function we need to increase the balance of our malicious contract (by using 
the donate function of the Reentrance contract).

![reentrance](https://user-images.githubusercontent.com/61462365/77301685-6921e000-6cf0-11ea-90be-f94aac620b29.png)

### Level 11 Elevator:<br/>
Solidity documentation release 0.6.4 :<br/>
*“Interfaces are similar to abstract contracts, but they cannot have any functions implemented.”* p. 113<br/>
*“All functions declared in interfaces are implicitly virtual, which means that they can be overridden. This does
not automatically mean that an overriding function can be overridden again  - this is only possible if the 
overriding function is marked virtual.”* p. 114 <br/>

To solve this level we will create a malicious contract that will implement the *isLastFloor* function. Then we 
will invoke the *goTo* function from the malicious contract. This will ensure that it’s the *isLastFloor* function from the malicious contract that will be used. The *isLastFloor* function needs to return false the first time it’s called (to pass the if statement) and true the second time it’s called (to change the boolean top value to true).

### Level 12 Privacy:<br/>
Solidity documentation release 0.6.4 :<br/>
*“Everything that is inside a contract is visible to all observers external to the blockchain. Making something private
only prevents other contracts from reading or modifying the information, but it will still be visible to the whole world 
outside of the blockchain.”* p. 90<br/>
*“Statically-sized variables (everything except mapping and dynamically-sized array types) are laid out contiguously in
storage starting from position 0. Multiple, contiguous items that need less than 32 bytes are packed into a single 
storage slot if possible [...]”*. p. 123<br/>

This level is similar to level 8 Vault. Remember that all on-chain data are publicly visible (marking them private only
makes them inaccessible to other contracts). Please have a look at [Nicole Zhu’s walkthrough](https://medium.com/coinmonks/ethernaut-lvl-12-privacy-walkthrough-how-ethereum-optimizes-storage-to-save-space-and-be-less-c9b01ec6adb6) in order to gain more 
insight on how variables are stored. This [article](https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/) by Steve Marx is also very helpful. To unlock this contract, we need to use the *unlock* function with an input equal 
to bytes16(data[2]) which is the first 16 bytes stored at slot 5 (as seen below). 
Note that: <br/>
- bytes32 takes the same amount of storage as uint256; (2^8)^32 = 2^256.<br/> 
- in the video I was able to input a bytes32 instead of a bytes16 as expected by the unlock function. This might be due to the contract's ABI that truncates the input. <br/>

![storage](https://user-images.githubusercontent.com/61462365/78298851-6bc3d700-7533-11ea-904b-7dfed78239b8.png)


### Level 13 Gatekeeper One :<br/>
To solve this level we need to call the *enter* function and pass the conditions of each function modifier. <br/> 
To pass:<br/>
- gateOne: we will create a malicious contract with a function letMeIn that calls the enter function of the Gatekeeper contract. By calling letMeIn in Remix-IDE tx.origin ≠ msg.sender (see solution of level 4 Telephone for more details).<br/>
- gateTwo: to see the remaining gas we can use the functionality of Remix-IDE. The value we are looking for will be shown after the opcode GAS, i.e. in the opcode PUSH2 (see picture below). Knowing this value we could add the proper gas amount to our call in order to pass gateTwo. However, as mentioned by [Spalladino](https://github.com/OpenZeppelin/ethernaut/blob/solidity-05/contracts/attacks/GatekeeperOneAttack.sol), the proper gas offset to use will vary depending on the compiler. We will use his solution in our malicious contract and brute-force a range of possible gas values. To account for it, we will increase the gas limit in Remix-IDE.<br/>

![RemainingGas2](https://user-images.githubusercontent.com/61462365/78298883-7aaa8980-7533-11ea-9ce5-c6851eabd908.png)

To learn more about opcode, please have a look at [this article](https://blog.openzeppelin.com/deconstructing-a-solidity-contract-part-i-introduction-832efd2d7737/) from Alejandro Santander in collaboration with Leo Arias: <br/>
Solidity documentation release 0.6.5:<br/>
*“If an integer is explicitly converted to a smaller type, higher-order bits are cut off:*<br/>
     *uint32a = 0x12345678;*<br/>
    *uint16b = uint16(a); // b will be 0x5678 now ”* p. 71<br/>
- gateThree:<br/>
    - 1st condition: the last 8 hex need to be equal to the last 4 hex -> only possible if we mask part of *_gateKey* with 0, so that: 0x0000???? = 0x????. <br/>
    - 2nd condition: is achieved if the rest of the key is not masked by 0 so that  0x0000????  ≠  0x????????0000????<br/>
    - 3rd condition: 0x0000???? needs to be equal to the last 4 hex of tx.origin<br/>
We will create a variable to store the key. One possible solution is to use the value of *tx.origin* and only mask part of it with 0 (as described in the 1st condition).<br/>
 
In summary, we will create a malicious contract in Remix-IDE that calls the *enter* function of the Gatekeeper contract 
(thus passing gateOne). We will append a gas value to our call that will vary in order to brute force gateTwo (using 
[Spalladino’s solution](https://github.com/OpenZeppelin/ethernaut/blob/solidity-05/contracts/attacks/GatekeeperOneAttack.sol)). Finally, we will pass to our call a parameter made by masking part or the value of *tx.origin*.


