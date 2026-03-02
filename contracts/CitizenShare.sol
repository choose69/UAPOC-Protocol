// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract CitizenShare is ERC721, Ownable {
    using ECDSA for bytes32;

    uint256 public totalCitizens;
    mapping(address => bool) public hasClaimed;
    string public constant VERSION = "UAPOC-v0.1-20260302";

    constructor() ERC721("UAPOC Citizen Share", "UAPOC-CS") Ownable(msg.sender) {}

    function claimCitizenShare(address to, bytes calldata signature) external {
        require(!hasClaimed[to], "Already claimed");
        bytes32 hash = keccak256(abi.encodePacked(to, "UAPOC-CITIZEN"));
        require(owner() == hash.recover(signature), "Invalid signature");

        uint256 tokenId = totalCitizens++;
        _safeMint(to, tokenId);
        hasClaimed[to] = true;
    }

    function _beforeTokenTransfer(address from, address to, uint256, uint256) internal override {
        require(from == address(0) || to == address(0), "Soulbound: Non-transferable");
    }

    function getCitizenCount() external view returns (uint256) {
        return totalCitizens;
    }
}
