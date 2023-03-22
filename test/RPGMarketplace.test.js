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
});
