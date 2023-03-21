const truffleAssert = require("truffle-assertions");
const RPGERC1155 = artifacts.require("RPGERC1155");

contract("RPGERC1155 tests", (accounts) => {
  let instance;

  before(async () => {
    instance = await RPGERC1155.deployed();
  });

  it("Should validate Gold Coin ID", async () => {
    const result = await instance.getGoldenCoinId();
    assert.equal(result.toString(), "1", "Golden Coin ID should be 1");
  });

  it("Should validate Gold Coin units", async () => {
    const result = await instance.getGoldenCoinUnits();
    assert.equal(
      result.toString(),
      "999999000",
      "Golden Coin initial balance should be 999999000"
    );
  });

  it("Should validate decrement Gold Coin action", async () => {
    await truffleAssert.fails(
      instance.decrementGoldenCoins(1000000000000),
      truffleAssert.ErrorType.REVERT,
      "Not enough units to decrease"
    );
    await instance.decrementGoldenCoins(9000);
    const result = await instance.getGoldenCoinUnits();
    assert.equal(
      result.toString(),
      "999990000",
      "Should decrement 9000 Gold Coins"
    );
  });

  it("Should validate mint action", async () => {
    await truffleAssert.fails(
      instance.mint(999, 1000),
      truffleAssert.ErrorType.REVERT,
      "Invalid item Id"
    );
    await truffleAssert.fails(
      instance.mint(1, 1000000000000),
      truffleAssert.ErrorType.REVERT,
      "Not enough items to mint"
    );
    await truffleAssert.fails(
      instance.mint(1, 100, {
        from: accounts[1],
      }),
      truffleAssert.ErrorType.REVERT,
      "This operation is only available for contract owner"
    );
    await instance.mint(1, 100, {
      from: accounts[0],
    });
    const accountBalance = await instance.balanceOf(accounts[0], 1);
    assert.equal(
      accountBalance.toString(),
      "1100",
      "Should increment 100 Gold Coins to account balance"
    );
    const tokensBalance = await instance.getGoldenCoinUnits();
    assert.equal(
      tokensBalance.toString(),
      "999989900",
      "Should decrement 100 Gold Coins to tokens balance"
    );
  });

  it("Should validate drain item action", async () => {
    await truffleAssert.fails(
      instance.drainItem(999),
      truffleAssert.ErrorType.REVERT,
      "Invalid item Id"
    );
    await truffleAssert.fails(
      instance.drainItem(1, {
        from: accounts[1],
      }),
      truffleAssert.ErrorType.REVERT,
      "This operation is only available for contract owner"
    );
    await instance.drainItem(1);
    const tokensBalance = await instance.getGoldenCoinUnits();
    assert.equal(
      tokensBalance.toString(),
      "0",
      "Should drain Golden Coins units"
    );
  });

  it("Should validate supply items action", async () => {
    await truffleAssert.fails(
      instance.supplyItems(999, 10),
      truffleAssert.ErrorType.REVERT,
      "Invalid item Id"
    );
    await truffleAssert.fails(
      instance.supplyItems(1, 10, {
        from: accounts[1],
      }),
      truffleAssert.ErrorType.REVERT,
      "This operation is only available for contract owner"
    );
    await truffleAssert.fails(
      instance.supplyItems(1, 1000000000000),
      truffleAssert.ErrorType.REVERT,
      "To much items to supply"
    );
    await instance.supplyItems(1, 1000);
    const tokensBalance = await instance.getGoldenCoinUnits();
    assert.equal(
      tokensBalance.toString(),
      "1000",
      "Should supply 1000 Golden Coins"
    );
  });

  it("Should validate add new item to marketplace action", async () => {
    await truffleAssert.fails(
      instance.addNewItem("Test item", "test", 10, 100, {
        from: accounts[1],
      }),
      truffleAssert.ErrorType.REVERT,
      "This operation is only available for contract owner"
    );
    await instance.addNewItem("Test item", "test", 10, 100);
    const createdItemId = await instance.getLastItemId();
    const item = await instance.getItem(createdItemId);
    assert.equal(
      item.id,
      createdItemId.toString(),
      "Should validate created item ID"
    );
    assert.equal(item.name, "Test item", "Should validate created item name");
    assert.equal(
      item.category,
      "test",
      "Should validate created item category"
    );
    assert.equal(
      item.limit.toString(),
      "10",
      "Should validate created item limit"
    );
    assert.equal(
      item.units.toString(),
      "10",
      "Should validate created item units"
    );
    assert.equal(
      item.price.toString(),
      "100",
      "Should validate created item price"
    );
  });
});
