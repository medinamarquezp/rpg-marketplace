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
        return items[_itemId];
    }

    function getItemUnits(uint256 _itemId) public view returns (uint256) {
        return itemUnits[msg.sender][_itemId];
    }

    function authorize(
        address _address,
        bool _status
    ) external onlyauthorized returns (bool) {
        authorized[_address] = _status;
        setApprovalForAll(_address, _status);
        return true;
    }

    function mint(
        address _address,
        uint256 _itemId,
        uint256 _total
    ) external onlyauthorized returns (bool) {
        require(_itemId > 0 && _itemId <= getLastItemId(), "Invalid item Id");
        uint256 units = itemUnits[_address][_itemId];
        require(_total + units < items[_itemId].limit, "Item limit reached");
        _mint(_address, _itemId, _total, "");
        itemUnits[_address][_itemId] += _total;
        return true;
    }

    function burn(
        address _address,
        uint256 _itemId,
        uint256 _total
    ) external onlyauthorized returns (bool) {
        require(_itemId > 0 && _itemId <= getLastItemId(), "Invalid item Id");
        uint256 units = itemUnits[_address][_itemId];
        require(_total < units, "Not enough items to burn");
        _burn(_address, _itemId, _total);
        itemUnits[_address][_itemId] -= _total;
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
