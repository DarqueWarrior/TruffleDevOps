const path = require("path");
require('dotenv').config();
var devNetworkHost = process.env["DEV_NETWORK"];

config = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
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