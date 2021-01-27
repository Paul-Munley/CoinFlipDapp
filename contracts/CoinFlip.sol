import "./provableAPI_0.6.sol";

pragma solidity 0.7.6;

contract CoinFlip is usingProvable {

    // mapping (address => uint) balance;
	uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
	uint256 public latestNumber;

	uint256 public contractBalance;
    uint256 public betAmount;

	constructor() public {
		contractBalance = 0;
		update(); //for random number oracle
	}

	function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
		require(msg.sender == provable_cbAddress());

		uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 100;
		latestNumber = randomNumber;
		emit generatedRandomNumber(randomNumber);
	}

	function update() payable public {
		uint256 QUERY_EXECUTION_DELAY = 0;
		uint256 GAS_FOR_CALLBACK = 200000;
		provable_newRandomDSQuery(
			QUERY_EXECUTION_DELAY,
			NUM_RANDOM_BYTES_REQUESTED,
			GAS_FOR_CALLBACK
		);
		emit LogNewProvableQuery("Provable query was sent, standing by for the answer...");
	}

	//Add funds to contract balance (aka set contractBalance)
	function addBalance() public payable {
		// require(msg.value >=  minimumAddBalanceAmnt);
		contractBalance += msg.value;
	}

	function withdrawBalance() public payable {
		msg.sender.transfer(contractBalance);
		contractBalance = 0;
	}

	//Add funds from contractBalance to betAmount variable (aka set betAmount)
    function setBet(uint amount) public payable {
        // require(amount <= contractBalance, "Insufficient funds. Please bet equal to or less than your current balance amount. Or add more to your balance.");
        //require(minimumBet <= amount, "Minimum bet should be at least 1 ether"); **CHECK NOTE BELOW**
		contractBalance -= amount;
		betAmount = amount;
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