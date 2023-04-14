//contracts/FlashLoan.sol
//SPDX-License-Identifier: MIT

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

pragma solidity 0.8.10;

contract Dex{
    address payable public owner;
    // Token contract address on Gorali Testnet AAVE
    address private immutable diaAddress = 0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464;
    address private immutable usdcAddress = 0xA2025B15a1757311bfD68cb14eaeFCc237AF5b43;

    IERC20 private dia;
    IERC20 private usdc;

    // Exchange Rate Indexes
    uint256 dexARate = 90;
    uint256 dexBRate = 100;

    // keep track of individuals balance of DIA
    mapping(address => uint256) public diaBalances;
    // keep track of individuals balance of USDC
    mapping(address => uint256) public usdcBalances;    
    
    constructor(){
        owner = payable(msg.sender);
        dia = IERC20(diaAddress);
        usdc = IERC20(usdcAddress);
    }
    function depoistDIA(uint256 _amount) external {
        diaBalances[msg.sender] += _amount;
        uint256 allowance = dia.allowance(msg.sender, address(this));
        require( allowance >= _amount, " check the Token allowance");
        dia.transferFrom(msg.sender, address(this), _amount);
    }
    function depoistUSDC(uint256 _amount) external {
        usdcBalances[msg.sender] += _amount;
        uint256 allowance = usdc.allowance(msg.sender, address(this));
        require( allowance >= _amount, " check the Token allowance");
        usdc.transferFrom(msg.sender, address(this), _amount);
    }
    // Buy DIA on DexA with minium price of DIA and transfer to msg.sender
    function buyDai() external {
        uint256 diaToReceive = ((usdcBalances[msg.sender] / dexARate)* 100 ) * (10**12);
        dia.transfer(msg.sender, diaToReceive);
    }
    // Sell DIA on DexB with Higer Price of DIA 
    function sellDai() external {
        uint256 usdcToReceive = (( diaBalances[msg.sender]* dexBRate)/100)/ (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }
    // ******** Getter Function ************

    function getBalance(address _tokenAddress)external view returns(uint256){
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require( msg.sender == owner, " Only Owner can call this function" );
        _;
    }

    receive() external payable {}   // this rece

}