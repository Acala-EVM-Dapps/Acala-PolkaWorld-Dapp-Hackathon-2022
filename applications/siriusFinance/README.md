# Acala x PolkaWorld Dapp Hackathon 2022
![1](https://user-images.githubusercontent.com/100191538/165687800-eff6b9c3-636c-4d3a-9d81-3c9bb6adf105.png)


- Project Name: Sirius Finance
- Team Name: Sirius Finance Team
- Project online usage link: https://www.sirius.finance/
- Payment Address: Wg8vPjUhTQx4JM88qsBKG6u2rXJbYCF7LxUxJvqtVvYnPzj

## Project Overview 📄
### Overview

- one sentence summary:<Br/>The first cross-chain stablecoin AMM & LP farming center on Astar Network

- A brief description of SiriusFinance:<Br/>
Sirius Finance is a cross-chain stablecoin AMM, that attracts and locks tremendous value through stablecoins with low-slippage trading costs, attractive APY for liquidity providers, and allows for more financial innovations or yield enhancements for Polkadot users.

- An indication of how SiriusFinance relates to / integrates into Acala / Karura EVM+:<Br/>
We will bring aUSD to Sirius’s base pool, expanding its use cases for stablecoin users. Ultimately, our goal is to serve as a low-slippage swap protocol that connects Polkadot, EVM-compatible chains, other major layer1 chains and expanding use cases from stablecoins to other similar valuable tokens. 

- An indication of why our team is interested in creating this project:<Br/>
Stablecoins have over the past few years become a solid ground on which most investors hedge their assets against the highly volatile nature of cryptocurrency markets. The number of stablecoin specific AMMs which enable stableswaps can be counted on one hand and none can be found in the Polkadot ecosystem as at this moment. Curve, the first stablecoin DEX currently holds top spot when using Total Value Locked as the main metric for rating DeFi applications and this has been the case for a very long time. This shows investor’s demand for something less volatile for their assets and following the footsteps of Curve, Sirius Finance is launching the first Polkadot-native cross-chain liquidity pool exchange for stablecoins.

On top of that, we follow the spirit of Defi 2.0, allowing all users to benefit from the protocol via veToken and other incentive mechanisms, encouraging all the users to actually participate in the protocol governance, eventually manage the protocol in a decentralized way, and provide stablecoin services for the Polkadot ecosystem.

### Project Details

#### Detailed description of the core functionality of the project.
- Low slippage decentralized exchange for stablecoins.
- Nearly no permanent loss with no opportunity costs.
- Cross-chain: a DEX to connect Polkadot parachains via XCMP and Astar network, all EVM-compatible ecosystems via c-bridge, allowing stablecoin swaps. - between EVM-compatible chains and Polkadot ecosystem with one click.
- Low swap fees between stablecoins
- Yield farming.
- Governance: users can lock their SRS to gain veSRS. VeSRS holders also share additional trading fees, and can vote on various pool parameters including pool weight, adding/removing metapools, gain boost factor, admin fee percentage, preferred rights for airdrop tokens, etc.
![2](https://user-images.githubusercontent.com/100191538/165690447-f1d54660-b6b9-44a3-9b59-1a22be8c2e5d.png)
![3](https://user-images.githubusercontent.com/100191538/165690474-a23a39ea-2a12-427e-8fe5-12909ab568aa.png)
![4](https://user-images.githubusercontent.com/100191538/165690491-4fa5279b-72dd-4d32-a2e4-81f88341f0a2.png)
![5](https://user-images.githubusercontent.com/100191538/165690303-0606003a-56e6-4a0a-b35d-6da1468993b8.png)

#### Interact with the swap contract

Sirius4Pool: 0x417E9d065ee22DFB7CC6C63C403600E27627F333

**API**

swap
```solidity
function swap(
     uint8 tokenIndexFrom,
     uint8 tokenIndexTo,
     uint256 dx,
     uint256 minDy,
     uint256 deadline
 ) external returns (uint256);
```

addLiquidity
```solidity
function addLiquidity(
     uint256[] calldata amounts,
     uint256 minToMint,
     uint256 deadline
 ) external returns (uint256);
```

removeLiquidity
```solidity
function removeLiquidity(
     uint256 amount,
     uint256[] calldata minAmounts,
     uint256 deadline
 ) external returns (uint256[] memory);
```
 
removeLiquidityOneToken
```solidity
function removeLiquidityOneToken(
     uint256 tokenAmount,
     uint8 tokenIndex,
     uint256 minAmount,
     uint256 deadline
 ) external returns (uint256);
```
 
removeLiquidityImbalance
 ```solidity
 function removeLiquidityImbalance(
      uint256[] calldata amounts,
      uint256 maxBurnAmount,
      uint256 deadline
  ) external returns (uint256);
 ```

### Ecosystem Fit

Help us locate your project in the Polkadot/Substrate/Kusama landscape and what problems it tries to solve by answering each of these questions:<Br/>

#### Where and how does your project fit into the ecosystem?

Built from and within the Astar Network, Sirius Finance aims to become the first polkadot-native stablecoin AMM and currency exchange hub on Polkadot through building base pools, metapools, and in the near future, legal fiat-pegged currency pools and tokenized derivatives. 

Statistics are currently in favor of more DeFi protocols gaining adoption and usage. Most protocols have been able to lock more liquidity and attract more users than the majority of Centralized services in the blockchain space. The DeFi protocol with the highest TVL is Curve which is a stablecoin AMM and that's what Sirius finance is about. Most investors tend to hedge their investments in stablecoins, no wonder Curve is on top. We are looking to bring this same opportunity to a top 10 blockchain platform, Polkadot, beginning with its parachain Astar network which currently boasts of over $1.3 billion in TVL. We believe we are bringing an amazing use case and a market-fit product to the ecosystem.

#### What need(s) does your project meet?
- Low slippage, we provide swap transactions at much lower slippage than market
- No impermanent loss
- Lack of deep liquidity to address volatility
- Lack of yield farming opportunities for most stablecoin holders
- Lack of stablecoin specific DEX on Polkadot
- Limited arbitrage opportunities

#### What makes your project unique?

Sirius Finance is designed to provide stablecoin services with low slippage and no impermanent loss, using an extremely user-friendly interface. We combined vetoken to our swap pool design, in hope of really building out a decentralized protocol. We value every user’s participation and contribution and that’s why we have the governance module, where veSRS holders can share additional trading fees, and vote on various pool parameters including pool weight, choosing metapools, boost factors and everything that can potentially determine final revenues, rewards and distributions. Based on Astar’s cross-chain nature, Sirius will connect dapps not only on Astar but the Polkadot ecosystem to get majority of the dapps connected to it to increase users, liquidity and TVL. In terms of technology, our protocol is going to be WASM and EVM-compatible, and implement XCMP on Polkadot, so that we could eventually connect stablecoins within and outside of the Polkadot ecosystem. 
![6](https://user-images.githubusercontent.com/100191538/165691241-17d3fab3-497c-43dc-ae2e-e92f818159c2.png)
![7](https://user-images.githubusercontent.com/100191538/165691259-c5578cdd-9778-446e-814c-e65e0ca3babd.png)
## Team 👥
### Team members

- Name of team leader: William Chang.<Br/>
- Names of team members: Ronald, Vincent, 0xnomad, etc.<Br/>

### Contact

- Contact Name: Emmy Peng<Br/>
- Contact Email: business@sirius.finance<Br/>
- Website: sirius.finance<Br/>

### Team's experience

Please describe the team's relevant experience. If your project involves development work, we would appreciate it if you singled out a few interesting projects or contributions made by team members in the past.<Br/>
 
We are a team of 15 consisting of developers, project managers, marketers and experts in blockchain and smart contracts. Our development team is made up of blockchain engineers with years of experience in Defi projects that are based on solidity coded smart contracts and they are sophisticated with various Defi protocols like AMM, LP farming, IDO launchpad, etc. Highlighting our tech team experiences as following:<Br/>

- Ronald(CTO):<Br/>
20+ years experience in software development area, 5+ years experience in blockchain industry, consultant / researcher / tech leader for several Defi projects such as Olympus Labs, PolkaEx.

- 0xnomad (Core Dev): <Br/>
10+ years experience in software development area, 5+ years experience in online game development, 5 years experience in blockchain industry.<Br/> Sophisticated at blockchain kernel technology and decentralized application design.<Br/>
Former game-server engineer at 4399.com, a forefront online game platform in China.<Br/>
Former senior blockchain engineer at liquefy.com, a STO platform in HK.<Br/>
Former senior blockchain architect at linear.finance(Symbol:LINA), a decentralized derivatives exchange on ETH/BSC/Moonbeam.<Br/>
Former senior blockchain architect at conv.finance(Symbol:CONV), a decentralized assets management platform on ETH/BSC/Moonbeam.<Br/>
Senior blockchain architect at polkaex.io(Symbol:PKEX), an IDO & AMM-swap platform on Astar/Shiden network.<Br/>

- William Chang (Founder):<Br/>
Blockchain enthusiast and investor since 2015. Cofounder of PolkaEx, of which the ATH rate of return reached over 1,000%.<Br/>

- Vincent (Product Manager):<Br/>
Blockchain researcher since 2016. Cofounder of PolkaEx.<Br/>

### Future Plans

- 2022/4 until 2022/5/31:<Br/>
Private A & B fundraise<Br/>
Organize multiple AMAs to further promote<Br/>
Build the Sirius ecosystem with partners on the Astar chain<Br/>
Partnership rewarding program<Br/>
Multisig for smart contracts<Br/>
Rewarding dashboard launch (one place to see all rewards)<Br/>
Public fundraise<Br/>
Statistics / Analytics with subgraph<Br/>

- 2022 Q3: (Sirius Ecosystem)<Br/>
Launch additional pools<Br/>
Protocols optimization<Br/>
LP Pools creation<Br/>
Website V2 launch<Br/>
DApp V2 launch to provide a smoother user experience<Br/>
DAO launch<Br/>
Permissionless pool creation<Br/>
Sirius API & SDK publish<Br/>
Unlock Transfer of $SRS<Br/>
Launch pools for anyWBTC/cWBTC and/or anyETH/cETH<Br/>

- 2022 Q4: (Multichain and DAO)<Br/>
Multichain/crosschain investigation<Br/>
Native bridge on polkadot parachain research<Br/>
Smoothly move governance from committee to DAO<Br/>
Crypto pools creation with non-pegged pairs<Br/>
