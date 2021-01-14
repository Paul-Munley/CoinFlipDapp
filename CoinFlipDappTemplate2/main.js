var web3 = new Web3(Web3.givenProvider);
var contractInstance;
//let bet = $("#bet_input");
//let stringBet;

$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
        contractInstance = new web3.eth.Contract(abi, "0xa1D2086dF42F89D7225F768fc77cED385eCBe566", {from: accounts[0]});
        console.log(contractInstance);
    });
    $("#add_bet_button").click(inputData);
    $("#get_current_bet_btn").click(fetchAndDisplay);

});

function inputData() {

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

function fetchAndDisplay() {
    contractInstance.methods.getBetAmount().call().then(function(res){
        $("#current_bet_output").text(res);
    });
};

// function flipCoin() {
    
// }



