// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RPGERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract RPGMarketplace is ERC1155Holder {
    address private owner;
    RPGERC1155 private nftContract;

    constructor(address _nftContract) {
        nftContract = RPGERC1155(_nftContract);
    }

    function buyGoldenCoins(uint256 _amount) external payable {
        // Validación fondos golden coins
        require(
            _amount <= nftContract.getGoldenCoinUnits(),
            "Not available coins to sell"
        );
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
        // Decremento de unidades golden coins
        nftContract.decrementGoldenCoins(_amount);
        // Transferencia de NFT
        nftContract.safeTransferFrom(
            address(this),
            msg.sender,
            nftContract.getGoldenCoinId(),
            _amount,
            ""
        );
    }
}
