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
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        vrf = new VerifyRandVRF();
        console.log("VerifyRandVRF deployed to: ", address(vrf));

        vrfFactory = new VerifyRandVRFFactory();
        console.log("VerifyRandVRFFactory deployed to: ", address(vrfFactory));

        address proxyAddress = vrfFactory.createProxy(address(vrf), msg.sender);
        console.log("Proxy deployed to: ", proxyAddress);

        vm.stopBroadcast();
    }
}
