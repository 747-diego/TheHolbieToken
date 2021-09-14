var DappTokenSale = artifacts.require("./DappTokenSale.sol");
var DappToken = artifacts.require("./DappToken.sol");


contract('DappTokenSale', function(accounts) {
    var tokenSaleInstance;
    var tokenInstance;
    var admin = accounts[0];
    var buyer = accounts[1];
    var tokenPrice = 1000000000000000; // in wei
    var tokensAvailable = 10;
    var numberOfTokens;

    it('initializes the contract with the correct values', function() {
        return DappTokenSale.deployed().then(function(instance) {
            tokenSaleInstance = instance;
            return tokenSaleInstance.address
        }).then(function(address) {
            assert.notEqual(address, 0x0, 'has contract address');
            return tokenSaleInstance.tokenContract();
        }).then(function(address) {
            assert.notEqual(address, 0x0, 'has token contract address');
            return tokenSaleInstance.tokenPrice();
        }).then(function(price) {
            assert.equal(price, tokenPrice, 'token price is correct');
        });
    });

    it('facilitates token buying', function() {
        return DappToken.deployed().then(function(instance) {
            // GRAB TOKEN INSTANCE FIRST
            tokenInstance = instance;
            return DappTokenSale.deployed();
        }).then(function(instance) {
            // THEN GRAB TOKEN SALE INSTANACE
            tokenSaleInstance = instance;
            // PROVISION 75% OF ALL TOKENS TO THE TOKEN SALE
            return tokenInstance.transfer(tokenSaleInstance.address, tokensAvailable, { from: admin })
        }).then(function(receipt) {
            numberOfTokens = 10;
            return tokenSaleInstance.buyTokens(numberOfTokens, { from: buyer, value: numberOfTokens * tokenPrice })
        }).then(function(receipt) {
            assert.equal(receipt.logs.length, 1, 'triggers one event');
            assert.equal(receipt.logs[0].event, 'Sell', 'should be the "Sell" event');
            assert.equal(receipt.logs[0].args._buyer, buyer, 'logs the account that purchased the tokens');
            assert.equal(receipt.logs[0].args._amount, numberOfTokens, 'logs the number of tokens purchased');
            return tokenSaleInstance.tokensSold();
        }).then(function(amount) {
            assert.equal(amount.toNumber(), numberOfTokens, 'increments the number of tokens sold');
            return tokenInstance.balanceOf(buyer);
        }).then(function(balance) {
            assert.equal(balance.toNumber(), numberOfTokens);
            return tokenInstance.balanceOf(tokenSaleInstance.address);
        }).then(function(balance) {
            assert.equal(balance.toNumber(), tokensAvailable - numberOfTokens);
            // TRY TO BUY TOKENS DIFFERENT FROM THE OTHER VALUES
            return tokenSaleInstance.buyTokens(numberOfTokens, { from: buyer, value: 1 });
        }).then(assert.fail).catch(function(error) {
            assert(error.message.indexOf('revert') >= 0, 'msg.value must equal number of tokens in wei');
            return tokenSaleInstance.buyTokens(800000, { from: buyer, value: numberOfTokens * tokenPrice })
        }).then(assert.fail).catch(function(error) {
            assert(error.message.indexOf('revert') >= 0, 'cannot purchase more tokens than available');
        })
    })

    it('end token sale', function() {
        return DappTokenSale.deployed().then(function(instance) {
            // GRAB TOKEN INSTANCE FIRST
            tokenSaleInstance = instance;
            return DappTokenSale.deployed();
        }).then(function(instance) {
            // THEN GRAB TOKEN SALE INSTANCE
            tokenSaleInstance = instance;
            // TRY TO END SALE FROM ACCOUNT OTHER THAN ADMIN
            return tokenSaleInstance.endSale( { from: buyer });
        }).then(assert.fail).catch(function(error) {
            assert(error.message.indexOf('revert') >= 0, 'must be admin to end sale');
            // END SALE AS ADMIN
            return tokenSaleInstance.endSale( { from: admin } );
        }).then(function(receipt) {
            // RECEIPT
            return tokenInstance.balanceOf(admin);
        }).then(function(balance) {
            assert.equal(balance.toNumber(), 999990, 'returns all unsold dapp tokens to admin');
            // Check that the contract has no balance
            // balance = await web3.eth.getBalance(tokenSaleInstance.address);
            // assert.equal(balance.toNumber(), 0);
            web3.eth.getBalance(tokenSaleInstance.address)
            .then(balance => {
                // You can use balance here
                console.log(balance);
            })
            .catch(console.error);
        });
    });

})