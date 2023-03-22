require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

const { SIGNER_PRIVATE_KEY, POLYGON_SCAN_API_KEY, POLYGON_MUMBAI_TESTNET_RPC } =
  process.env;

module.exports = {
  api_keys: {
    polygonscan: POLYGON_SCAN_API_KEY,
  },
  networks: {
    mumbai: {
      provider: () =>
        new HDWalletProvider(SIGNER_PRIVATE_KEY, POLYGON_MUMBAI_TESTNET_RPC),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },

  // Set default mocha options here, use special reporters, etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.19",
    },
  },
};
