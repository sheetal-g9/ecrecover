const Web3 = require('web3');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*"       // Any network (default: none)
    },

    kaleido: {
      provider: () => {
        return new Web3.providers.HttpProvider(process.env.ETH_URL);
      },
      network_id: "*",
      gasPrice: 0
    }
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      // version: "0.5.1",    // Fetch exact version from solc-bin (default: truffle's version)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    }
  }
}
