// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/// @dev User application custom configuration.
/// @param oracle Oracle contract address.
/// @param relayer Relayer contract address.
struct UC {
    address oracle;
    address relayer;
}

/// @title UserConfig
/// @notice User config could select their own relayer and oracle.
/// The default configuration is used by default.
/// @dev Only setter could set default user config.
contract UserConfig {
    /// @dev Setter address.
    address public setter;
    /// @dev Default user config.
    UC public defaultUC;
    /// @dev ua => uc.
    mapping(address => UC) public ucOf;

    /// @dev Notifies an observer that the default user config has updated.
    /// @param oracle Default oracle.
    /// @param relayer Default relayer.
    event DefaultConfigUpdated(address oracle, address relayer);
    /// @dev Notifies an observer that the user application config has updated.
    /// @param ua User application contract address.
    /// @param oracle Oracle which the user application choose.
    /// @param relayer Relayer which the user application choose.
    event AppConfigUpdated(address indexed ua, address oracle, address relayer);
    /// @dev Notifies an observer that the setter is changed.
    /// @param oldSetter Old setter address.
    /// @param newSetter New setter address.
    event SetterChanged(address indexed oldSetter, address indexed newSetter);

    modifier onlySetter() {
        require(msg.sender == setter, "!auth");
        _;
    }

    constructor(address dao) {
        setter = dao;
    }

    /// @dev Change setter.
    /// @notice Only current setter could call.
    /// @param newSetter New setter.
    function changeSetter(address newSetter) external onlySetter {
        address oldSetter = setter;
        setter = newSetter;
        emit SetterChanged(oldSetter, newSetter);
    }

    /// @dev Set default user config for all user application.
    /// @notice Only setter could call.
    /// @param oracle Default oracle.
    /// @param relayer Default relayer.
    function setDefaultConfig(address oracle, address relayer) external onlySetter {
        defaultUC = UC(oracle, relayer);
        emit DefaultConfigUpdated(oracle, relayer);
    }

    /// @notice Set user application config.
    /// @param oracle Oracle which user application.
    /// @param relayer Relayer which user application choose.
    function setAppConfig(address oracle, address relayer) external {
        ucOf[msg.sender] = UC(oracle, relayer);
        emit AppConfigUpdated(msg.sender, oracle, relayer);
    }

    /// @dev Fetch user application config.
    /// @notice If user application has not configured, then the default user config is used.
    /// @param ua User application contract address.
    /// @return user application config.
    function getAppConfig(address ua) public view returns (UC memory) {
        UC memory c = ucOf[ua];

        if (c.relayer == address(0x0)) {
            c.relayer = defaultUC.relayer;
        }

        if (c.oracle == address(0x0)) {
            c.oracle = defaultUC.oracle;
        }

        return c;
    }
}
