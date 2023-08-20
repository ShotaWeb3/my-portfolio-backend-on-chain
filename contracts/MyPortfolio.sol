// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyPortfolio is ERC721 {

    constructor() ERC721("MyPortfolio", "MyPortfolio") {}
    /**
    * Create NewNFT
    */
    function nftMint() public {

    }
}
