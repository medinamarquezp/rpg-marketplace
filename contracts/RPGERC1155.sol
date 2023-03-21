// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RPGItems.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract RPGERC1155 is ERC1155, RPGItems {
    address internal owner;

    constructor() ERC1155("") {
        owner = msg.sender;
        _mint(msg.sender, _GoldCoinId, 1000, "");
        _Items[_GoldCoinId].units -= 1000;
    }

    function getGoldenCoinId() external view returns (uint256) {
        return _Items[_GoldCoinId].id;
    }

    function getGoldenCoinUnits() external view returns (uint256) {
        return _Items[_GoldCoinId].units;
    }

    function getLastItemId() external view returns (uint256) {
        return _currentItemId();
    }

    function getItem(uint256 _itemId) external view returns (Item memory) {
        return _Items[_itemId];
    }

    function decrementGoldenCoins(
        uint256 _units
    ) external onlyowner returns (uint256) {
        require(
            _units <= _Items[_GoldCoinId].units,
            "Not enough units to decrease"
        );
        _Items[_GoldCoinId].units -= _units;
        return _Items[_GoldCoinId].units;
    }

    function mint(
        uint256 _itemId,
        uint256 _total
    ) external onlyowner returns (bool) {
        require(_itemId > 0 && _itemId <= _currentItemId(), "Invalid item Id");
        require(_total <= _Items[_itemId].units, "Not enough items to mint");
        _mint(msg.sender, _itemId, _total, "");
        _Items[_itemId].units -= _total;
        return true;
    }

    function drainItem(uint256 _itemId) external onlyowner returns (bool) {
        require(_itemId > 0 && _itemId <= _currentItemId(), "Invalid item Id");
        _Items[_itemId].units = 0;
        return true;
    }

    function supplyItems(
        uint256 _itemId,
        uint256 _total
    ) external onlyowner returns (bool) {
        require(_itemId > 0 && _itemId <= _currentItemId(), "Invalid item Id");
        require(
            _total + _Items[_itemId].units < _Items[_itemId].limit,
            "To much items to supply"
        );
        _Items[_itemId].units += _total;
        return true;
    }

    function addNewItem(
        string memory _name,
        string memory _category,
        uint256 _limit,
        uint256 _price
    ) external onlyowner returns (uint256) {
        uint256 itemId = _getNextItemId();
        _Items[itemId] = Item({
            id: itemId,
            name: _name,
            category: _category,
            units: _limit,
            limit: _limit,
            price: _price
        });
        return itemId;
    }

    modifier onlyowner() {
        require(
            msg.sender == owner,
            "This operation is only available for contract owner"
        );
        _;
    }
}
