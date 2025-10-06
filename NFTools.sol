// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title NFTools
/// @author Daniel "St. Pinkie" Anthony
/// @notice A collection of functions to reference whether wallets hold NFTs
/// @dev This contract really shouldn't need to exist - but because of proxy contracts and other Solidity fuckery, this contract will query ERC721 and ERC1155 contracts to help with Galxe quests among other things.
/// @custom:limitation As there is no way I know of to deterministically or conclusively determine the number of tokenIDs an ERC1155 contract will have, the params of this function relies on the known tokenIDs.

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256);
}

interface IERC1155 {
    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);
}

contract NFTools {
    function detect721(
        address holder,
        address proxy721
    ) public view returns (uint256) {
        return IERC721(proxy721).balanceOf(holder);
    }

    function detect1155ByTokenId(
        address holder,
        address proxy1155,
        uint256 tokenId
    ) public view returns (uint256) {
        return IERC1155(proxy1155).balanceOf(holder, tokenId);
    }

    function detect1155InWallet(
        address holder,
        address proxy1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (bool) {
        bool hasNFT = false;
        for (uint256 i = firstTokenId; i < lastTokenId; ++i) {
            if (IERC1155(proxy1155).balanceOf(holder, i) > 0) {
                hasNFT = true;
                break;
            }
        }
        return hasNFT;
    }

    function countUnique1155InWallet(
        address holder,
        address proxy1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (uint256) {
        uint256 uniqueCount = 0;
        for (uint256 i = firstTokenId; i < lastTokenId; ++i) {
            if (IERC1155(proxy1155).balanceOf(holder, i) > 0) {
                ++uniqueCount;
            }
        }
        return uniqueCount;
    }

    function countTotal1155InWallet(
        address holder,
        address proxy1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (uint256) {
        uint256 totalCount = 0;
        for (uint256 i = firstTokenId; i < lastTokenId; ++i) {
            if (IERC1155(proxy1155).balanceOf(holder, i) > 0) {
                totalCount = totalCount + IERC1155(proxy1155).balanceOf(holder, i);
            }
        }
        return totalCount;
    }

    
}
