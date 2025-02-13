// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

///////////////////
// Imports
///////////////////

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./VerifyRandVRF.sol";

///////////////////
// Contract: VerifyRandVRFFactory
///////////////////

/**
 * @title VerifyRandVRFFactory
 * @dev A contract for creating clones (proxy contracts) of the VerifyRandVRF contract.
 * This factory contract enables the deployment of proxy contracts with the VerifyRandVRF implementation.
 */
contract VerifyRandVRFFactory {
    /////////////////////
    // Events
    /////////////////////

    /**
     * @dev Emitted when a new proxy contract is created.
     * @param mintProxyAddress The address of the newly created proxy contract.
     */
    event ProxyCreated(address mintProxyAddress);

    /////////////////////
    // Public Functions
    /////////////////////

    /**
     * @dev Creates a proxy contract for the VerifyRandVRF contract.
     * The proxy contract is initialized with the sender address and a verifyRand address.
     * @param implementation The address of the VerifyRandVRF implementation contract.
     * @param verifyRandAddress The address of the verifyRand contract for fulfilling random words.
     * @return mintProxyAddress The address of the newly created proxy contract.
     */
    function createProxy(address implementation, address verifyRandAddress) external returns (address) {
        // Create a new proxy contract using Clones.clone() method
        address mintProxyAddress = Clones.clone(implementation);

        // Initialize the newly created proxy with the sender's address and verifyRand address
        VerifyRandVRF(mintProxyAddress).initialize(msg.sender, verifyRandAddress);

        // Emit event to notify about the creation of the new proxy contract
        emit ProxyCreated(mintProxyAddress);

        // Return the address of the newly created proxy contract
        return mintProxyAddress;
    }
}
