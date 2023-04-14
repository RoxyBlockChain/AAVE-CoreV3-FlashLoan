// contracts/FlashLoan.sol
// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";

interface IDex {
    function depositDIA(uint256 _amount) external;
    function depositUSDC(uint256 _amount) external;
    function buyDia() external;
    function sellDia() external;    
}

contract FlashLoan is FlashLoanSimpleReceiverBase{

    address payable owner;
        // Token contract address on Gorali Testnet AAVE
    address private immutable diaAddress = 0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464;
    address private immutable usdcAddress = 0xA2025B15a1757311bfD68cb14eaeFCc237AF5b43;
    address private immutable dexContractAddress = 0xD6e8c479B6B62d8Ce985C0f686D39e96af9424df; // need to change with your own Dex Contract address

    IERC20 private dia;
    IERC20 private usdc;
    IDex private dexContract;

    constructor(address _addressProvider) 
    FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {
    owner = payable(msg.sender);
    dia = IERC20(diaAddress);
    usdc = IERC20(usdcAddress);
    dexContract = IDex(dexContractAddress);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium
        //address initiator,
        // bytes calldata params
        ) external /*override*/ returns (bool) {

        // Arbitrage Operation
        dexContract.depositUSDC(1000000000); // USDC 1000 its 6 digit currency
        dexContract.buyDia();
        dexContract.depositDIA(dia.balanceOf(address(this)));
        dexContract.sellDia();
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
