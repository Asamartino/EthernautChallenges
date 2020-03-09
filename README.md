# EthernautChallenges
The following are the solutions to the Ethernaut Challenges. For a detailed walkthrough please have a look at the videos :
https://www.youtube.com/channel/UCCk-bj8IXoWDLzu7Hjf3GLQ

As mentioned in the Solidity documentation : "When deploying contracts, you should use the latest released version of Solidity. This is because breaking changes as well as new features and bug fixes are introduced regularly."
-> please try to use the latest version

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
require (msg.value > 0 && contributions[msg.sender] > 0). Therefore, before calling the fallback function with an amount attached to it, we also need to increase our contributions (using the contribute() function). Once that’s done we will become the new owner of the contract. We can then use the withdraw() function to reduce its balance to 0.

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
the letter l). Therefore, to claim ownership of this contract you just need to call the fal1out() function.

### Level 3 Token:
Solidity documentation release 0.6.4 :<br/>
*“A blockchain is a globally shared, transactional database. This means that everyone can read entries in the database
just by participating in the network”* p. 10<br/>
*“Everything you use in a smart contract is publicly visible, even local variables and state variables marked private.
Using random numbers in smart contracts is quite tricky if you do not want miners to be able to cheat.”* p. 153

Ethereum Yellow paper:<br/>
*“Providing random numbers within a deterministic system is, naturally, an impossible task. However, we can approximate with pseudo-random numbers by utilising data which is generally unknowable at the time of transacting. Such data might include the block’s hash, the block’s timestamp and the block’s beneficiary address”.*

In this case, the block number is knowable at the time of transacting. Thus, we can create a contract (Level3_CoinFlipSolution.sol) that computes the right guess and use this value to call the flip function of the CoinFlip contract (before a new block gets mined). Therefore, we are able to guess the right outcome everytime.

### Level 4 Telephone:
Solidity documentation release 0.6.4 :<br/>
*“msg.sender (address payable): sender of the message (current call)”* p. 73<br/>
*“tx.origin (address payable): sender of the transaction (full call chain)”*p. 73 

In other words, tx.origin is the original address that sends a transaction while msg.sender is the current (i.e. last, closest) sender of a message. For instance, assume user/contract A calls contract B which triggers it to call contract C which triggers it to call contract D, we have the following: 










To solve this level, we (the user) will call the function of a malicious contract that will call the changeOwner function of the Telephone contract. Thus, for the Telephone contract: tx.origin (= user’s address)  ≠ msg.sender (= malicious contract’s address). This will allow us to pass the if statement and become the new owner of the contract. 
