// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RPGItems {
    struct Item {
        uint256 id;
        string name;
        string category;
        uint256 units;
        uint256 limit;
        uint256 price;
    }
    uint256 internal _GoldCoinId;
    uint256 internal _ItemId;
    mapping(uint256 => Item) internal _Items;

    constructor() {
        _GoldCoinId = 1;
        _initItems();
        _ItemId = 13;
    }

    function _getNextItemId() internal returns (uint256) {
        _ItemId += 1;
        return _ItemId;
    }

    function _initItems() private {
        _Items[1] = Item({
            id: 1,
            category: "coins",
            name: "Gold coins",
            units: 1000000000,
            limit: 1000000000,
            price: 0
        });
        _Items[2] = Item({
            id: 2,
            category: "weapons",
            name: "Trident",
            units: 1000,
            limit: 1000,
            price: 2
        });
        _Items[3] = Item({
            id: 3,
            category: "weapons",
            name: "Fauchard",
            units: 500,
            limit: 500,
            price: 4
        });
        _Items[4] = Item({
            id: 4,
            category: "weapons",
            name: "Corsesca",
            units: 500,
            limit: 500,
            price: 8
        });
        _Items[5] = Item({
            id: 5,
            category: "shields",
            name: "LeatherShield",
            units: 500,
            limit: 500,
            price: 10
        });
        _Items[6] = Item({
            id: 6,
            category: "shields",
            name: "DragonShield",
            units: 200,
            limit: 200,
            price: 15
        });
        _Items[7] = Item({
            id: 7,
            category: "shields",
            name: "RelicShield",
            units: 50,
            limit: 50,
            price: 100
        });
        _Items[8] = Item({
            id: 8,
            category: "armors",
            name: "LeatherArmor",
            units: 120,
            limit: 120,
            price: 60
        });
        _Items[9] = Item({
            id: 9,
            category: "armors",
            name: "Bridandine",
            units: 75,
            limit: 75,
            price: 80
        });
        _Items[10] = Item({
            id: 10,
            category: "armors",
            name: "SacredLeatherArmor",
            units: 25,
            limit: 25,
            price: 150
        });
        _Items[11] = Item({
            id: 11,
            category: "charms",
            name: "StrengthCharm",
            units: 100,
            limit: 100,
            price: 250
        });
        _Items[12] = Item({
            id: 12,
            category: "charms",
            name: "MagicCharm",
            units: 50,
            limit: 50,
            price: 500
        });
        _Items[13] = Item({
            id: 13,
            category: "charms",
            name: "ProtectiveCharm",
            units: 10,
            limit: 10,
            price: 1000
        });
    }
}
