// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";

contract OffURIUnchangeable is ERC721URIStorage, Ownable {

    constructor() ERC721("OffURIUnchangeable", "OFFU") {}

    /**
    * @dev
    * - このコントラクトをデプロイしたアドレスだけがmintを可能 onlyOwner
    * - nftmint関数の実行アドレスにtokenIdを紐づけ
    * - mintの際にURIを設定
    */
    function nftMint(uint256 tokenId, string calldata uri) public onlyOwner {
        _mint(_msgSender(), tokenId);
        _setTokenURI(tokenId, uri);
    }
}
