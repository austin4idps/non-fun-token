// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SphereMetaToken is ERC20 {
    constructor() ERC20("Shpere Meta Token", "SMT") {
        // do nothing
        _mint(msg.sender, 10000 * 1000 * 10 ** 18);
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
