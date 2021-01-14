pragma solidity 0.7.6;

contract CoinFlip {

    // struct User {
    //     uint256 id;
    //     uint256 balance;
    // }

// 	mapping (address => User) user;
//     User[] users;

    mapping (address => uint) balance;

    uint256 betAmount;
    uint256 minimumBet;
    //bool betChoice;
	//uint256 winningOutcome;

	//address[] addressList;

	constructor() {
		minimumBet = 1;
	}


	function addBalance() public payable returns(uint){
		balance[msg.sender] += msg.value;
		return balance[msg.sender];
	}

	function getBalance() public view returns(uint){
	    //require(balance[msg.sender] > 0, "No active balance. Add funds to continue");
	    return balance[msg.sender];
	}

// 	function flipCoin(uint256 betAmount) public payable returns() {
// 		require;
// 		msg.value = betAmount;
// 	}

    function setBet(uint256 amount) public payable returns(uint256, uint256){
        //require(amount <= balance[msg.sender]);
        require(minimumBet <= amount, "Minimum bet should be at least 1 ether");
        balance[msg.sender] -= amount;
        betAmount = amount;
        return(balance[msg.sender], betAmount);
    }

    function getBetAmount() public view returns(uint256){
        return betAmount;
    }

	function random(uint256 choice) public payable returns(string memory){
	    require(choice == 0 || choice == 1);
	    //require(betAmount > 0);
		uint256 result = block.timestamp % 2;
		if(result == choice){
		    balance[msg.sender] += betAmount * 2;
		    betAmount = 0;
		    return "congrats, you win!";
		}
		else{
		    betAmount = 0;
		    return "sorry you lost, try again.";
		}
	}
}