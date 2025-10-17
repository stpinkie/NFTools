// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title NFTools
/// @author Daniel "St. Pinkie" Anthony
/// @notice A collection of functions to reference whether wallets hold NFTs
/// @dev A collection of read functions to simplify working with ERC1155 and ERC721 NFTs
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
        address contract721
    ) public view returns (uint256) {
        return IERC721(contract721).balanceOf(holder);
    }

    function detect1155ByTokenId(
        address holder,
        address contract1155,
        uint256 tokenId
    ) public view returns (uint256) {
        return IERC1155(contract1155).balanceOf(holder, tokenId);
    }

    function detect1155InWallet(
        address holder,
        address contract1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (bool) {
        bool hasNFT = false;
        for (uint256 i = firstTokenId; i <= lastTokenId; ++i) {
            if (IERC1155(contract1155).balanceOf(holder, i) > 0) {
                hasNFT = true;
                break;
            }
        }
        return hasNFT;
    }

    function countUnique1155InWallet(
        address holder,
        address contract1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (uint256) {
        uint256 uniqueCount = 0;
        for (uint256 i = firstTokenId; i <= lastTokenId; ++i) {
            if (IERC1155(contract1155).balanceOf(holder, i) > 0) {
                ++uniqueCount;
            }
        }
        return uniqueCount;
    }

    /// @dev This experimental function aims to detect how many sets of NFTs someone has on an ERC1155 contact, if a user is required to have one of each tokenId, for instance.

    function count1155SeriesInWallet(
        address holder,
        address contract1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (uint256) {
        uint256 setCount;
        uint256 countUnique;
            for (uint256 s = 1; countUnique == 12; ++s) {
                countSymbols = 0;
                for (uint256 i = 1; i <= 12; ++i) {
                    if (IERC1155(contract1155).balanceOf(holder, i) > s) {
                        ++countUnique;
                    }
                }
                setCount = s;
            return setCount;
        }
    }

    function count1155SetsInWallet(
        address holder,
        address contract1155,
        uint256[] setTokens
    ) {
        
    }

    function countTotal1155InWallet(
        address holder,
        address contract1155,
        uint256 firstTokenId,
        uint256 lastTokenId
    ) public view returns (uint256) {
        uint256 totalCount = 0;
        for (uint256 i = firstTokenId; i <= lastTokenId; ++i) {
            if (IERC1155(contract1155).balanceOf(holder, i) > 0) {
                totalCount = totalCount + IERC1155(contract1155).balanceOf(holder, i);
            }
        }
        return totalCount;
    }

    
}
