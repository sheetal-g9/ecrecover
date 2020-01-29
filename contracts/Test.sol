pragma solidity >=0.4.21 <0.7.0;

contract Test {

  function verify(bytes32  documentHash, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 prefixedProof = keccak256(abi.encodePacked(prefix, documentHash));
    address recovered = ecrecover(prefixedProof, sigV, sigR, sigS);
    emit LogSignature(documentHash, prefixedProof, recovered);
  }

  event LogSignature (
    bytes32 docHash,
    bytes32 proof,
    address signer
  );
}
