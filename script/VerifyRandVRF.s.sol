// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VerifyRandVRF} from "../src/VerifyRandVRF.sol";
import {VerifyRandVRFFactory} from "../src/VerifyRandVRFFactory.sol";

contract VerifyRandVRFScript is Script {
    VerifyRandVRF public vrf;
    VerifyRandVRFFactory public vrfFactory;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        vrf = new VerifyRandVRF();
        vrfFactory = new VerifyRandVRFFactory();

        address proxyAddress = vrfFactory.createProxy(address(vrf), msg.sender);

        vm.stopBroadcast();
    }
}
