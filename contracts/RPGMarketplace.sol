// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RPGERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract RPGMarketplace is ERC1155Holder {
    address private owner;
    RPGERC1155 private nftContract;

    constructor(address _nftContract) {
        owner = msg.sender;
        nftContract = RPGERC1155(_nftContract);
    }

    function drainItem(uint256 _itemId) public onlyowner returns (bool) {
        require(nftContract.isValidItemId(_itemId), "Invalid item Id");
        uint256 itemUnits = nftContract.getItemUnits(_itemId);
        require(itemUnits > 0, "Item without units");
        nftContract.burn(_itemId, itemUnits);
        return true;
    }

    function supplyItems(
        uint256 _itemId,
        uint256 _total
    ) public onlyowner returns (bool) {
        nftContract.mint(_itemId, _total);
        return true;
    }

    modifier onlyowner() {
        require(
            msg.sender == owner,
            "This operation is only available for authorized address"
        );
        _;
    }
}
