var web3 = new Web3(Web3.givenProvider);
var contractInstance;
//let bet = $("#bet_input");
//let stringBet;

$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
        contractInstance = new web3.eth.Contract(abi, "0xC39fA8b5Aa68b983f752264Bba6a87567778E20B", {from: accounts[0]});
        console.log(contractInstance);
    });
    $("#add_bet_button").click(inputBetData);
    $("#get_current_bet_btn").click(fetchAndDisplayBet);
    $("#flip_coin_btn").click(pickChoiceAndFlipCoin);
    $("#add_balance_button").click(inputBalanceData);
    $("#get_current_balance_btn").click(fetchAndDisplayBalance);
});

function inputBetData() {

    let bet = $("#bet_input").val();

    // let betString = JSON.stringify(bet);

    let config = {
        value: web3.utils.toWei(bet, "ether")
    }
    // console.log(config);
    // console.log(config.value);

    contractInstance.methods.setBet(config.value).send()
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
    contractInstance.methods.betAmount().call().then(function(result){
        $("#current_bet_output").text("" + web3.utils.fromWei(result, 'ether') + " ETH");
    });
};

function fetchAndDisplayBalance() {

    contractInstance.methods.contractBalance().call().then(function(result) {
        $("#running_balance_output").text("" + web3.utils.fromWei(result, 'ether') + " ETH");
    });
};

//NOTE: need to fix the event listener to alert user
async function pickChoiceAndFlipCoin() {
    // const radioButtons = document.querySelectorAll('input[name="answer"]');
    // let selectedValue = $(".radio_btn").val();
    let bet = $("#bet_input").val();

    let selectedValue = $('input[name=answer]:checked').val(); 
    await contractInstance.methods.random(selectedValue).send();
    await contractInstance.methods.random(selectedValue).call()
    .then(function(success) {
        if(success == true) {
            alert("Congrats you won " + bet + " Ether!");
        }
        else {
            alert("Sorry you lost " + bet + " Ether. Please try again.");
        }
    });
};


