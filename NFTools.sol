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

    struct Contract1155 {
        address holder;
        address contract1155;
        uint256 firstTokenId;
        uint256 lastTokenId;
    }

    function detect1155ByTokenId(
        address holder,
        address contract1155,
        uint256 tokenId
    ) public view returns (uint256) {
        return IERC1155(contract1155).balanceOf(holder, tokenId);
    }

    function detect1155InWallet(Contract1155 memory userContract) public view returns (bool) {
        bool hasNFT = false;
        for (uint256 i = userContract.firstTokenId; i <= userContract.lastTokenId; ++i) {
            if (IERC1155(userContract.contract1155).balanceOf(userContract.holder, i) > 0) {
                hasNFT = true;
                break;
            }
        }
        return hasNFT;
    }

    function countUnique1155InWallet(Contract1155 memory userContract) public view returns (uint256) {
        uint256 uniqueCount = 0;
        for (uint256 i = userContract.firstTokenId; i <= userContract.lastTokenId; ++i) {
            if (IERC1155(userContract.contract1155).balanceOf(userContract.holder, i) > 0) {
                ++uniqueCount;
            }
        }
        return uniqueCount;
    }

    /// @dev These experimental functions aim to detect how many sets of NFTs someone has on an ERC1155 contact, if a user is required to have one of each tokenId.

    function count1155SetsInWallet(
        address holder,
        address contract1155,
        uint256[] calldata setTokens
    ) public view returns (uint256) {
        uint256 minBalance = type(uint256).max;
        for (uint256 i = 0; i < setTokens.length; i++) {
            uint256 balance = IERC1155(contract1155).balanceOf(holder, setTokens[i]);
            if (balance < minBalance) minBalance = balance;
        }
        if (minBalance == type(uint256).max) {
            return 0;
        } else {
            return minBalance;
        }
    }

    function count1155SeriesInWallet(Contract1155 memory userContract) public view returns (uint256) {
        uint256 minBalance = type(uint256).max;
        for (uint256 i = userContract.firstTokenId; i <= userContract.lastTokenId; ++i) {
            uint256 balance = IERC1155(userContract.contract1155).balanceOf(userContract.holder, i);
            if (balance < minBalance) minBalance = balance;
        }
        if (minBalance == type(uint256).max) {
            return 0;
        } else {
            return minBalance;
        }
    }

    function countTotal1155InWallet(Contract1155 memory userContract) public view returns (uint256) {
        uint256 totalCount = 0;
        for (uint256 i = userContract.firstTokenId; i <= userContract.lastTokenId; ++i) {
            if (IERC1155(userContract.contract1155).balanceOf(userContract.holder, i) > 0) {
                totalCount = totalCount + IERC1155(userContract.contract1155).balanceOf(userContract.holder, i);
            }
        }
        return totalCount;
    }

    
    /// @dev These functions try to return an inventory of a users' NFTs to reduce NFT API usage costs

    function tokenIdInventory(Contract1155 memory userContract) public view returns (uint256[] memory inventoryIds) {
        uint256 inventorySize = countUnique1155InWallet(userContract);
        uint256[] memory idsPresent = new uint256[](inventorySize);
        uint256 arrayPos = 0;
        for (uint256 i = userContract.firstTokenId; i <= userContract.lastTokenId; ++i) {
            if (IERC1155(userContract.contract1155).balanceOf(userContract.holder, i) > 0) {
                idsPresent[arrayPos] = i;
                ++arrayPos;
            }
        }
        return inventoryIds;
    }

    function tokenInventoryCount(Contract1155 memory userContract) public view returns (uint256[] memory inventoryCounts) {
        uint256 totalTokenIds = (userContract.lastTokenId - userContract.firstTokenId);
        uint256[] memory inventoryTokenCounts = new uint256[](totalTokenIds);
        uint256 counterIndex = 0;
        for (uint256 i = userContract.firstTokenId; i <= userContract.lastTokenId; ++i) {
            inventoryTokenCounts[counterIndex] = IERC1155(userContract.contract1155).balanceOf(userContract.holder, i);
            ++counterIndex;
        }
        return (inventoryTokenCounts);
    }
    
}