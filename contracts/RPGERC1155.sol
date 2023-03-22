// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RPGItems.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract RPGERC1155 is ERC1155, RPGItems {
    address private owner;
    mapping(address => bool) private authorized;

    constructor() ERC1155("") {
        owner = msg.sender;
        _mint(msg.sender, goldCoinId, 1000, "");
        items[goldCoinId].units -= 1000;
    }

    function authorize(
        address operator,
        bool status
    ) external onlyauthorized returns (bool) {
        authorized[operator] = true;
        setApprovalForAll(operator, status);
        return true;
    }

    function getGoldenCoinId() public view returns (uint256) {
        return goldCoinId;
    }

    function getGoldenCoinUnits() public view returns (uint256) {
        return items[goldCoinId].units;
    }

    function getLastItemId() public view returns (uint256) {
        return currentItemId();
    }

    function getItem(uint256 _itemId) public view returns (Item memory) {
        return items[_itemId];
    }

    function decrementGoldenCoins(
        uint256 _units
    ) external onlyauthorized returns (uint256) {
        require(
            _units <= items[goldCoinId].units,
            "Not enough units to decrease"
        );
        items[goldCoinId].units -= _units;
        return items[goldCoinId].units;
    }

    function mint(
        uint256 _itemId,
        uint256 _total
    ) external onlyauthorized returns (bool) {
        require(_itemId > 0 && _itemId <= getLastItemId(), "Invalid item Id");
        require(_total <= items[_itemId].units, "Not enough items to mint");
        _mint(msg.sender, _itemId, _total, "");
        items[_itemId].units -= _total;
        return true;
    }

    function drainItem(uint256 _itemId) external onlyauthorized returns (bool) {
        require(_itemId > 0 && _itemId <= getLastItemId(), "Invalid item Id");
        items[_itemId].units = 0;
        return true;
    }

    function supplyItems(
        uint256 _itemId,
        uint256 _total
    ) external onlyauthorized returns (bool) {
        require(_itemId > 0 && _itemId <= getLastItemId(), "Invalid item Id");
        require(
            _total + items[_itemId].units < items[_itemId].limit,
            "To much items to supply"
        );
        items[_itemId].units += _total;
        return true;
    }

    function addNewItem(
        string memory _name,
        string memory _category,
        uint256 _limit,
        uint256 _price
    ) external onlyauthorized returns (uint256) {
        uint256 itemId = getNextItemId();
        items[itemId] = Item({
            id: itemId,
            name: _name,
            category: _category,
            units: _limit,
            limit: _limit,
            price: _price
        });
        return itemId;
    }

    modifier onlyauthorized() {
        require(
            msg.sender == owner || authorized[msg.sender],
            "This operation is only available for authorized address"
        );
        _;
    }
}
