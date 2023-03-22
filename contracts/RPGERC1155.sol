// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RPGItems.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract RPGERC1155 is ERC1155, RPGItems {
    address private owner;
    mapping(address => bool) private authorized;
    mapping(address => mapping(uint256 => uint256)) private itemUnits;

    constructor() ERC1155("") {
        owner = msg.sender;
    }

    function getGoldenCoinId() public view returns (uint256) {
        return goldCoinId;
    }

    function getLastItemId() public view returns (uint256) {
        return currentItemId();
    }

    function getItem(uint256 _itemId) public view returns (Item memory) {
        require(isValidItemId(_itemId), "Invalid item Id");
        return items[_itemId];
    }

    function getItemUnits(uint256 _itemId) public view returns (uint256) {
        return itemUnits[msg.sender][_itemId];
    }

    function isValidItemId(uint256 _itemId) public view returns (bool) {
        return _itemId > 0 && _itemId <= getLastItemId();
    }

    function authorizeBuyer(
        address _buyerAddress
    ) external onlyauthorized returns (bool) {
        _setApprovalForAll(_buyerAddress, msg.sender, true);
        return true;
    }

    function authorize(
        address _address,
        bool _status
    ) external onlyauthorized returns (bool) {
        authorized[_address] = _status;
        setApprovalForAll(_address, _status);
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
            limit: _limit,
            price: _price
        });
        return itemId;
    }

    function mint(
        uint256 _itemId,
        uint256 _total
    ) external onlyauthorized returns (bool) {
        require(isValidItemId(_itemId), "Invalid item Id");
        uint256 units = itemUnits[msg.sender][_itemId];
        require(_total + units < items[_itemId].limit, "Item limit reached");
        _mint(msg.sender, _itemId, _total, "");
        itemUnits[msg.sender][_itemId] += _total;
        return true;
    }

    function burn(
        uint256 _itemId,
        uint256 _total
    ) external onlyauthorized returns (bool) {
        require(isValidItemId(_itemId), "Invalid item Id");
        uint256 units = itemUnits[msg.sender][_itemId];
        require(_total <= units, "Not enough items to burn");
        _burn(msg.sender, _itemId, _total);
        itemUnits[msg.sender][_itemId] -= _total;
        return true;
    }

    modifier onlyauthorized() {
        require(
            msg.sender == owner || authorized[msg.sender],
            "This operation is only available for authorized address"
        );
        _;
    }
}
