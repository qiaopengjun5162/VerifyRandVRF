// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {VerifyRandVRF} from "../src/VerifyRandVRF.sol";

contract VerifyRandVRFScript is Script {
    VerifyRandVRF public vrf;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        vrf = new VerifyRandVRF();

        vm.stopBroadcast();
    }
}
