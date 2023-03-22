const truffleAssert = require("truffle-assertions");
const RPGERC1155 = artifacts.require("RPGERC1155");
const RPGMarketplace = artifacts.require("RPGMarketplace");

contract("RPGMarketplace tests", (accounts) => {
  let nft, marketplace;

  before(async () => {
    nft = await RPGERC1155.deployed();
    marketplace = await RPGMarketplace.deployed();
  });

  it("Should supply items to marketplace contract", async () => {
    await marketplace.supplyItems(1, 100);
    const accountBalance = await nft.balanceOf(marketplace.address, 1);
    assert.equal(
      accountBalance.toString(),
      "100",
      "Should supply 100 Gold Coins to marketplace"
    );
  });

  it("Should supply items to marketplace contract", async () => {
    await marketplace.drainItem(1);
    const accountBalance = await nft.balanceOf(accounts[0], 1);
    assert.equal(
      accountBalance.toString(),
      "0",
      "Should drain all Gold Coin units"
    );
  });

  it("Should buy Golden Coins", async () => {
    await marketplace.supplyItems(1, 1000);
    await truffleAssert.fails(
      marketplace.buyGoldenCoins(1000000000000),
      truffleAssert.ErrorType.REVERT,
      "Not available coins to sell"
    );
    await truffleAssert.fails(
      marketplace.buyGoldenCoins(12),
      truffleAssert.ErrorType.REVERT,
      "Amount must be multiple of 10"
    );
    await truffleAssert.fails(
      marketplace.buyGoldenCoins(10),
      truffleAssert.ErrorType.REVERT,
      "This transaction costs 100000000000000000 MATIC"
    );
    await marketplace.buyGoldenCoins(10, {
      from: accounts[1],
      value: web3.utils.toWei(".1", "ether"),
    });
    const accountBalance = await nft.balanceOf(accounts[1], 1);
    assert.equal(
      accountBalance.toString(),
      "10",
      "Account balance should be 10"
    );
    const marketplaceBalance = await nft.balanceOf(marketplace.address, 1);
    assert.equal(
      marketplaceBalance.toString(),
      "990",
      "Marketplace balance should be 990"
    );
  });
});
