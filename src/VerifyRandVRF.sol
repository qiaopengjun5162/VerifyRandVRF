// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

///////////////////
// Imports
///////////////////

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

///////////////////
// Contract: VerifyRandVRF
///////////////////

/**
 * @title VerifyRandVRF
 * @dev A contract for requesting and fulfilling verifiable random numbers.
 * In this contract, the random numbers are fulfilled by a trusted external contract, verifyRand.
 */
contract VerifyRandVRF is Initializable, OwnableUpgradeable {
    ///////////////////
    // State Variables
    ///////////////////

    /**
     * @dev Struct for tracking the status of random words requests.
     * @param fulfilled A flag indicating whether the random words request has been fulfilled.
     * @param randomWords The array of random words that are returned after fulfilling the request.
     */
    struct RequestStatus {
        bool fulfilled;
        uint256[] randomWords;
    }

    uint256[] public requestIds; // Array of request IDs
    uint256 public lastRequestId; // The last generated request ID
    address public verifyRandAddress; // Address of the verifyRand contract for fulfilling random words

    // Mapping of request IDs to their associated request status
    mapping(uint256 => RequestStatus) public requestMapping;

    /////////////////////
    // Events
    /////////////////////

    /**
     * @dev Emitted when a request for random words is sent.
     * @param requestId The unique request ID.
     * @param _numWords The number of random words requested.
     * @param current The current address making the request.
     */
    event RequestSent(uint256 requestId, uint256 _numWords, address current);

    /**
     * @dev Emitted when random words are fulfilled.
     * @param requestId The unique request ID.
     * @param randomWords The array of fulfilled random words.
     */
    event FillRandomWords(uint256 requestId, uint256[] randomWords);

    /////////////////////
    // Modifiers
    /////////////////////

    /**
     * @dev Modifier to ensure that only the verifyRand contract can fulfill random words.
     */
    modifier onlyVerifyRand() {
        require(msg.sender == verifyRandAddress, "Only verifyRand can call this function");
        _;
    }

    /////////////////////
    // Constructor
    /////////////////////

    /**
     * @dev Disables initializers for the contract.
     */
    constructor() {
        _disableInitializers();
    }

    /////////////////////
    // Initialization
    /////////////////////

    /**
     * @dev Initializes the contract with the initial owner and verifyRand address.
     * @param initialOwner The address that will own the contract.
     * @param _verifyRandAddress The address of the verifyRand contract for fulfilling random words.
     */
    function initialize(address initialOwner, address _verifyRandAddress) public initializer {
        __Ownable_init(initialOwner);
        verifyRandAddress = _verifyRandAddress;
    }

    /////////////////////
    // Public Functions
    /////////////////////

    /**
     * @dev Requests random words by providing a request ID and the number of words requested.
     * Can only be called by the owner.
     * @param _requestId The request ID for the random words.
     * @param _numWords The number of random words requested.
     */
    function requestRandomWords(uint256 _requestId, uint256 _numWords) external onlyOwner {
        requestMapping[_requestId] = RequestStatus({randomWords: new uint256[](0), fulfilled: false});
        requestIds.push(_requestId);
        lastRequestId = _requestId;
        emit RequestSent(_requestId, _numWords, address(this));
    }

    /**
     * @dev Fulfills a random words request with the provided random words.
     * Can only be called by the verifyRand contract.
     * @param _requestId The request ID for the random words.
     * @param _randomWords The array of random words to fulfill the request with.
     */
    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) external onlyVerifyRand {
        requestMapping[_requestId] = RequestStatus({fulfilled: true, randomWords: _randomWords});
        emit FillRandomWords(_requestId, _randomWords);
    }

    /**
     * @dev Returns the fulfillment status and the random words of a request.
     * @param _requestId The request ID for which the status is requested.
     * @return fulfilled A flag indicating whether the request is fulfilled.
     * @return randomWords The random words generated for the request.
     */
    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords)
    {
        return (requestMapping[_requestId].fulfilled, requestMapping[_requestId].randomWords);
    }

    /////////////////////
    // Admin Functions
    /////////////////////

    /**
     * @dev Sets a new verifyRand address.
     * Can only be called by the owner.
     * @param _verifyRandAddress The new address of the verifyRand contract.
     */
    function setVerifyRand(address _verifyRandAddress) public onlyOwner {
        verifyRandAddress = _verifyRandAddress;
    }
}
