pragma solidity ^0.6.7;

contract Privacy {
  bool public locked = true;
  address public owner;
  bytes32 private key = '123';
  bytes32 private firstPassword = 'qwerty';
  struct Password{
      uint256 id;
      bytes32 password;
      bytes32 notRelevant;
  } 
  bytes32 private password2 = 'password';
  Password[] passwords;
  mapping(bytes32 => bytes32) passwordMapping;
  
  constructor(bytes32 _firstPassword, bytes32 _secondPassword ) public {
    owner = msg.sender;
    passwords.push(Password({
                id: 0,
                password: firstPassword,
                notRelevant: _firstPassword
            }));
    passwordMapping[key] = _secondPassword;
  }

  function unlock(bytes32 _firstPassword, bytes32 _secondPassword) public {
    require(_firstPassword == passwords[0].notRelevant && _secondPassword == passwordMapping[key]);
    locked = false;
  }
  
  
  /*
             ___                                      ___
_____     __| _/__  _______    ____   ____  ____   __| _/
\__  \   / __ |\  \/ /\__  \  /    \_/ ___\/ __ \ / __ | 
 / __ \_/ /_/ | \   /  / __ \|   |  \  \__\  ___// /_/ | 
(_____ /\_____|  \_/  (_____ /___|_ /\____ >____ >_____| 
 
              __   __     ___ __  __          
  __________ |  | |__| __| _/|__|/  |_ ___ __ 
 /  ___/  _ \|  | |  |/ __ | |  \   __<   |  |
 \___ (  <_> )  |_|  / /_/ | |  ||  |  \___  |
/____  >____/|____/__\____ | |__||__|  / ____|
     
        __                        __  __   __                             
_____  |  |    ____   ___________|__|/  |_|  |__   _____   ______         
\__  \ |  |   / ___\ /  _ \_  __ \  \   __\  |  \ /     \ /  ___/         
 / __ \|  |__/ /_/  >  <_> )  | \/  ||  | |   Y  \  Y Y  \\___ \          
(_____ /____/\___  / \____/|__|  |__||__| |___| _/__|_| _/____ _> 
            /_____/                          
  */
}






