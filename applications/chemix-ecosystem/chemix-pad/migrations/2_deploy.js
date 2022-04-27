var path = require('path');
var BasicDutchAuction = artifacts.require("BasicDutchAuction");
var AuctionFactory = artifacts.require("AuctionFactory");

module.exports = async function (deployer, network) {
    network = /([a-z]+)(-fork)?/.exec(network)[1];
    var deployConfig = require(path.join(path.dirname(__dirname), "deploy-config.json"))[network];
    await deployer.deploy(AuctionFactory, deployConfig.admin);
    console.log("AuctionFactory.address: ", AuctionFactory.address);
    var auctionFactory = await AuctionFactory.deployed();
    await deployer.deploy(BasicDutchAuction);
    console.log("BasicDutchAuction.address: ", BasicDutchAuction.address);
    await auctionFactory.setAuctionImplement("1", BasicDutchAuction.address);
};
