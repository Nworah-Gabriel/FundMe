//SPDX-License- Identifier: MIT
pragma solidity ^0.8.13;

/// @title A library for verifying signature
/// @author Nworah Chimzuruoke .G
/// @notice You can use this contract for signature verification
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.

library VerifySignature{
    /// @notice This is the main function that verifies the cryptographic signature using the signed hash, address of the signer and the message signed.
    /// @param _signer The address of the signature owner
    /// @param _message The message embeddedin the signature
    /// @param _sig The cryptographic signature in bytes
    /// @return confirmation The boolean value indicating if the address is the true signer
    function verify(address _signer, string memory _message, bytes memory _sig) internal pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    /// @notice A function for hashing a message using Keccak256 algorithm
    /// @param _message The message to be hashed
    /// @return HashedMessage The digest of the hashed message
    function getMessageHash(string memory _message) internal pure returns (bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    /// @notice A function for hashing a hashed message using Keccak256 algorithm
    /// @param _messageHash The hashed message
    /// @return HashedMessage The digest of the pointer to the hashed message
    function getEthSignedMessageHash(bytes32 _messageHash) internal pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
            ));
    }

    /// @notice A function for recovering the address of the true signature owner
    /// @param _ethSignedMessageHash The hashed message
    /// @param _sig The cryptographic digital signature in bytes
    /// @return Address The address of the signature owner
    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) internal pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = _splitSignature(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    /// @notice A function for splitting the cryptographic signature
    /// @param _sig The cryptographic digital signature in bytes
    function _splitSignature(bytes memory _sig)internal pure returns (bytes32 r, bytes32 s, uint8 v){
        require(_sig.length == 65, "Invalid signature length");

        assembly{
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }


}