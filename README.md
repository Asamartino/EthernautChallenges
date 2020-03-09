# EthernautChallenges
The following are the solutions to the Ethernaut Challenges. For a detailed walkthrough please have a look at the videos :
https://www.youtube.com/channel/UCCk-bj8IXoWDLzu7Hjf3GLQ

As mentioned in the Solidity documentation : "When deploying contracts, you should use the latest released version of Solidity. This is because breaking changes as well as new features and bug fixes are introduced regularly."
-> please use the latest version.

Here are some useful links:
* [Nicole Zhu's Walkthrough](https://hackernoon.com/ethernaut-lvl-0-walkthrough-abis-web3-and-how-to-abuse-them-d92a8842d71b)
* [OpenZeppelin Forum](https://forum.openzeppelin.com/t/ethernaut-community-solutions/561)
* [Solidity documentation](https://solidity.readthedocs.io/en/latest/)
* [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf)


## Solution:
### Level 1 Fallback:
Solidity documentation release 0.6.4 :<br/>
*"A contract can have at most one fallback function, declared using fallback () external [payable] (without the function keyword). This function cannot have arguments, cannot return anything and must have external visibility. It is executed on a call to the contract if none of the other functions match the given function signature, or if no data was supplied at all and there is no receive Ether function. The fallback function always receives data, but in order to also receive Ether it must be marked payable."* p. 99

*"msg.value (uint): number of wei sent with the message"* p. 73

In the case of this contract, in order to execute the fallback function we need to pass the required condition: 
*require (msg.value > 0 && contributions[msg.sender] > 0)* . Therefore, before calling the fallback function with an amount attached to it, we also need to increase our contributions (using the *contribute* function). Once that’s done we will become the new owner of the contract. We can then use the withdraw() function to reduce its balance to 0.

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

In this case, the block number is knowable at the time of transacting. Thus, we can create a contract (Level3_CoinFlipSolution.sol) that computes the right guess and use this value to call the *flip* function of the CoinFlip contract (before a new block gets mined). Therefore, we are able to guess the right outcome everytime.

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

To solve this level we will perform an underflow by using the transfer function with the following two inputs: another address (than the one we are currently using) and a number bigger than 20 (= amount of tokens given). We used the following command in the console:<br/>
*await contract.balanceOf(player)* <br/>
*await contract.transfer("0x6E0B06770144b7b5923f3d759C19E1938Fe67807", 21)* <br/>
*await contract.balanceOf(player)* <br/>


