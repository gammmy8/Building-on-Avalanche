// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    // Event to log the redemption of tokens
    event TokensRedeemed(address indexed redeemer, uint256 amount, string item);

    // Mapping of item names to their token cost
    mapping(string => uint256) public itemPrices;

    constructor() ERC20("Degen Token", "DGT") Ownable(msg.sender) {
        // Initialize the contract owner
        _mint(msg.sender, 1000000 * 0 ** decimals());
    }

    // Function to set the price of items in the in-game store
    function setItemPrice(string memory itemName, uint256 price) external onlyOwner {
        itemPrices[itemName] = price;
    }

    // Minting new tokens: Only the owner can mint tokens
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        _mint(to, amount);
    }

    // Burning tokens: Owner can burn tokens from any address
    function burn(address from, uint256 amount) external onlyOwner {
        require(from != address(0), "Cannot burn from zero address");
        require(balanceOf(from) >= amount, "Insufficient balance to burn");
        _burn(from, amount);
    }

    // Redeeming tokens for in-game items
    function redeemTokens(string memory itemName) external {
        uint256 price = itemPrices[itemName];
        require(price > 0, "Item not found");
        require(balanceOf(msg.sender) >= price, "Insufficient balance to redeem item");
        
        _burn(msg.sender, price);
        emit TokensRedeemed(msg.sender, price, itemName);
    }
}
