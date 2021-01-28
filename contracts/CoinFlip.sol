import "./provableAPI_0.6.sol";

pragma solidity 0.7.0;

contract CoinFlip is usingProvable {

	struct Bet {
		address player;
		uint betAmount;
		bool result;
	} 

	mapping (bytes32 => Bet) betting; //queryId to Bet struct info
	mapping (address => bool) waiting; //mapping to see if msg.sender is waiting

	uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
	// uint256 public latestNumber;

	uint256 public contractBalance;
    // uint256 public betAmount;

	constructor() {
		contractBalance = 0;
		provable_setProof(proofType_Ledger);
		// update(); //for random number oracle
	}

	event LogNewProvableQuery(string description); //event to track when a new query is made to the provable oracle
	event generatedRandomNumber(uint256 randomNumber); //event to track when random number is generated
	event betPlaced(address bettor, bytes32 _queryId, uint256 _betAmount); //event to track when new bet is placed
	event coinFlipResults(address bettor, bytes32 _queryId, uint256 wonAmount);

	function __callback(bytes32 _queryId, string memory _result, uint256 _choice, bytes memory _proof) public {
		// require(msg.sender == provable_cbAddress());

		uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 2;
		if(_choice == randomNumber) {
		    uint256 wonAmount = betting[_queryId].betAmount * 2; //setting winnings to variable in order to emit event winnings
		    wonAmount += contractBalance; //returning betAmount x2 to contractBalance for winning
		    betting[_queryId].result = true; //winning coin flip will have result = true
		}
		else {
		    betting[_queryId].betAmount = 0; //will reset bet amount for that struct
		    betting[_queryId].result = false; //losing coin flip will have result = false
		}
		emit generatedRandomNumber(randomNumber);
// 		emit coinFlipResults(msg.sender, _queryId, wonAmount);
	}
    //place bet and query provable oracle from provable to simulate coin flipping.
	function update(uint256 amount) payable public {
	    // require(amount)
		uint256 QUERY_EXECUTION_DELAY = 0;
		uint256 GAS_FOR_CALLBACK = 200000;
		// bytes32 queryId = testRandom();//TEST PURPOSES LINE
		bytes32 queryId = provable_newRandomDSQuery(
			QUERY_EXECUTION_DELAY,
			NUM_RANDOM_BYTES_REQUESTED,
			GAS_FOR_CALLBACK
		); /***COMMENTED OUT TO TEST ORACLE FUNCTION WITHOUT HAVING TO CONNECT TO ORACLE EVERYTIME. WILL UNCOMMENT WHEN CONTRACT IS READY TO CONNECT TO ORACLE****/
		contractBalance -= amount;
		betting[queryId] = Bet({player: msg.sender, betAmount: amount, result: false}); //assigning a queryId & struct to the betting mapping and initializing the Bet struct with pertinent struct info
		emit betPlaced(msg.sender, queryId, amount); //emit betPlaced event with pertinent info
	}

	//FUNCTION MIMICING ORACLE FUNCTIONALITY FOR TESTING PURPOSE.. IS NOT IN SAME ORDER AS REGULAR ORACLE FUNCTION BECAUSE IT IS JUST TESTING
	// function testRandom() public returns(uint256) {
	// 	bytes32 queryId = bytes32(keccak256(abi.encodePacked(msg.sender)));
	// 	__callback(queryId, "1", bytes32(keccak256(abi.encodePacked(msg.sender))));
	// 	return queryId;
	// }

	//Add funds to contract balance (aka set contractBalance)
	function addBalance() public payable {
		// require(msg.value >=  minimumAddBalanceAmnt);
		contractBalance += msg.value;
	}

	function withdrawBalance() public payable {
		msg.sender.transfer(contractBalance);
		contractBalance = 0;
	}

	//Pt.2 random() real function
	

	//Pt.2 random() fake function to speed up production process instead of waiting for response from ropsten network


	//Pt. 1 random() function. to choose heads/tails choice, run psudo-random coin flip, and run result if choser won/lost.
	// function random(uint256 choice) public payable returns(bool){
	//     require(choice == 0 || choice == 1, "invalid choice");
	//     //require(betAmount > 0);
	// 	bool success;
	// 	uint256 result = block.timestamp % 2;
	// 	if(result == choice){
	// 	    contractBalance += betAmount * 2;
	// 	    success = true;
	// 		betAmount = 0;
	// 	}
	// 	else{
	// 	    success = false;
	// 		betAmount = 0;
	// 	}
	// 	return success;
	// }

}