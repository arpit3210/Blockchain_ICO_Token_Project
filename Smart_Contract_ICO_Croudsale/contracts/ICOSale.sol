// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ICOSale {
    using SafeMath for uint256;

    address public admin;
    IERC20 public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;
    uint256 public fundingGoal;
    uint256 public startTime;
    uint256 public endTime;
    bool public saleOpen;

    mapping(address => uint256) public tokenBalance;
    
    event Sell(address indexed buyer, uint256 amount);

    constructor(
        address _tokenAddress,
        uint256 _tokenPrice,
        uint256 _fundingGoal,
        uint256 _startTime,
        uint256 _duration
    ) {
        admin = msg.sender;
        tokenContract = IERC20(_tokenAddress);
        tokenPrice = _tokenPrice;
        fundingGoal = _fundingGoal;
        startTime = _startTime;
        endTime = startTime.add(_duration);
        saleOpen = true;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyWhileOpen() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Sale is not active");
        require(saleOpen, "Sale is not open");
        _;
    }

    function buyTokens(uint256 _numberOfTokens) public payable onlyWhileOpen {
        uint256 totalPrice = _numberOfTokens.mul(tokenPrice);
        require(msg.value == totalPrice, "Incorrect ether value sent");

        tokenBalance[msg.sender] = tokenBalance[msg.sender].add(_numberOfTokens);
        tokensSold = tokensSold.add(_numberOfTokens);

        emit Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public onlyAdmin {
        require(block.timestamp >= endTime || tokensSold >= fundingGoal, "Sale is still active and goal not reached");

        if (tokensSold >= fundingGoal) {
            uint256 balance = address(this).balance;
            payable(admin).transfer(balance);
        }

        saleOpen = false;
    }
}
