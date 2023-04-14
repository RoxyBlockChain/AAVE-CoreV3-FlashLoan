// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase{

    address payable owner;
    constructor(address _addressProvider) 
    FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {

    owner = payable(msg.sender);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium
        //address initiator,
        // bytes calldata params
        ) external /*override*/ returns (bool) {
        // at this point we have borrowed fro AAVE
        // Custom Logic can be applied, like uniswap, SushiSwap, Sell ERC20, Buy ERC20, perform arbitrage
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
        }

    function requestFlashLoan(address _token, uint256 _amount) external{
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
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

    receive() external payable {}   // this receive function to make contract receivable of ETHs in any case.
}
