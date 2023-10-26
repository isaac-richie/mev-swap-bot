// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the ERC20 interface
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";


contract Airdrop is Pausable {
    address public owner;
    IERC20 public token; // The ERC20 token to be distributed
  
    uint256 public tokenAmount; // Amount of tokens to be distributed
    bool public claimIsPaused;    

    mapping(address => bool) public claimed;

    event TokensClaimed(address indexed user, uint256 amount);

    constructor(
       // address _tokenAddress,
        //uint256 _tokenAmount
   
    ) {
        owner = msg.sender;
        token = IERC20(0x25f3697Fdc4A735FAd454412014E706A470aA0B6);
        tokenAmount = 10000000000000000000000;
       
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the ownercan perform this action");
        _;
    }

       function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function editClaimWindow(
        bool _claimIsPaused
    ) public onlyOwner {
        claimIsPaused = _claimIsPaused;
    }

    function claimTokens() external payable {
        require(claimIsPaused, "claim is paused");
        require(!claimed[msg.sender], "Tokens already claimed");
        require(msg.value == 0.2 ether, "Please send the correct amount of ETH");

        claimed[msg.sender] = true;
        token.transfer(msg.sender, tokenAmount);

        emit TokensClaimed(msg.sender, tokenAmount);
    }

    function withdrawFunds() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }


    function destroy(address apocalypse) public onlyOwner {      
    		selfdestruct(payable(apocalypse));
    }
   
    
    
}
