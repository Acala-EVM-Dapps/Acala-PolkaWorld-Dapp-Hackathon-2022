# Acala x PolkaWorld Dapp Hackathon 2022

- Project Name: RainbowDAO Protocol
- Team Name: RainbowCity Foundation
- Project online usage link: http://daofactoryacala.rainbowdao.io/
- Payment Address: Acala(aUSD) payment address.
- Video URL: 

## Testnet Deployment Information

Network Name: Acala Test Network 
RPC URL: https://tc7-eth.aca-dev.network

Contract deployment address

DaoFactory: 0x0fd9968e36523466a9c9a38d2581fe0e199f8161

Authority: 0x8bBef131a546d8151297e96C68AE614E5a80037d

DaoBaseInfo: 0xb8Fda38562bd77dD8D2A0335e539D4188DF030a3

DaoManage: 0x2b981316D9680443D590914916BeaF7d7A136Bf0

DaoMembers: 0xe1240c60f37ae1CdeC036591C9814c1Fce8d986c

ERC20Factory: 0x2697c5DAC9c13D9EA97F097ee5E7702d195E28dc

RouteManage: 0xD1279a3EC682439589B3AACfC5618b74439f8168

Vault: 0xeB317D6422F25887B4Fac0b880aBf4Da6040174F

Vote: 0xf9A3f8eb156B49Ae50ebe0A9e45A46aa22766795

## Project Overview 📄

### Overview

RainbowDAO Protocol is Multi-chain DAO Infrastructure Service Protocol

RainbowDAO protocol is a multi-chain infrastructure service protocol that focuses on ceating the components of Web3. Anyone can create and manage their own DAO organization through it, including independent DAO,alliance DAO, parent DAO and child DAO. Besides, a management department can also be achieved with the DAO that the protocol creates. There are two versions of RainbowDAO Protocol, Solidity version on EVM and Ink! version on WASM.The Solidity version is mainly deployed on Ethereum, BSC, Polygon, Avalanche, Fantom, and various L2 networks; the Ink! version is mainly deployed on the parallel chains on the Polkadot and Kusama relay chains, as well as other blockchains developed with the substrate framework,such as Acala.

- An indication of how your project relates to / integrates into Acala / Karura EVM+.
- An indication of why your team is interested in creating this project.

### Project Details

Based on the RainbowDAO Protocol, we realized three major innovations of DAO protocol, which are in line with the eight major characteristics and eight principles of the development of the industry. In this chapter, we will elaborate on these ideas and concepts to share them with all those who are interested in the development of DAO industry.

(1）Three major innovations of the RainbowDAO Protocol
![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/5-Three-major-innovations.png)

① DAO governance function
In the entire RainbowDAO Protocol, we have innovatively invented governance DAO, which is of great significance to the entire protocol and it complies with the idea of decentralized governance. Governance of DAO is mainly demonstrated in two levels:

First, the entire RainbowDAO protocol is controlled by a governance DAO. The governance token, RBD, will be released. Holders of RBD govern the RainbowDAO Protocol. They decide the modification of the parameters of the entire protocol through referendum voting to constantly upgrade the protocol.

Second, each independent DAO created through the RainbowDAO protocol will generate a governance DAO and a corresponding governance token. The governance DAO controls the independent DAO and is responsible for the modification of parameters in the DAO system to achieve the upgrading and expansion of this DAO.

The combination of these two points makes the entire protocol no longer rigid, but an agreement that truly has vitality and capable of growth. The code design of the entire governance DAO protocol refers to the governance module of compound.

② Rainbow Core function
While upgrading the DAO management protocol, we coined RainbowCore as the core control center of the RainbowCity Protocol. RainbowCore module is divided into four parts, roleManage, privilegeManage, routeManage and core.

RoleManage contract is responsible for managing different roles in protocol. PrivilegeManage contract is responsible for managing the corresponding rights of these roles. RouteManage contract is responsible for the address of all contracts involved and can conduct contract address management. Core contract is for the entrance management of these three contracts, overall planning and coordination. The four parts of the RainbowCore make RainbowDAO protocol a whole that can be flexibly matched with different roles and rights and achieve unlimited expansion and upgrading of the protocol.

③ DCV Controller function
Based on the function of governance DAO and RainbowCore, we developed the DCV controller function, which makes the entire RainbowDAO protocol infinitely expandable. DCV is the core function of RainbowDAO protocol. Each DAO is based on the management of DCV which is an independent treasury system. We have innovatively developed the DCV controller function. Each controller is a series of existing rules written by smart contracts to complete the specified contract operations. In this way, the management of DAO obtains unlimited scalability. Through the DCV controller function, each DAO itself can flexibly control the assets in DCV.

For example, a DEX liquidity controller can be created. Through this controller, we can control the addition or removal of liquidity from the funds in the DCV to the specified DEX trading pair, so that the funds can increase in value and generate income. We can also create a stablecoin DCV controller and use this controller to control the funds in the DCV to mint stablecoins.

Each controller is contained by governance DAO of the DAO and is decided whether to be put into use or not by community voting and referendum. In this way, as long as we have a clear demand and tailor an independent DCV controller in advance, then we can govern the DAO to operate the corresponding DCV controller, achieving unlimited types of operations. The richer our controllers are, the more diversified the management of funds in the DCV.


### Ecosystem Fit

As the crypto world continues to prosper and make innovation, various forms of DAOs that are guided by decentralization emerged. These DAOs are exploring cutting-edge governance methods in their own ways, they keep carrying out all forms of organizational innovation and innovation in system. To better serve these different types of DAOs, tool DAOs that focus on developing DAO infrastructure appeared. Hopefully through the development of corresponding DAO tools, the operation and governance of DAO can be better realized.

These DAO tools include but are not limited to DAO framework construction, voting system management, proposal system management, bounty system management, multi-signature wallet management. At present, most of these projects are operated on the Ethereum network, such as aragon and DAOstack that are dedicated to DAO framework; gnosis-safe that works on Ethereum multi-signature wallet management; Snapshot, a snapshot platform that zooms in off-chain voting; Tally, a governance platform to track voting records on different DeFi protocol chains, which holds project crowdfunding by Mirror; Miso, an IDO platform devoted to project financing; Gitcoin, a developer platform committed to providing grants to developers. At the same time, in the Polkadot ecology, platforms for DAO tool have also showed up one after another, such as subDAO and dorafactory. These tool DAO protocols all contribute to the prosperity and development of the entire DAO ecosystem.

Last year witnessed the explosive growth of various DeFi and NFT protocols and the remarkable achievements different governance DAOs have made. That made the demand for tool DAOs soar. But after research for half a year, we found that although there are already many tool DAO projects in the crypto world, the vast majority of them are still in the early stage of development, and the tools they provide are far from satisfying for the needs of the industry.

During the past three years, our team tried nearly all tool DAO projects on the market. After systematic analysis, we discovered that, however, tool DAO is faced with the following problems:

![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/2-Current-problems.png)

(1) Incapable of managing sophisticated coordination task
The function of most of the tool DAO products is too simple currently. Take the product for DAO framework, for example, what it provides is merely the building of DAO, DAO voting and fund management, lacking complicated or specified capacities. Besides, we see no function for section management in any DAO framework, let alone parent DAO and child DAO and alliance DAO. We often compare DAO to an upgraded version of a company, but the current DAO tools are far from meeting the needs of DAOs designed for companies.

Companies, large or small, are all composed of many departments. Therefore, any DAO must exist as a whole and it should be divided into different departments for different functions. Similarly, a parent company can have one or more subsidiaries, then can a DAO have one or more child DAOs? There are also some different types of companies that can join certain industry associations or alliances, so can independent DAOs form an alliance DAO?

From these simple questions, we can see that the current tool DAO products are still in their infancy. They can only achieve the simplest functions, far from fulfilling complex collaborative work. Today we put forward the RainbowDAO protocol with the most basic goal to achieve some relatively complex collaboration through the establishment of a series of standard tools.

(2) Low expansibility
We found that most of the current tool DAO products have poor expansibility and cannot accomplish functional iteration and upgrade. When a tool for DAO is developed, few products can achieve large-scale iteration or upgrade and most of them provide services for the DAO community with fixed functions. The poor expansibility also directly restricts the development of DAO.

The continuous development of DAO will inevitably leave the previous tools used behind because the tools cannot be expanded or upgraded. So DAO will have to select a new set of tools. That is a common problem in DAO industry.

(3) Low compatibility
We found that most of the tool DAO products are not compatible. Products or protocols among these products cannot work compatibly, let alone collaborative governance. The reasons are, on the one hand, different DAO tools are developed by different teams with divergent concepts, it is difficult for different products to cooperate with each other.

On the other hand, the development standards of various tool DAOs are different. Without a unified api or development document, DAOs can only use one or more products in isolation complying to their actual needs.

(4)Low diversity
Tool DAO products, most of them, lack diversity and can only meet the common requirements of DAO. They are not good enough to meet the needs of diversified and differentiated DAOs yet diversification and differentiation are exactly the characteristics shared by different types of DAOs.

(5)Poor user experience
We found that the tool DAO products on the market currently are commonly not user-friendly. Especially for novices. The most critical reason for such poor operability lies in the design logic and implementation details of the product itself. Many teams only develop corresponding products and tools in conceptual level, they do not really think about users in real operation. In the end, the product was developed but no one would use it.

(6)Poor innovation
We have found that tool DAO products nowadays are not innovative enough and few of them have particularly eye-catching or original features. They learn from each other so their functions are similar. None of them managed to essentially solve some of the spiny problems in DAO industry. As a result, all developed products are not usable will be reduced to a tool merely for capital speculation.

The 6 points above are some of the pervasive headaches existing in tool DAO products in the industry that we have summarized after half a year’s research. It’s currently difficult for these products to get rid of the those headaches in DAO industry.



![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/6-Eight-features.png)

In the RainbowDAO protocol, we have achieved three unprecedented innovations, namely, the governance DAO function, the Rainbow core function, and the DCV controller function to meet the needs of DAO industry. These three innovations can be used either independently or combined together. When these three functions are organically combined, the RainbowDAO protocol has unlimited scalability and upgradeability, offering unlimited diversification to DAOs under RainbowDAO Protocol. These innovations give RainbowDAO protocol the following eight characteristics:

① Modularity
Each function of RainbowDAO protocol can exist as an independent module, which can easily trigger upgrading and evolution of the protocol.

② Plug-in
Each module of the RainbowDAO protocol is very flexible like a plug-in.

③ Composability
Each module of the RainbowDAO protocol can be combined with each other. Simple modules can work together to form a powerful one.

④ Scalability
Based on the modular combination, the RainbowDAO protocol has very strong scalability and new functions can be added through the addition of modules.

⑤ Detachability
The modules of the RainbowDAO protocol can be disassembled to streamline the DAO functional modules and adapt to actual needs.

⑥ Interoperability
Each module of the RainbowDAO protocol is independent. Based on the smart contract created by INK, each module can interact with each other.

⑦ Scalability
The RainbowDAO protocol can be combined, extended, and disassembled, which gives the RainbowDAO protocol strong scalability. The protocol can be adjusted according to the actual condition of each DAO.

⑧ Growth
Based on the first 7 characteristics, the RainbowDAO protocol will evolve into a viable system that can upgrade infinitely with a decentralized idea.




## Team 👥

### Team members

Team leader:  
- Mr. Kunyuan        https://github.com/RainbowDAO  

Team members:
- Alexunderlett        https://github.com/Alexunderlett      
- HarrisWongg          https://github.com/HarrisWongg
- Ivanvian             https://github.com/ivanvian
- SylvanusVen          https://github.com/sylvanusVen
- MichaelHookon        https://github.com/michaelHookon

### Contact

- Contact Name:   Jackie Zhao
- Contact Email:  rainbowcitydao@gmail.com
- Website:        https://www.rainbowdao.io/

### Team's experience

Awards and honors:

- https://metaversealliance.com/results
- https://hackforfreedom.org/#winners
- https://dorahacks.io/zh/buidl/2394?roundProj=1553
- https://devpost.com/software/bit-civilization?ref_content=my-projects-tab&ref_feature=my_projects
- https://devpost.com/software/dao-exchange-pool-system?ref_content=my-projects-tab&ref_feature=my_projects
- https://devpost.com/software/rainbowdao-protocol?ref_content=my-projects-tab&ref_feature=my_projects

### Future Plans
- 2022/4 until 2022/6 : Focus on product development
- 2022/7 until 2022/9 : Complete prototype, tests etc.  
- 2022/10             : Launch product
