// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Counters.sol";

contract RPGItems {
    using Counters for Counters.Counter;
    struct Item {
        uint256 id;
        string name;
        string category;
        uint256 units;
        uint256 limit;
        uint256 price;
    }
    uint256 internal _GoldCoinId;
    Counters.Counter internal _ItemId;
    mapping(uint256 => Item) internal _Items;

    constructor() {
        _ItemId.increment();
        _GoldCoinId = _ItemId.current();
        _initItems();
    }

    function _currentItemId() internal view returns (uint256) {
        return _ItemId.current();
    }

    function _getNextItemId() internal returns (uint256) {
        _ItemId.increment();
        return _ItemId.current();
    }

    function _initItems() private {
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "coins",
            name: "Gold coins",
            units: 1000000000,
            limit: 1000000000,
            price: 0
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "weapons",
            name: "Trident",
            units: 1000,
            limit: 1000,
            price: 2
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "weapons",
            name: "Fauchard",
            units: 500,
            limit: 500,
            price: 4
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "weapons",
            name: "Corsesca",
            units: 500,
            limit: 500,
            price: 8
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "shields",
            name: "LeatherShield",
            units: 500,
            limit: 500,
            price: 10
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "shields",
            name: "DragonShield",
            units: 200,
            limit: 200,
            price: 15
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "shields",
            name: "RelicShield",
            units: 50,
            limit: 50,
            price: 100
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "armors",
            name: "LeatherArmor",
            units: 120,
            limit: 120,
            price: 60
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "armors",
            name: "Bridandine",
            units: 75,
            limit: 75,
            price: 80
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "armors",
            name: "SacredLeatherArmor",
            units: 25,
            limit: 25,
            price: 150
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "charms",
            name: "StrengthCharm",
            units: 100,
            limit: 100,
            price: 250
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "charms",
            name: "MagicCharm",
            units: 50,
            limit: 50,
            price: 500
        });
        _ItemId.increment();
        _Items[_ItemId.current()] = Item({
            id: _ItemId.current(),
            category: "charms",
            name: "ProtectiveCharm",
            units: 10,
            limit: 10,
            price: 1000
        });
    }
}
