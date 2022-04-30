// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity ^0.8.7;

//importing supporting contracts for RandomNumberConsumerV2
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

//inheriting code from VRFConsumerBase import
contract RandomNumberConsumerV2 is VRFConsumerBaseV2 {

  //Interface for VRF Coordinator that verifies the numbers returned are actually random
  VRFCoordinatorV2Interface immutable COORDINATOR;

  //Interface for the Link Token
  LinkTokenInterface immutable LINKTOKEN;

  //Your subscription ID from earlier (Hint: Subscription Manager)
  uint64 immutable s_subscriptionId;

  // The gas lane to use, which specifies the maximum gas price to bump to.
  // For a list of available gas lanes on each network,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations
  //keyHash used to determine which Chainlink Oracle to use to get a random number
  bytes32 immutable s_keyHash;

  // Depends on the number of requested values that you want sent to the
  // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
  // so 100,000 is a safe default for this example contract. Test and adjust
  // this limit based on the network that you select, the size of the request,
  // and the processing of the callback request in the fulfillRandomWords()
  // function.
  uint32 immutable s_callbackGasLimit = 100000;

  // The default is 3, but you can set this higher.
  uint16 immutable s_requestConfirmations = 3;

  // For this example, retrieve 2 random values in one request.
  // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
  uint32 immutable s_numWords = 2;

  //Array for storing the received random values
  uint256[] public s_randomWords;

  //request Id for requesting random values
  //request Id ensures you get your random values and not someone else's
  uint256 public s_requestId;

  //address variable
  address s_owner;

  //event to return the array of random words
  event ReturnedRandomness(uint256[] randomWords);

  /**
   * @notice Constructor inherits VRFConsumerBaseV2
   *
   * @param subscriptionId - the subscription ID that this contract uses for funding requests
   * @param vrfCoordinator - coordinator, check https://docs.chain.link/docs/vrf-contracts/#configurations
   * @param keyHash - the gas lane to use, which specifies the maximum gas price to bump to
   */
   //constructor is function called when smart contract is deployed
  //we must pass the VRFConsumerBase constructor since we are inheriting that contract also
  constructor(
    uint64 subscriptionId,
    address vrfCoordinator,
    address link,
    bytes32 keyHash
  ) VRFConsumerBaseV2(vrfCoordinator) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    LINKTOKEN = LinkTokenInterface(link);
    s_keyHash = keyHash;
    s_owner = msg.sender;
    s_subscriptionId = subscriptionId;
  }

  /**
   * @notice Requests randomness
   * Assumes the subscription is funded sufficiently; "Words" refers to unit of data in Computer Science
   */
   //function to request the random values
  //onlyOwner modifier ensures that only contract owner can call this
  function requestRandomWords() external onlyOwner {
    // Will revert if subscription is not set and funded.
    //Please make sure you have funds in subscription
    s_requestId = COORDINATOR.requestRandomWords(
      s_keyHash,
      s_subscriptionId,
      s_requestConfirmations,
      s_callbackGasLimit,
      s_numWords
    );
  }

  /**
   * @notice Callback function used by VRF Coordinator
   *
   * @param requestId - id of the request
   * @param randomWords - array of random results from VRF Coordinator
   */
   //Callback function used by VRF Coordinator
  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
    s_randomWords = randomWords;
    emit ReturnedRandomness(randomWords);
  }

  //checks if contract owner is the one calling a transaction
  modifier onlyOwner() {
    require(msg.sender == s_owner);
    _;
  }
}