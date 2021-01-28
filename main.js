var web3 = new Web3(Web3.givenProvider);
var contractInstance;

$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
        contractInstance = new web3.eth.Contract(abi, "0x8047C78D2b170C06d66E455C4E6f64A591A58ecC", {from: accounts[0]});
        console.log(contractInstance);
    });
    $("#add_bet_button").click(inputBetData);
    $("#get_current_bet_btn").click(fetchAndDisplayBet);
    $("#flip_coin_btn").click(pickChoiceAndFlipCoin);
    $("#add_balance_button").click(inputBalanceData);
    $("#withdraw_all_button").click(withdrawBalance);
    $("#get_current_balance_btn").click(fetchAndDisplayBalance);
});

// function inputBetData() {

//     let bet = $("#bet_input").val();

//     let config = {
//         value: web3.utils.toWei(bet, "ether")
//     }
//     // console.log(config);
//     // console.log(config.value);

//     contractInstance.methods.setBet(config.value).send()
//     .on("transactionHash", function(hash){
//         console.log(hash);
//     })
//     .on("confirmation", function(confirmationNr){
//         console.log(confirmationNr);
//     })
//     .on("receipt", function(receipt){
//         console.log(receipt);
//     })

// };

// function placeBetAndRoll() {

//     let bet = $("#bet_input").val();

//     let config = {
//         value: web3.utils.toWei(bet, "ether")
//     }

//     contractInstance.methods.setBet(config.value).send()

// }

function inputBalanceData() {

    let balanceAmount = $("#add_balance_input").val();

    // console.log(balanceAmount);

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

function withdrawBalance() {
    contractInstance.methods.withdrawBalance().send();
    // .on("transactionHash", function(hash){
    //     console.log(hash);
    // })
    // .on("confirmation", function(confirmationNr){
    //     console.log(confirmationNr);
    // })
    // .on("receipt", function(receipt){
    //     console.log(receipt);
    // })
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

async function pickChoiceAndFlipCoin() {

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




