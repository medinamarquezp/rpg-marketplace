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

  it("Should validate item data", async () => {
    const lastItemId = await instance.getLastItemId();
    const item = await instance.getItem(lastItemId);
    assert.equal(item.id, lastItemId.toString(), "Should validate item ID");
    assert.equal(
      item.name,
      "ProtectiveCharm",
      "Should validate created item name"
    );
    assert.equal(item.category, "charms", "Should validate item category");
    assert.equal(item.limit.toString(), "10", "Should validate item limit");
    assert.equal(item.price.toString(), "1000", "Should validate item price");
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
      "Item limit reached"
    );
    await truffleAssert.fails(
      instance.mint(1, 100, {
        from: accounts[1],
      }),
      truffleAssert.ErrorType.REVERT,
      "This operation is only available for authorized address"
    );
    await instance.mint(1, 100, {
      from: accounts[0],
    });
    const accountBalance = await instance.balanceOf(accounts[0], 1);
    assert.equal(
      accountBalance.toString(),
      "100",
      "Should mint 100 Gold Coins"
    );
  });

  it("Should validate burn action", async () => {
    await truffleAssert.fails(
      instance.burn(999, 1000),
      truffleAssert.ErrorType.REVERT,
      "Invalid item Id"
    );
    await truffleAssert.fails(
      instance.burn(1, 1000000000000),
      truffleAssert.ErrorType.REVERT,
      "Not enough items to burn"
    );
    await truffleAssert.fails(
      instance.burn(1, 100, {
        from: accounts[1],
      }),
      truffleAssert.ErrorType.REVERT,
      "This operation is only available for authorized address"
    );
    await instance.burn(1, 10, {
      from: accounts[0],
    });
    const accountBalance = await instance.balanceOf(accounts[0], 1);
    assert.equal(accountBalance.toString(), "90", "Should burn 10 Gold Coins");
  });
});
