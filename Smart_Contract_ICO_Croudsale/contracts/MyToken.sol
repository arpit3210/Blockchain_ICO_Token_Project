
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }
}


// // Compatible with OpenZeppelin Contracts ^5.0.0
// pragma solidity ^0.8.19;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

// contract MyToken is ERC20, ERC20Burnable, Ownable, ERC20Permit {
//     constructor(address initialOwner)
//         ERC20("MyToken", "MTK")
//         Ownable(initialOwner)
//         ERC20Permit("MyToken")
//     {
//         _mint(msg.sender, 1000000000000 * 10 ** decimals());
//     }

//     function mint(address to, uint256 amount) public onlyOwner {
//         _mint(to, amount);
//     }
// }