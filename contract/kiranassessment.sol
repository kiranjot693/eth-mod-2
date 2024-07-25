// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

contract kiranssessment {  
    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event AdditionResult(uint256 result); 
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event FundsTransferred(address indexed to, uint256 amount);
    
    mapping(address => uint256) public balanceOf;
    mapping(address => address) public ownerOf;  
    
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    function getBalanceFromWalletAddress(address walletAddress) public view returns(uint256) {
        return balanceOf[walletAddress];
    }
    
    function depositAmount(uint256 _amount) public payable {
        uint _previousBalance = balanceOf[msg.sender];
        balanceOf[msg.sender] += _amount;
        assert(balanceOf[msg.sender] == _previousBalance + _amount);
        emit Deposit(_amount);
    }

    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdrawAmount(uint256 _withdrawAmount) public {
        uint _previousBalance = balanceOf[msg.sender];
        if (balanceOf[msg.sender] < _withdrawAmount) {
            revert InsufficientBalance({
                balance: _previousBalance,
                withdrawAmount: _withdrawAmount
            });
        }
        balanceOf[msg.sender] -= _withdrawAmount;
        assert(balanceOf[msg.sender] == (_previousBalance - _withdrawAmount));
        emit Withdraw(_withdrawAmount);
    }
    
    function checkBalance() public view returns(uint256) {
        return balanceOf[msg.sender];
    }

    function ownerName() public pure returns(string memory) {
        return "Kiran jot";
    }

    function ownerCity() public pure returns(string memory) {
        return "Mohali";
    }
        
    function ownerStatus() public pure returns(string memory) {
        return "Eligible Owner";
    }

    function changeOwner(address payable newOwner) public {
        require(newOwner != address(0), "New owner address cannot be zero");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnerChanged(oldOwner, newOwner);
    }

    function transferFunds(address payable to, uint256 amount) public {
        require(to != address(0), "Cannot transfer to zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (address(this).balance < amount) {
            revert InsufficientBalance({
                balance: address(this).balance,
                withdrawAmount: amount
            });
        }

        (bool success, ) = to.call{value: amount}("");
        require(success, "Transfer failed");

        emit FundsTransferred(to, amount);
    }
}

