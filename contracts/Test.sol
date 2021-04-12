pragma solidity >=0.4.21 <0.7.0;

contract Test {
    function toAsciiString(address x) internal view returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }
        return string(s);
    }

    function char(bytes1 b) internal view returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    function verify(string memory issuerAddress,
                string memory recipientAddress,
                string memory timestamp, 
                string memory latitude, 
                string memory longitude, 
                uint8 sigV, 
                bytes32 sigR, 
                bytes32 sigS) 
    public {
    string memory msg;
    // msg = string(abi.encodePacked("0x", toAsciiString(issuerAddress)));
    // msg = string("Hare Krishna");
    msg = string(abi.encodePacked(msg, issuerAddress));
    msg = string(abi.encodePacked(msg, recipientAddress));
    msg = string(abi.encodePacked(msg, timestamp));
    msg = string(abi.encodePacked(msg, latitude));
    msg = string(abi.encodePacked(msg, longitude));

    bytes memory prefix = "\x19Ethereum Signed Message:\n32";
    bytes32 documentHash = keccak256(bytes(msg));
    bytes32 prefixedProof = keccak256(abi.encodePacked(prefix, documentHash));
    address recovered = ecrecover(prefixedProof, sigV, sigR, sigS);
    emit LogSignature(msg, documentHash, prefixedProof, recovered);
    }

    event LogSignature (
    string msg,
    bytes32 docHash,
    bytes32 proof,
    address signer
    );
}
