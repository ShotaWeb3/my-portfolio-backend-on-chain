// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";

contract  PausableNFT is ERC721Pausable, ERC721URIStorage, Ownable {

    /**
    * @dev
    * - _tokenIdsはCountersの全関数が利用可能です
    */
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
    * URI設定時にだれがどのトークンIDになんのURIを設定したか記録する
    */
    event TokenURIChanged(address indexed sender, uint256 indexed tokenId, string uri);

    constructor() ERC721("PausableNFT", "PAUSE") {}

    /**
    * @dev
    * - このコントラクトをデプロイしたアドレスだけがmintを可能 onlyOwner
    * - tokenIdをインクリメントします　　_tokenIds.increment()
    * - nftmint関数の実行アドレスにtokenIdを紐づけ
    * - mintの際にURIを設定
    * - EVENT発火 emit TokenURIChanged
    */
    function nftMint() public onlyOwner whenNotPaused() {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(_msgSender(), newTokenId);

        string memory jsonFile = string(abi.encodePacked('metadata', Strings.toString(0), '.json'));
        _setTokenURI(newTokenId, jsonFile);
        emit TokenURIChanged(_msgSender(), newTokenId, jsonFile);
    }

    /**
    * @dev
    * - URIプレフィックスの設定
    */
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://bafybeiafzfwoqlrvnrephgqb5dxsnuv45sdgfzetqt6eh5z5ssmijyt4eu/";
    }

    /**
    * @dev
    * - NFT停止
    */
    function pause() public onlyOwner {
        _pause();
    }

    /**
    * @dev
    * - NFT停止解除
    */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
    * @dev
    * - オーバーライド
    */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
    * @dev
    * - オーバーライド
    */
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage)  {
        super._burn(tokenId);
    }

    /**
    * @dev
    * - オーバーライド
    */
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
