// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice The executables used in ffi commands. These are set here
///         to have a single source of truth in case absolute paths
///         need to be used.
library Executables {
    string internal constant jq    = "jq";
    string internal constant sed   = "sed";
    string internal constant bash  = "bash";
    string internal constant cast  = "cast";
    string internal constant echo  = "echo";
    string internal constant dapp  = "dapp";
    string internal constant seth  = "seth";
    string internal constant forge = "forge";
}
