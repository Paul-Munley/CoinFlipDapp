var web3 = new Web3(Web3.givenProvider);
var contractInstance;
//let bet = $("#bet_input");
//let stringBet;

$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
        contractInstance = new web3.eth.Contract(abi, "0xa1B33Df441b497510e7Aa0953Fd6049185b7673E", {from: accounts[0]});
        console.log(contractInstance);
    });
    $("#add_bet_button").click(inputBetData);
    $("#get_current_bet_btn").click(fetchAndDisplayBet);
    $("#flip_coin_btn").click(pickChoiceAndFlipCoin);
    $("#add_balance_button").click(inputBalanceData);
    $("#get_current_balance_btn").click(fetchAndDisplayBalance);
});

function inputBetData() {

    let bet = $("#bet_input").val().toString()

    let config = {
        value: web3.utils.toWei(bet, "ether")
    }

    contractInstance.methods.setBet(bet).send(config)
    .on("transactionHash", function(hash){
        console.log(hash);
    })
    .on("confirmation", function(confirmationNr){
        console.log(confirmationNr);
    })
    .on("receipt", function(receipt){
        console.log(receipt);
    })

};

function inputBalanceData() {

    let balanceAmount = $("#add_balance_input").val().toString();

    let config = {
        value: web3.utils.toWei(balanceAmount, "ether")
    }

    contractInstance.methods.addBalance().send(config)
    .on("transactionHash", function(hash){
        console.log(hash);
    })
    .on("confirmation", function(confirmationNr){
        console.log(confirmationNr);
    })
    .on("receipt", function(receipt){
        console.log(receipt);
    })

};

function fetchAndDisplayBet() {
    contractInstance.methods.betAmount().call().then(function(res){
        $("#current_bet_output").text(res);
    });
};

function fetchAndDisplayBalance() {

    contractInstance.methods.contractBalance().call().then(function(result) {
        $("#running_balance_output").text(web3.utils.fromWei(result, 'ether'));
    });
};

//NOTE: need to fix the event listener to alert user
async function pickChoiceAndFlipCoin() {
    // const radioButtons = document.querySelectorAll('input[name="answer"]');
    // let selectedValue = $(".radio_btn").val();
    const outcome = 0;
    let selectedValue = $('input[name=answer]:checked').val(); 
    await contractInstance.methods.random(selectedValue).send();
    await contractInstance.methods.random(selectedValue).call()
    .then(function(result) {
        if(result == 0) {
            console.log("Congrats you won!");
        }
        else {
            console.log("Sorry you lost, please try again.");
        }
    });
};


