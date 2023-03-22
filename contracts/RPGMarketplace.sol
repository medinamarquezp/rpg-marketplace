// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RPGERC1155.sol";
import {Item} from "./SharedEntities.sol";
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

    function buyGoldenCoins(uint256 _amount) public payable returns (bool) {
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
        return true;
    }

    function buyItems(
        uint256 _itemId,
        uint256 _quantity
    ) public returns (bool) {
        // Validación item existe
        require(nftContract.isValidItemId(_itemId), "Invalid item Id");
        // Validación items disponibles
        uint256 itemUnits = nftContract.getItemUnits(_itemId);
        require(_quantity <= itemUnits, "Not available items to sell");
        // Validación saldo tokens Gold Coin
        Item memory item = nftContract.getItem(_itemId);
        uint256 requiredGoldCoins = item.price * _quantity;
        uint256 glodCoinBalance = nftContract.balanceOf(
            msg.sender,
            nftContract.getGoldenCoinId()
        );
        require(
            glodCoinBalance >= requiredGoldCoins,
            string.concat(
                "This transaction requires ",
                Strings.toString(requiredGoldCoins),
                " Gold Coins."
            )
        );
        // Cobro del total Gold Coins
        nftContract.authorizeBuyer(msg.sender);
        nftContract.safeTransferFrom(
            msg.sender,
            address(this),
            nftContract.getGoldenCoinId(),
            requiredGoldCoins,
            ""
        );
        // Transferencia de items
        nftContract.safeTransferFrom(
            address(this),
            msg.sender,
            _itemId,
            _quantity,
            ""
        );
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
