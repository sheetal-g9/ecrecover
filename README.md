# ecrecover
Sample Solidity and node.js code demonstrating the trickery involved in ecrecover when testing against testrpc/Ganache vs. geth/Quorum nodes

## Pre-reqs

Node.js: https://nodejs.org/en/download/
Truffle: https://www.trufflesuite.com/docs/truffle/getting-started/installation

## Run and Test

First install the minimal dependencies and configure the target Ethereum node:

```
npm i
export ETH_URL=<full URL of your Kaleido node like https://username:password@envId-nodeId-rpc.kaleido.io>
```

To test against testrpc or Ganache using the default network

```
truffle test
```

To test against a Kaleido network

```
truffle test --network kaleido
```

## Important Details

The test script uses `eth.sign()` method that is not universally supported, which can cause confusions when developing with Kaleido.

`testrpc` and Ganache returns `00` or `01` for the V value portion of the signature. So `27` must be added in order to calculate the correct value.

Geth/Quorum both returns the V value according to the ecrecover technique, with 27 already added.

| Protocol | `eth.sign()` supported?  | To calculate V value from returned signature |
|---|---|---|
| Geth | Yes | `web3.utils.toDecimal("0x" + sig.slice(130, 132))` |
| Quorum | Yes | `web3.utils.toDecimal("0x" + sig.slice(130, 132))` |
| Besu | No |  |
| testrpc | Yes | `web3.utils.toDecimal("0x" + sig.slice(130, 132)) + 27` |
| Ganache | Yes | `web3.utils.toDecimal("0x" + sig.slice(130, 132)) + 27` |


## Sample output:

```
Using network 'kaleido'.


Compiling your contracts...
===========================
> Compiling ./contracts/Test.sol



  Contract: Test
    verify()
      ✓ deploys the Test contract (3602ms)
docHash:  0xd81c6c15bb6cbed0dcfb5dcb918302e0a3021e062f3eb157b3be0aa7d6500930
signing with account: 0xea4CE501fa8b7a77486F0b8B53C25346415228E4
Signature: 0x7e7424ae9aa49eab6e480661e236f9ba974b701a67b42e39638cbb23b7fe5e4960ad936aee388bb59d8d18a03d7ce1bbc783ff01703217f44b6e4b090ce8ff7e1b
Seems to be in a Kaleido network, V is already calculated
V: 0x1b, R: 0x7e7424ae9aa49eab6e480661e236f9ba974b701a67b42e39638cbb23b7fe5e49, S: 0x60ad936aee388bb59d8d18a03d7ce1bbc783ff01703217f44b6e4b090ce8ff7e
{
  tx: '0xc35f83c944a4897b39c24299484e841ab7b8097cd553d4309d3078fedbcf0f6e',
  receipt: {
    blockHash: '0xe1c0d9513fbba5ea9a9ddd0e96a9f7927622aef00414321c5d472f7415ee2d85',
    blockNumber: 234051,
    contractAddress: null,
    cumulativeGasUsed: 36520,
    from: '0xea4ce501fa8b7a77486f0b8b53c25346415228e4',
    gasUsed: 36520,
    logs: [ [Object] ],
    logsBloom: '0x00000000000000000000000000000000000000000000100000000000000000000000000000000000000000000020100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000',
    status: true,
    to: '0xbf37994ef18281b83bb516f84a1dd6472c7756f9',
    transactionHash: '0xc35f83c944a4897b39c24299484e841ab7b8097cd553d4309d3078fedbcf0f6e',
    transactionIndex: 0,
    rawLogs: [ [Object] ]
  },
  logs: [
    {
      address: '0xbf37994EF18281b83BB516F84a1Dd6472c7756F9',
      blockNumber: 234051,
      transactionHash: '0xc35f83c944a4897b39c24299484e841ab7b8097cd553d4309d3078fedbcf0f6e',
      transactionIndex: 0,
      blockHash: '0xe1c0d9513fbba5ea9a9ddd0e96a9f7927622aef00414321c5d472f7415ee2d85',
      logIndex: 0,
      removed: false,
      id: 'log_0eb0822f',
      event: 'LogSignature',
      args: [Result]
    }
  ]
}
{
  address: '0xbf37994EF18281b83BB516F84a1Dd6472c7756F9',
  blockNumber: 234051,
  transactionHash: '0xc35f83c944a4897b39c24299484e841ab7b8097cd553d4309d3078fedbcf0f6e',
  transactionIndex: 0,
  blockHash: '0xe1c0d9513fbba5ea9a9ddd0e96a9f7927622aef00414321c5d472f7415ee2d85',
  logIndex: 0,
  removed: false,
  id: 'log_0eb0822f',
  returnValues: Result {
    '0': '0xd81c6c15bb6cbed0dcfb5dcb918302e0a3021e062f3eb157b3be0aa7d6500930',
    '1': '0x4fe11d27b43b92b44cf127a899b692f8f703017d97a9ef45d4ca0f7981e7cd8f',
    '2': '0xea4CE501fa8b7a77486F0b8B53C25346415228E4',
    docHash: '0xd81c6c15bb6cbed0dcfb5dcb918302e0a3021e062f3eb157b3be0aa7d6500930',
    proof: '0x4fe11d27b43b92b44cf127a899b692f8f703017d97a9ef45d4ca0f7981e7cd8f',
    signer: '0xea4CE501fa8b7a77486F0b8B53C25346415228E4'
  },
  event: 'LogSignature',
  signature: '0x7d09bd6d32ad8f98124780a688b8ec5143e4ab9a73595bcb8ed2411dc55586cf',
  raw: {
    data: '0xd81c6c15bb6cbed0dcfb5dcb918302e0a3021e062f3eb157b3be0aa7d65009304fe11d27b43b92b44cf127a899b692f8f703017d97a9ef45d4ca0f7981e7cd8f000000000000000000000000ea4ce501fa8b7a77486f0b8b53c25346415228e4',
    topics: [
      '0x7d09bd6d32ad8f98124780a688b8ec5143e4ab9a73595bcb8ed2411dc55586cf'
    ]
  },
  args: Result {
    '0': '0xd81c6c15bb6cbed0dcfb5dcb918302e0a3021e062f3eb157b3be0aa7d6500930',
    '1': '0x4fe11d27b43b92b44cf127a899b692f8f703017d97a9ef45d4ca0f7981e7cd8f',
    '2': '0xea4CE501fa8b7a77486F0b8B53C25346415228E4',
    __length__: 3,
    docHash: '0xd81c6c15bb6cbed0dcfb5dcb918302e0a3021e062f3eb157b3be0aa7d6500930',
    proof: '0x4fe11d27b43b92b44cf127a899b692f8f703017d97a9ef45d4ca0f7981e7cd8f',
    signer: '0xea4CE501fa8b7a77486F0b8B53C25346415228E4'
  }
}
      ✓ returns proper address recovered from the signature (5437ms)


  2 passing (11s)
```
