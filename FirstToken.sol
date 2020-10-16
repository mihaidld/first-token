// SPDX-License-Identifier: MIT                 r
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

/// @title A blockchain token smart contract 
/// @author Mihai Doldur
/// @notice Try to buy some tokens, 1 token is 1 ether 
/// @dev All function calls are currently implemented without side effects

/*
To get the exercice link : 
1. created a file ExoLink.sol
2. added same content code as mentioned in the file and compiled it, 
3. verified that my account was on the same testnet Rinkeby, 
4. added the address mentioned next to At Address to access the smart contract WHEREARETHEEXERCICES already deployed at that address, 
5. clicked on At Address
6. clicked to call the function getExoLink which returned the URL with the exercices
*/

contract FirstToken {
    //state variables
    /// @notice balances keeps the record of numbers of tokens owned by each address
    /// @dev balances is public and keeps the record of numbers of tokens owned by each address
    /// @notice investors keeps the record if an address is set by the ownner of the contract as an investor (true) or not (false)
    /// @dev investors is public and keeps the record if an address is set by the ownner of the contract as an investor (true) or not (false)
    /// @dev wallet is the address of the contract owner passed as argument to constructor function at deployment
    mapping(address => uint256) public balances;
    mapping(address => bool) public investors;
    address payable wallet;

    //events
    event Purchase(
        address indexed _buyer,
        uint256 _amount
    );

    //modifiers
    /// @dev modifier function to check that only the contract owner can call a function
    modifier onlyOwner (){
        require (msg.sender == wallet, "only owner can call this function");
        _;
    }

    //constructor
    constructor(address payable _wallet) public {
        wallet = _wallet;
    }
    
    //functions
    /// @dev public function calling a modifier condition to add an address among the investors (set to true its corresponding value inside the investors mapping)
    /// @notice only the contrcat owner can add an address
    function setInvestor (address _investor) public onlyOwner{
        investors[_investor] = true;
    }
    
    /// @dev public function calling a modifier condition to remove an address among the investors (set to false its corresponding value inside the investors mapping)
    /// @notice only the contrcat owner can add an address
    function unsetInvestor (address _investor) public onlyOwner{
        investors[_investor] = false;
    }
    
    /// @dev external function payable which handles automatically the receipt of ether inside the contract from user, is called when the amount is sent by the user and calls buyToken function
    receive() external payable {
        buyToken();
    }
    
    /// @dev fallback function to be executed is something is wrong in the transation: in any case transfer money from smart contract (if any) to wallet address
    fallback() external payable {
        wallet.transfer(msg.value);
    }
    
    /// @notice buyToken allows to buy tokens by entering a value of ethers and call function by clicking on red button
    /// @dev buyToken is public and payable and allows to buy tokens by entering a value of ethers and call function by clicking on red button
    function buyToken() public payable {
    /// @dev We suppose that 1 token costs 1 ether and users interested in buying tokens send positive integer number of ethers, need to check if amount of ethers is not positive integer
    
        // 1. buy a token
        /// @dev added condition that amount of ethers is >= 1, if not transaction will fail with an error message. If Ok continue to execute code below
        require (msg. value >= 1 ether, "not enough ethers");
        /// @dev variable multiple gets a value based on a ternary expression depending on the corresponding value of the address inside the investors mapping
        uint multiplier = investors[msg.sender]? 10: 1;
        /// @dev the numbers of tokens corresponding to user address is increased by the amount of ethers sent or by amount of ethers * multiplier
        balances[msg.sender] += msg.value / 1 ether * multiplier;
        
        // 2. send ether from the contract to the wallet
        /// @dev member function transfer of payable address is called with the amount in ethers as argument
        wallet.transfer(msg.value);
        
        // 3. log the number of ethers owned by user in EVM
        /// @dev an event is emitted with the address of the user and number of tokens bought
        emit Purchase(msg.sender, msg.value / 1 ether * multiplier);
    }
}