pragma solidity 0.7.6;

contract CoinFlip {

    mapping (address => uint) balance;

	uint256 public contractBalance;
    uint256 public betAmount;
	// uint256 minimumAddBalanceAmnt; //**CHECK NOTE BELOW**
    
	//Constructor to intiailize minimumAddBalanceAmnt variable to 1.. **CHECK NOTE BELOW**
	// constructor() {
	// 	minimumAddBalanceAmnt = 1;
	// }

	/*// uint256 minimumBet; **CHECK NOTE BELOW**

	//Constructor to intiailize minimumBet variable to 1
	constructor() {
		minimumBet = 1;
	}*/

	//Add funds to contract balance (aka set contractBalance)
	function addBalance() public payable returns(uint256) {
		// require(msg.value >=  minimumAddBalanceAmnt); //**CHECK NOTE BELOW**
		contractBalance += msg.value;
		return contractBalance;
	}

	//Add funds from contractBalance to betAmount variable (aka set betAmount)
    function setBet(uint256 amount) public {
        // require(amount <= contractBalance, "Insufficient funds. Please bet equal to or less than your current balance amount. Or add more to your balance.");
        //require(minimumBet <= amount, "Minimum bet should be at least 1 ether"); **CHECK NOTE BELOW**
        contractBalance -= amount;
        betAmount = amount;
    }

	//Function to choose heads/tails choice, run psudo-random coin flip, and run result if choser won/lost
	function random(uint256 choice) public payable returns(uint){
	    require(choice == 0 || choice == 1);
	    //require(betAmount > 0);
		uint256 result = block.timestamp % 2;
		if(result == choice){
		    contractBalance += betAmount * 2;
		    betAmount = 0;
		    return 0;
		}
		else{
		    betAmount = 0;
		    return 1;
		}
	}

}