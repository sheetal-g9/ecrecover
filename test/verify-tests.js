const Test = artifacts.require('Test.sol');

contract('Test', (accounts) => {
  let test, chainId;

  beforeEach(async () => {
    chainId = await web3.eth.net.getId();
  });

  describe('verify()', () => {
    it('deploys the Test contract', async () => {
      test = await Test.new();
    });

    it('returns proper address recovered from the signature', async () => {
      let msg =  '0xfde74fc7c82251ce19ded6fa9357044e8a75b5bd5665626efa976b11776c8533';
      let docHash = web3.utils.sha3(msg)
      console.log(`docHash:  ${docHash}`);
      console.log(`signing with account: ${accounts[0]}`);

      let sig = await web3.eth.sign(docHash, accounts[0]);
      console.log(`Signature: ${sig}`);

      let R = `0x${sig.slice(2, 66)}`
      let S = `0x${sig.slice(66, 130)}`
      let V;
      if (chainId > 10000) {
        // not scientific, but Kaleido chain IDs tend to be a really large number
        console.log('Seems to be in a Kaleido network, V is already calculated');
        V = `0x${sig.slice(130, 132)}`;
      }  else {
        console.log('Seems to be in testrpc or Ganache, need to calculate V');
        V = web3.utils.toDecimal(`0x${sig.slice(130, 132)}`)  + 27;
      }

      console.log(`V: ${V}, R: ${R}, S: ${S}`);

      let result = await test.verify(docHash, [V], [R], [S]);
      console.log(result);

      const blockNumber = result.receipt.blockNumber;

      const events = await test.getPastEvents("allEvents", {fromBlock: blockNumber, toBlock: blockNumber});
      expect(events.length).to.equal(1);
      console.log(events[0]);
      expect(events[0].event).to.equal('LogSignature');
      expect(events[0].returnValues.signer.toLowerCase()).to.equal(accounts[0].toLowerCase());
    });
  });
});
