// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMyPortfolio is ERC721 {

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレス用変数
    */
    address public owner;

    constructor() ERC721("OnlyOwnerMyPortfolio", "OWNER") {
        owner = _msgSender();
    }

    /**
    　* @dev
    * - このコントラクトをデプロイしたアドレスだけがmintを可能 require
    * - nftmint関数の実行アドレスにtokenIdを紐づけ
    */
    function nftMint(uint256 tokenId) public {
        require(owner == _msgSender(), "Caller is not the owner.");
        _mint(_msgSender(), tokenId);
    }
}
