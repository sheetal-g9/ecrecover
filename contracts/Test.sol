pragma solidity >=0.4.21 <0.7.0;

contract Test {

  function verify(bytes32  documentHash, uint8[] memory sigV, bytes32[] memory sigR, bytes32[] memory sigS) public {
    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 prefixedProof = keccak256(abi.encodePacked(prefix, documentHash));
    address recovered = ecrecover(prefixedProof, sigV[0], sigR[0], sigS[0]);
    emit LogSignature(documentHash, prefixedProof, recovered);
  }

  event LogSignature (
    bytes32 docHash,
    bytes32 proof,
    address signer
  );
}
