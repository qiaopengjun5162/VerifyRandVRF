// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {VerifyRandVRF} from "../src/VerifyRandVRF.sol";
import {VerifyRandVRFFactory} from "../src/VerifyRandVRFFactory.sol";

contract VerifyRandVRFTest is Test {
    VerifyRandVRF public vrf;
    VerifyRandVRF public proxyVRF;
    VerifyRandVRFFactory public vrfFactory;

    function setUp() public {
        vrf = new VerifyRandVRF();
        vrfFactory = new VerifyRandVRFFactory();
        address proxyAddress = vrfFactory.createProxy(address(vrf), address(this));
        proxyVRF = VerifyRandVRF(proxyAddress);
    }

    function testSetValueThroughProxy() public {
        proxyVRF.requestRandomWords(11111, 3);
        uint256[] memory randomWords = new uint256[](5);
        randomWords[0] = 1;
        randomWords[1] = 2;
        randomWords[2] = 3;
        randomWords[3] = 4;
        randomWords[4] = 5;
        proxyVRF.fulfillRandomWords(11111, randomWords);
        (bool success, uint256[] memory randomList) = proxyVRF.getRequestStatus(11111);
        console.log("================result==================");
        console.log(success);
        console.log(randomList[0]);
        console.log(randomList[4]);
        console.log("================result==================");
    }
}
