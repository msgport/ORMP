// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "../Common.sol";

interface IORMP {
    /// @dev Send a cross-chain message over the endpoint.
    /// @notice follow https://eips.ethereum.org/EIPS/eip-5750
    /// @param toChainId The Message destination chain id.
    /// @param to User application contract address which receive the message.
    /// @param gasLimit Gas limit for destination user application used.
    /// @param encoded The calldata which encoded by ABI Encoding.
    /// @param refund Return extra fee to refund address.
    /// @return Return the hash of the message as message id.
    /// @param params General extensibility for relayer to custom functionality.
    function send(
        uint256 toChainId,
        address to,
        uint256 gasLimit,
        bytes calldata encoded,
        address refund,
        bytes calldata params
    ) external payable returns (bytes32);

    /// @notice Get a quote in source native gas, for the amount that send() requires to pay for message delivery.
    /// @param toChainId The Message destination chain id.
    //  @param ua User application contract address which send the message.
    /// @param gasLimit Gas limit for destination user application used.
    /// @param encoded The calldata which encoded by ABI Encoding.
    /// @param params General extensibility for relayer to custom functionality.
    function fee(uint256 toChainId, address ua, uint256 gasLimit, bytes calldata encoded, bytes calldata params)
        external
        view
        returns (uint256);

    /// @dev Recv verified message and dispatch to destination user application address.
    /// @param message Verified receive message info.
    /// @param proof Message proof of this message.
    /// @return dispatchResult Result of the message dispatch.
    function recv(Message calldata message, bytes calldata proof) external payable returns (bool dispatchResult);

    /// @dev Fetch user application config.
    /// @notice If user application has not configured, then the default config is used.
    /// @param ua User application contract address.
    function getAppConfig(address ua) external view returns (address oracle, address relayer);

    /// @notice Set user application config.
    /// @param oracle Oracle which user application choose.
    /// @param relayer Relayer which user application choose.
    function setAppConfig(address oracle, address relayer) external;

    function defaultUC() external view returns (address oracle, address relayer);

    /// @dev Check the msg if it is dispatched.
    /// @param msgHash Hash of the checked message.
    /// @return Return the dispatched result of the checked message.
    function dones(bytes32 msgHash) external view returns (bool);

    /// @dev Import hash by any oracle address.
    /// @notice Hash is an abstract of the proof system, it can be a block hash or a message root hash,
    ///  		specifically provided by oracles.
    /// @param chainId The source chain id.
    /// @param channel The message channel.
    /// @param msgIndex The source chain message index.
    /// @param hash_ The hash to import.
    function importHash(uint256 chainId, address channel, uint256 msgIndex, bytes32 hash_) external;

    /// @dev Fetch hash.
    /// @param oracle The oracle address.
    /// @param lookupKey The key for loop up hash.
    /// @return Return the hash imported by the oracle.
    function hashLookup(address oracle, bytes32 lookupKey) external view returns (bytes32);
}
