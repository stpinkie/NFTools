// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// This contract's functionality has been integrated into NFTools.sol

/// @title 1155 NFT Checker
/// @author Daniel "St. Pinkie" Anthony
/// @notice This contract checks whether an address is holding an ERC1155 NFT with any tokenID from a particular contract.
/// @dev This contract really shouldn't need to exist - but because Galxe's contract query requires a return of 1 or 0 to determine if someone has met a certain credential, this contract was designed to parse the ZKcandy Sugar Rush ERC1155 contract to determine whether a wallet is holding a Candy NFT or not.
/// @custom:limitation As there is no way I know of to deterministically or conclusively determine the number of tokenIDs an ERC1155 contract will have, the params of this function relies on the known tokenIDs.

contract Has1155NFT {

    /// @dev The function to check whether an address is holding a 1155 NFT from a particular contract.
    /// @param firstTokenID The first tokenID to begin searching. Most contracts start from 0 but some prefer to start from 1.
    /// @param lastTokenID The total number of tokenIDs on the ERC1155 contract (or upper limit of your search).
    /// @dev Total tokenIDs on an ERC1155 contract may not be discernable as an ERC1155 contract could potentially have unlimited tokenIDs.
    /// @param nftContract The address of the ERC1155 contract being queried.1
    /// @param checkAddress Check whether this address has minted any of the NFTs on the ERC1155 contract.
    /// @return The function returns a 1 if an NFT within the search parameters is owned by the address queried - and a 0 if not.

    function check1155 (uint256 firstTokenID, uint256 lastTokenID, address nftContract, address checkAddress) public view returns (uint256) {
        bool hasNFT = false;
        for (uint256 i = firstTokenID; i < lastTokenID; ++i) {
            if (ERC1155(nftContract).balanceOf(checkAddress, i) > 0) {
                hasNFT = true;
                break;
            }
        } if (hasNFT == true) return 1; else return 0;
    }

}