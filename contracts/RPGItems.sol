// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Item} from "./SharedEntities.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract RPGItems {
    using Counters for Counters.Counter;
    uint256 internal goldCoinId;
    Counters.Counter internal itemId;
    mapping(uint256 => Item) internal items;

    constructor() {
        itemId.increment();
        goldCoinId = itemId.current();
        initItems();
    }

    function currentItemId() internal view returns (uint256) {
        return itemId.current();
    }

    function getNextItemId() internal returns (uint256) {
        itemId.increment();
        return itemId.current();
    }

    function initItems() private {
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "coins",
            name: "Gold coins",
            limit: 1000000000,
            price: 0
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "weapons",
            name: "Trident",
            limit: 1000,
            price: 2
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "weapons",
            name: "Fauchard",
            limit: 500,
            price: 4
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "weapons",
            name: "Corsesca",
            limit: 500,
            price: 8
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "shields",
            name: "LeatherShield",
            limit: 500,
            price: 10
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "shields",
            name: "DragonShield",
            limit: 200,
            price: 15
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "shields",
            name: "RelicShield",
            limit: 50,
            price: 100
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "armors",
            name: "LeatherArmor",
            limit: 120,
            price: 60
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "armors",
            name: "Bridandine",
            limit: 75,
            price: 80
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "armors",
            name: "SacredLeatherArmor",
            limit: 25,
            price: 150
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "charms",
            name: "StrengthCharm",
            limit: 100,
            price: 250
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "charms",
            name: "MagicCharm",
            limit: 50,
            price: 500
        });
        itemId.increment();
        items[itemId.current()] = Item({
            id: itemId.current(),
            category: "charms",
            name: "ProtectiveCharm",
            limit: 10,
            price: 1000
        });
    }
}
