/*

    Copyright 2018 dYdX Trading Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/

const { isDevNetwork, isMainNet, MULTISIG } = require('./helpers');

const Vault = artifacts.require("Vault");
const TokenProxy = artifacts.require("TokenProxy");
const ChemixMain = artifacts.require("ChemixMain");
const ChemixStorage = artifacts.require("ChemixStorage");

// For testing
const TokenA = artifacts.require("TokenA");
const TokenB = artifacts.require("TokenB");
const TokenC = artifacts.require("TokenC");

// External contracts
const { networks } = require("../truffle");

// // Other constants
// const BigNumber = require('bignumber.js');
// const ONE_HOUR = new BigNumber(60 * 60);
// const EXPIRING_MARKET_EXPIRY = new BigNumber("18446744073709551615");

// Deploy functions
async function maybeDeployTestTokens(deployer, network) {
  if (isDevNetwork(network)) {
    await Promise.all([
      deployer.deploy(TokenA),
      deployer.deploy(TokenB),
      deployer.deploy(TokenC)
    ]);
  }
}

async function deployBaseProtocol(deployer, network) {
  await Promise.all([
    deployer.deploy(TokenProxy),
    deployer.deploy(ChemixStorage),
  ]);

  // Deploy Vault
  await deployer.deploy(
    Vault,
    TokenProxy.address,
    ChemixStorage.address
  );

  // Deploy ChemixMain
  await deployer.deploy(
    ChemixMain,
    Vault.address,
    ChemixStorage.address,
    0xc1c43b727060AA1e63Dfd1F77463b6Af62ce3188,
    100000000000
  );

  // Get contracts
  const [
    storage,
    proxy,
    vault
  ] = await Promise.all([
    ChemixStorage.deployed(),
    TokenProxy.deployed(),
    Vault.deployed()
  ]);

  // Grant access between Margin, Vault, and Proxy
  await Promise.all([
    storage.grantAccess(ChemixMain.address),
    vault.grantAccess(ChemixMain.address),
    proxy.grantAccess(Vault.address),
    proxy.grantAccess(ChemixMain.address),
  ]);
}

async function doMigration(deployer, network) {
  await maybeDeployTestTokens(deployer, network);
  await deployBaseProtocol(deployer, network);
}

module.exports = (deployer, network, _addresses) => {
  deployer.then(() => doMigration(deployer, network));
};
