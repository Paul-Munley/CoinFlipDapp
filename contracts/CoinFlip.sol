import "./provableAPI_0.6.sol";

pragma solidity 0.7.0;

contract CoinFlip is usingProvable {

	struct Bet {
		address player;
		uint256 choice;
		uint256 betAmount;
		bool result;
	} 
	
	uint256 betAmount;

	mapping (bytes32 => Bet) betting; //queryId to Bet struct info
	mapping (address => bool) waiting; //mapping to see if msg.sender is waiting for query response

	uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
	// uint256 public latestNumber;

	uint256 public contractBalance;
    // uint256 public betAmount;

	constructor() {
		contractBalance = 0;
		provable_setProof(proofType_Ledger);
// 		update();
	}

	event LogNewProvableQuery(string description); //event to track when a new query is made to the provable oracle
	event generatedRandomNumber(uint256 randomNumber); //event to track when random number is generated
	event betPlaced(address bettor, bytes32 _queryId, uint256 _betAmount); //event to track when new bet is placed
	event coinFlipResults(address indexed bettor, bool result, uint256 wonAmount);

// 	function setBetAndNewGame(uint256 _choice) payable public {
// 	    Bet storage currentBet;
// 		currentBet.player = msg.sender;
// 		currentBet.choice = _choice;
// 		update();
// 	}

	function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) override public {
		require(msg.sender == provable_cbAddress());

		uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 2; //will take response from oracle and turn it into a 0 or 1
		confirmResult(randomNumber, _queryId); //calls confirmResult funcion with arguments passed from this function

		emit generatedRandomNumber(randomNumber);
// 		emit coinFlipResults(msg.sender, _queryId, wonAmount);
	}

	function confirmResult(uint randomNumber, bytes32 _queryId) public payable {
		if(randomNumber == betting[_queryId].choice) {
			winningsPayout = betAmount * 2;
			contractBalance += winningsPayout; //winnings payout

			betting[_queryId].result = true; //result will be true if won
			emit(betting[_queryId].player, betting[_queryId].result, winningsPayout);
			delete(betAmount); //reset betAmount to 0
		}
		else {
			delete(betAmount); //reset betAmount to 0
			betting[_queryId].result = false; //result will be false if lost
		}
		delete(betting[_queryId]); //reset query id to default value for next bet
		waiting[msg.sender] = false; //will set waiting status to false

	}
		//FUNCTION MIMICING ORACLE FUNCTIONALITY FOR TESTING PURPOSE.. IS NOT IN SAME ORDER AS REGULAR ORACLE FUNCTION BECAUSE IT IS JUST TESTING
	function testRandom() public returns(bytes32) {
		bytes32 queryId = bytes32(keccak256("test"));
		__callback(queryId, "1", bytes("test"));
		return queryId;
	}

    //place bet and query provable oracle from provable to simulate coin flipping.
	function update(uint256 _choice, uint256 amount) payable public {
	    // require(amount)
		uint256 QUERY_EXECUTION_DELAY = 0;
		uint256 GAS_FOR_CALLBACK = 200000;
		// bytes32 queryId = testRandom();//TEST PURPOSES LINE
		bytes32 queryId = provable_newRandomDSQuery(
			QUERY_EXECUTION_DELAY,
			NUM_RANDOM_BYTES_REQUESTED,
			GAS_FOR_CALLBACK
		);
		// betting[queryId] = Bet({player: msg.sender, betAmount: amount, choice: _choice}); //assigning a queryId & struct to the betting mapping and initializing the Bet struct with pertinent struct info
		betting[queryId] = Bet({player: msg.sender, choice: _choice, betAmount: amount, result: false});
		waiting[msg.sender] = true;
		// emit betPlaced(currentBet.player, queryId, currentBet.betAmount); //emit betPlaced event with pertinent info
	}

	//Add funds to contract balance (aka set contractBalance)
	function addBalance() public payable {
		// require(msg.value >=  minimumAddBalanceAmnt);
		contractBalance += msg.value;
	}
	
// 	function setBet(uint256 amount)  public payable {
// 	    contractBalance -= amount;
// 	    amount += betAmount;
// 	}

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