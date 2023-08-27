// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMyPortfolioWithModifier is ERC721 {

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレス用変数
    */
    address public owner;

    constructor() ERC721("OnlyOwnerMyPortfolioWithModifier", "OWNERMOD") {
        owner = _msgSender();
    }

    /**
     * @dev
     * - このコントラクトをデプロイしたアドレスだけ制御する 
    */
    modifier onlyOwner {
        require(owner == _msgSender(), "Caller is not the owner.");
        _;
    }

    /**
    　* @dev
    * - このコントラクトをデプロイしたアドレスだけがmintを可能 onlyOwner
    * - nftmint関数の実行アドレスにtokenIdを紐づけ
    */
    function nftMint(uint256 tokenId) public onlyOwner {
        _mint(_msgSender(), tokenId);
    }
}
