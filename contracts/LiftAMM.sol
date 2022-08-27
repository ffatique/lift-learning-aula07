// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LiftAMM { 
    uint256 public totalSupply;
    mapping(address => uint256) public balance; 

    address public tokenA;
    address public tokenB;
    constructor(address _tokenA, address _tokenB)  {  
        tokenA = _tokenA;
        tokenB = _tokenB;   
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

        require(totalSupply * amountA / balanceA == totalSupply * amountB / balanceB, "Wrong proportion between asset A and B");

        liquidity = squareRoot(amountA * amountB);
        totalSupply += liquidity;
        balance[msg.sender] += liquidity;        
    }

    function removeLiquidity(uint256 liquidity) external returns (uint256 amountA, uint256 amountB) {   
        require(balance[msg.sender] >= liquidity, "Not enough liquidity for this, amount too big"); 
        uint256 balanceA = IERC20(tokenA).balanceOf(address(this));
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this));         

        uint divisor = totalSupply / liquidity;
        amountA = balanceA / divisor;
        amountB = balanceB / divisor;

        totalSupply -= liquidity;
        balance[msg.sender] -= liquidity;  

        IERC20(tokenA).transfer(msg.sender, amountA);
        IERC20(tokenB).transfer(msg.sender, amountB); 
    }

    function swap(address tokenIn, uint256 amountIn) external returns (uint256 amountOut) {
        uint256 newBalance;
        require(tokenIn == tokenA || tokenIn == tokenB, "TokenIn not in pool");        

        uint256 balanceA = IERC20(tokenA).balanceOf(address(this)); // X
        uint256 balanceB = IERC20(tokenB).balanceOf(address(this)); // Y

        uint256 k = balanceA * balanceB; // K = X * Y   

        if (tokenIn == tokenA) {
            IERC20(tokenA).transferFrom(msg.sender, address(this), amountIn);
            newBalance = k / (balanceA + amountIn);
            amountOut = balanceB - newBalance;            
            IERC20(tokenB).transfer(msg.sender, amountOut);
        }
        else {
            IERC20(tokenB).transferFrom(msg.sender, address(this), amountIn);
            newBalance = k / (balanceB + amountIn);
            amountOut = balanceA - newBalance;
            IERC20(tokenA).transfer(msg.sender, amountOut);
        }      
    }
}