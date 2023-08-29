// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";

contract OnRandomURIKeccak is ERC721URIStorage, Ownable {

    /**
    * @dev
    * 色の構造体を定義
    */
    struct Color {
        string name;
        string code;
    }

    Color[] public colors;
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

    /**
    * @dev
    * 配列変数にカラーを設定
    */
    constructor() ERC721("OnRandomURIKeccak", "ONK") {
        colors.push(Color("Yellow","#ffff00"));
        colors.push(Color("Whitesmoke","#f5f5f5"));
        colors.push(Color("Blue","#0000ff"));
        colors.push(Color("Pink","#ffc0cb"));
        colors.push(Color("Green","#008000"));
        colors.push(Color("Gold","#FFD700"));
        colors.push(Color("Purple","#800080"));
        colors.push(Color("Light Green","#90EE90"));
        colors.push(Color("Orange","#FFA500"));
        colors.push(Color("Gray","#808080"));
    }

    /**
    * @dev
    * - このコントラクトをデプロイしたアドレスだけがmintを可能 onlyOwner
    * - tokenIdをインクリメントします　　_tokenIds.increment()
    * - nftmint関数の実行アドレスにtokenIdを紐づけ
    * - mintの際にURIを設定
    * - EVENT発火 emit TokenURIChanged
    */
    function nftMint() public onlyOwner {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        bytes32 hashed = keccak256(abi.encodePacked(newTokenId, block.timestamp));
        Color memory color = colors[uint256(hashed) % colors.length];

        string memory imageData = _getImage(color.code);
        
        bytes memory metaData = abi.encodePacked(
            '{"name": "',
            'MyCHainNFT # ',
            Strings.toString(newTokenId),
            '", "description": "My Frist On ChainNFTs!!!",',
            '"image": "data:image/svg+xml;base64,',
            Base64.encode(bytes(imageData)),
            '"}'
        );

        string memory uri = string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(metaData))));
        _mint(_msgSender(), newTokenId);
        _setTokenURI(newTokenId, uri);

        emit TokenURIChanged(_msgSender(), newTokenId, uri);
    }

    /**
    * @dev
    * - 引数で渡されるカラーコードを指定したSVGをかえす
    */
    function _getImage(string memory colorCode) internal pure returns (string memory){
        return (
            string(
                abi.encodePacked(
                    '<svg  viewBox="0 0 350 350" fill="none" xmlns="http://www.w3.org/2000/svg">',
                    '<polygon points="50 175, 175 50, 300 175, 175 300" stroke="green"  fill="',
                    colorCode,
                    '" />',
                    '</svg>'
                )
            )
        );
    }
}
