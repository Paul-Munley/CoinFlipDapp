pragma solidity 0.7.6;

contract CoinFlip {

    // mapping (address => uint) balance;

	uint256 public contractBalance;
    uint256 public betAmount;

	constructor() {
		contractBalance = 0;
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

	//Function to choose heads/tails choice, run psudo-random coin flip, and run result if choser won/lost
	function random(uint256 choice) public payable returns(bool){
	    require(choice == 0 || choice == 1, "invalid choice");
	    //require(betAmount > 0);
		bool success;
		uint256 result = block.timestamp % 2;
		if(result == choice){
		    contractBalance += betAmount * 2;
		    success = true;
			betAmount = 0;
		}
		else{
		    success = false;
			betAmount = 0;
		}
		return success;
	}

}