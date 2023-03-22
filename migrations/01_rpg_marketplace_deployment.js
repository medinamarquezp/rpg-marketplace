const RPGERC1155 = artifacts.require("RPGERC1155");
const RPGMarketplace = artifacts.require("RPGMarketplace");

module.exports = async function (deployer) {
  await deployer.deploy(RPGERC1155);
  const rpgERC1155 = await RPGERC1155.deployed();
  await deployer.deploy(RPGMarketplace, rpgERC1155.address);
  const marketplace = await RPGMarketplace.deployed();
  await rpgERC1155.authorize(marketplace.address, true);
};
