// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LIFTAMM {
    constructor(address _tokenA, address _tokenB) {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }
    
    uint256 private _totalSupply;
    mapping(address => uint256) public balance; 

    address public tokenA;
    address public tokenB;
    uint256 public balanceTokenA;
    uint256 public balanceTokenB;
    uint256 public priceSwap;
    uint256 public LiquiditProviderFee = 3;
    uint256 public amountFeeTokenA;
    uint256 public amountFeeTokenB;


    modifier ensure(uint deadline) {
        require(deadline >= block.timestamp, 'TRANSACTION: EXPIRED');
        _;
    }   

    // Raiz quadrada: https://github.com/Uniswap/v2-core/blob/master/contracts/libraries/Math.sol
    function squareRoot(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

  
    function addLiquidity(uint256 amountA, uint256 amountB) external returns (uint256 liquidity) {       
        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);
            
        uint256 balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this));

        require(_totalSupply * amountA / balanceA == _totalSupply * amountB / balanceB, "Wrong proportion between asset A and B");

        liquidity = squareRoot(amountA * amountB);
        _totalSupply += liquidity;
        balance[msg.sender] += liquidity;
        balanceTokenA += balanceA;
        balanceTokenB += balanceB;
        priceSwap = balanceA * balanceB;
    }

    function removeLiquidity(uint256 liquidity) external returns (uint256 amountA, uint256 amountB) {   
        require(balance[msg.sender] >= liquidity, "Not enough liquidity for this, amount too big"); 
        uint256 balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this));    

 

        uint divisor = _totalSupply / liquidity;
        amountA = balanceA / divisor;
        amountB = balanceB / divisor;

        _totalSupply -= liquidity;
        balance[msg.sender] -= liquidity;  

        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB); 
        balanceTokenA -= balanceA;
        balanceTokenB -= balanceB;
        priceSwap = balanceA * balanceB;
    }

    function swap(address tokenIn, uint256 amountIn, uint256 minAmountOut, uint deadline) external ensure(deadline) returns (uint256 amountOut) {
        uint256 newBalance;
        uint256 feeAmount;
        uint256 amountInWithFee;
                                
        require(tokenIn == tokenA || tokenIn == tokenB, "TokenIn not in pool");        

        uint256 balanceA = IERC20(tokenA).balanceOf(address(this)); // X
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this)); // Y

        uint256 k = balanceA * balanceB; // K = X * Y

        if (tokenIn == tokenA) {
            feeAmount = (amountIn * LiquiditProviderFee / 1000);
            amountInWithFee = amountIn + feeAmount;
            IERC20(tokenA).transferFrom(msg.sender, address(this), amountInWithFee);
            newBalance = k / (balanceA + amountIn);
            amountOut = balanceB - newBalance;
            require(amountOut >= minAmountOut, "Minimum quantity exceeded"); 
            IERC20(tokenB).transfer(msg.sender, amountOut);
            amountFeeTokenA += amountInWithFee - amountIn;    
        }

        else {
            feeAmount = (amountIn * LiquiditProviderFee / 1000);
            amountInWithFee = amountIn + feeAmount;
            IERC20(tokenB).transferFrom(msg.sender, address(this), amountInWithFee);
            newBalance = k / (balanceB + amountIn);
            amountOut = balanceA - newBalance;
            require(amountOut >= minAmountOut, "Minimum quantity exceeded"); 
            amountFeeTokenB += amountInWithFee - amountIn;
        }      
    }
}