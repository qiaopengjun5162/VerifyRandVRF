# VerifyRandVRF

## Overview

**VerifyRandVRF** is a smart contract designed to request and fulfill verifiable random numbers (VRF) on the Ethereum blockchain. The contract interacts with an external trusted contract (e.g., `verifyRand`) for fulfilling random word requests. It is designed to support requests for randomness while ensuring verifiability, making it a useful tool for applications such as gaming, lotteries, or any other use case requiring secure and random numbers.

Additionally, the **VerifyRandVRFFactory** contract allows for the deployment of proxy contracts that are clones of the **VerifyRandVRF** contract, enabling scalable and cost-efficient deployment.

---

## Table of Contents

1. [Contract: VerifyRandVRF](#contract-verifyrandvrf)
   - [Features](#features)
   - [Functions](#functions)
2. [Contract: VerifyRandVRFFactory](#contract-verifyrandvrffactory)
   - [Features](#features-1)
   - [Functions](#functions-1)
3. [Usage](#usage)
4. [Deployment](#deployment)
5. [Events](#events)
6. [Requirements](#requirements)
7. [License](#license)

---

## Contract: VerifyRandVRF

### Features

- **Request Random Numbers**: Allows the contract owner to request random numbers from an external trusted source.
- **Fulfill Random Numbers**: Only the trusted `verifyRand` contract can fulfill the randomness request, ensuring security.
- **Track Request Status**: Each random number request can be tracked by its ID, with the status showing whether it has been fulfilled.
- **Admin Controls**: The contract owner can update the trusted `verifyRand` address to ensure it points to the correct randomness provider.

### Functions

#### `requestRandomWords(uint256 _requestId, uint256 _numWords)`

- **Description**: Initiates a random word request.
- **Access Control**: Can only be called by the owner of the contract.
- **Parameters**:
  - `_requestId` (uint256): The unique identifier for this request.
  - `_numWords` (uint256): The number of random words to request.

#### `fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords)`

- **Description**: Fulfills a random words request.
- **Access Control**: Can only be called by the `verifyRand` contract.
- **Parameters**:
  - `_requestId` (uint256): The ID of the request to fulfill.
  - `_randomWords` (uint256[]): The array of random numbers to return.

#### `getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256[] memory randomWords)`

- **Description**: Retrieves the status and result of a specific random request.
- **Parameters**:
  - `_requestId` (uint256): The ID of the request.
- **Returns**:
  - `fulfilled` (bool): Indicates if the random words were fulfilled.
  - `randomWords` (uint256[]): The random words generated for this request.

#### `setVerifyRand(address _verifyRandAddress)`

- **Description**: Allows the contract owner to set a new `verifyRand` address.
- **Access Control**: Can only be called by the contract owner.
- **Parameters**:
  - `_verifyRandAddress` (address): The new address of the `verifyRand` contract.

---

## Contract: VerifyRandVRFFactory

### Features

- **Clone Contracts**: The factory contract enables the creation of clone contracts for the `VerifyRandVRF` contract, optimizing deployment costs by utilizing proxy patterns.
- **Scalable Deployment**: Clones of the `VerifyRandVRF` contract can be created with customized `verifyRand` addresses and initialized with the sender’s address.

### Functions

#### `createProxy(address implementation, address verifyRandAddress) external returns (address)`

- **Description**: Creates a proxy contract (clone) of the `VerifyRandVRF` implementation.
- **Parameters**:
  - `implementation` (address): The address of the `VerifyRandVRF` implementation contract.
  - `verifyRandAddress` (address): The address of the `verifyRand` contract to fulfill the randomness request.
- **Returns**:
  - `mintProxyAddress` (address): The address of the newly created proxy contract.

---

## Usage

1. Deploy the `VerifyRandVRF` contract, passing the owner address and `verifyRand` contract address during initialization.
2. Use the `VerifyRandVRFFactory` contract to deploy clones of the `VerifyRandVRF` contract. Each clone is initialized with a custom `verifyRand` address.
3. The owner of the contract can request random words via the `requestRandomWords` function.
4. The `verifyRand` contract is responsible for fulfilling the random request with the `fulfillRandomWords` function.
5. Track the status of the request with the `getRequestStatus` function.

---

## Deployment

To deploy the contracts:

1. Deploy the `VerifyRandVRF` contract on the desired network.
2. Deploy the `VerifyRandVRFFactory` contract, ensuring it points to the `VerifyRandVRF` contract.
3. Use the factory contract to create proxy contracts (clones) of the `VerifyRandVRF` contract.
4. Initialize each proxy contract with the sender address and `verifyRand` address.

---

## Events

### `RequestSent(uint256 requestId, uint256 _numWords, address current)`

- **Description**: Emitted when a random word request is sent.
- **Parameters**:
  - `requestId` (uint256): The unique ID of the request.
  - `_numWords` (uint256): The number of random words requested.
  - `current` (address): The address that made the request.

### `FillRandomWords(uint256 requestId, uint256[] randomWords)`

- **Description**: Emitted when the random words are fulfilled.
- **Parameters**:
  - `requestId` (uint256): The ID of the request being fulfilled.
  - `randomWords` (uint256[]): The random words generated for this request.

### `ProxyCreated(address mintProxyAddress)`

- **Description**: Emitted when a new proxy contract is created.
- **Parameters**:
  - `mintProxyAddress` (address): The address of the newly created proxy contract.

---

## Requirements

- **Solidity Version**: `^0.8.20`
- **OpenZeppelin Contracts**: Required for upgrades and proxy pattern implementations.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
