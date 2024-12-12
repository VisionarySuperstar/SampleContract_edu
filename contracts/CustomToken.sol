// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; // Import Ownable for access control

contract henlo is ERC20, Ownable {
    // Constructor to initialize the token with a name and symbol
    constructor() ERC20("henlo", "HENLO") Ownable(msg.sender) {
        // Mint an initial supply of tokens to the deployer
        _mint(msg.sender, 10000000000 * 10 ** decimals());
    }

    // Override the decimals function to return 18
    function decimals() public view override returns (uint8) {
        return 18;
    }

    /**
     * @dev Mint new tokens to a specified account.
     * Only the owner can mint new tokens.
     * @param account The address to receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "Mint to the zero address");
        _mint(account, amount);
    }

    /**
     * @dev Burn tokens from a specified account.
     * Only the owner can burn tokens from accounts.
     * @param account The address from which to burn tokens.
     * @param amount The amount of tokens to burn.
     */
    function burn(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "Burn from the zero address");
        _burn(account, amount);
    }
}
