const path = require("path");
require('dotenv').config();
var devNetworkHost = process.env["DEV_NETWORK"];
var apiKey = process.env["API_KEY"];
var mnemonic = process.env["MNEMONIC"];
var HDWalletProvider = require("truffle-hdwallet-provider");

config = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    rinkeby: {
      host: "localhost",
      provider: function () {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/" + apiKey);
      },
      network_id: 4,
      gas: 6700000,
      gasPrice: 10000000000
    },
    develop: {
      port: 8545
    },
  },
  mocha: {
    reporter: 'xunit',
    reporterOptions: {
      output: 'TEST-results.xml'
    }
  }
};

// Using this code I can default to using the built in test
// network but define a dev
// Network in my CI system without breaking a developer inner loop.
if (devNetworkHost) {
  config.networks["development"] = {
    host: devNetworkHost,
    port: 8545,
    network_id: '*'
  };
}

module.exports = config;