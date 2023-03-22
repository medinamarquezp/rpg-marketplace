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

    function buyGoldenCoins(uint256 _amount) external payable {
        // Validación fondos golden coins
        uint256 goldenCoinUnits = nftContract.getItemUnits(
            nftContract.getGoldenCoinId()
        );
        require(_amount <= goldenCoinUnits, "Not available coins to sell");
        // Validación token enviados
        require(_amount % 10 == 0, "Amount must be multiple of 10");
        uint256 cost = (_amount / 10) * .1 ether;
        require(
            msg.value == cost,
            string.concat(
                "This transaction costs ",
                Strings.toString(cost),
                " MATIC"
            )
        );
        // Transferencia de NFT
        nftContract.safeTransferFrom(
            address(this),
            msg.sender,
            nftContract.getGoldenCoinId(),
            _amount,
            ""
        );
    }

    modifier onlyowner() {
        require(
            msg.sender == owner,
            "This operation is only available for authorized address"
        );
        _;
    }
}
