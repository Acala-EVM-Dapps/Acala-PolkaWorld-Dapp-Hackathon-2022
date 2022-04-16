# Acala x PolkaWorld Dapp Hackathon 2022

- Project Name: RainbowDAO Protocol
- Team Name: RainbowCity Foundation
- Project online usage link: http://daofactoryacala.rainbowdao.io/
- Payment Address: 258vjrgUqRFRdGcDZuzWnWEPwKbshm4seXo6FUsUHtUTw6NL
- Video URL: https://youtu.be/rolQvBTWt2E

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

RainbowDAO protocol is a multi-chain infrastructure service protocol that focuses on ceating the components of Web3. Anyone can create and manage their own DAO organization through it, including independent DAO,alliance DAO, parent DAO and child DAO. Besides, a management department can also be achieved with the DAO that the protocol creates. There are currently three versions of RainbowDAO Protocol, which are developed in three different smart contract languages: Solidity, Ink! and Near.
RainbowDAO Protocol Solidity will be mainly deployed on Ethereum, BNB, Poygon, Avalanche,Fantom and any EVM supportive L2 networks, as well as on all EVM supportive para-chains within the Polkadot ecosystem.RainbowDAO Protocol Ink! will be deployed on all Wasm supportive parachains within the Polkadot ecosystem, to provide DAO infrastructure service for all DAO organizations on the parachains. RainbowDAO Protocol Near will then mainly deployed on NEAR network, to provide DAO infrastructure service for all DAO organizations on it.
As the RainbowDAO Protocol expands , we are working on new versions for other new public chains such as Solana, Terra, Agorand and Cosmos. Meanwhile, we are diving into the development of DAO infrastructure products that are based on Acala with Substrate.

To better serve all types of DAO organizations, we have built a complete set of DAO infrastructure technical lines focusing on the whole DAO ecosystem, including eight categories of more than 30 independent Web3 tools-kits.
These eight categories comprise of DAO Organizational Management System, DAO Token Management System, DAO Personnel Management System,
DAO Voting and Proposal Management system, DAO Financial and Vault Management system, DAO Fund raising Management System , DAO Marketing and Contributions Management System and DAO ecological tool management system.
The eight ecosystems contain thirty independent management modules, each of which is an independent Web3 tools system. All modules make up the complete DAO infrastructure technical lines and each module can independently function or can be freely combined with one another through smart contracts. Therefore, all types of DAO organizations' demand has been met in terms of unified features as well as diversity needs and this makes our DAO organizations flexible as Lego come true.

Meanwhile, in the RainbowDAO Protocol, we brought up a new concept of DCV to take it as the center of all DAO tools development. DCV stands for DAO Controlled Value.
In this context, value is controlled by different levels of DAO rather than by certain individual or any centralized entity. Through the governing contracts of DAO, DAO controls every core parameter and decision switch in the protocol and it is determined by all governing Token holders through voting to move forward.
The overall planning of RainbowDAO Protocol is too huge, and the overall development is expected to take 3 to 5 years. We will decompose the entire development plan into different stages, rhythm and step-by-step implementation.

![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/11-Rainbow-DAO-Protocol.png)

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


### Product function display of RainbowDAO protocol

This chapter will elaborate the functions of three products of the RainbowDAO protocol, especially the establishment of the product structure of the DAO factory and the logical relationship between different levels of DAOs to offer you a clear understanding of the functional framework of the RainbowDAO protocol.

The RainbowDAO protocol belongs to the DAO basic framework protocol. Anyone and any organization can establish an independent DAO with the help the RainbowDAO protocol. We call this DAO an independent DAO. This is the most basic functional module of a DAO. By this independent DAO, three-part expansion can be carried our and finally make this DAO infinitely upgradeable and expandable, allowing it to accommodate tens of thousands or even hundreds of thousands of user groups.

![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/8-Product-function-display-1.png)

⑴ Scale up: Alliance DAO
An independent DAO can go upwards - join a Alliance DAO and become a part of it, such as investment Alliance DAO, media Alliance DAO, social Alliance DAO, development Alliance DAO, etc. Similarly, DAO alliances in different regions can be set as well, such as European Alliance DAO, Asian Alliance DAO and American Alliance DAO.

In Alliance DAO management, due to the nature of the alliance, an independent DAO can freely choose to join or leave an alliance without the permission of the Alliance DAO. Alliance DAO have no rigid management or ownership requirements between each other.

⑵ Scale Out: Parent DAO and Child DAO
An independent DAO can go downwards to establish its child DAO, like the relationship between the parent company and the subsidiary. Each child DAO is identical to an independent DAO in terms of functional modules but it belongs to this independent DAO. The parent DAO(independent DAO) has the right to govern the child DAO, which cannot exist independently of the parent DAO unless approved by a referendum launched by its parent DAO.

The child DAO is created by the parent DAO, which has the authority to control the child DAO. The subDAO established by the child DAO can be governed by the child DAO and the parent DAO jointly. The child DAO has authority only over its direct subDAO. For instance: A(a parent DAO) creates B(a child DAO), B creates C(the subDAO of B) and C creates D(the subDAO of C). A governs B, C and D. B can only governs C and B has no right to control D. The parent DAO can perform cross-level management on all child DAOs, but the child DAO cannot do cross-level management.

⑶ Scale In: DAO department management

![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/8-Product-function-display-2.png)

Each independent DAO can go inward to establish a management department of its own. In this way, each independent DAO can have its own clear organizational structure. This is also the core function of the RainbowDAO protocol that we have been emphasizing. We believe that any DAO should have multiple departments working together.

In the RainbowDAO protocol, each department established by an independent DAO is equivalent to an independent small DAO and has various basic functions of DAO. It's just that it is not an independent DAO in nature, but a sub department of an independent DAO. In our overall product planning, the management authority of these sub departments is demonstrated by multi-signature smart contracts - a multi-signature committee responsible for managing this department, instead of by voting conducted by all DAO members to achieve governance. That is the decentralization mechanism of DAO management, which delegates power to different departments.

In the same way, a department can continue to set up departments to further decentralize and distribute powers so that the collaborative work can be finished through the multiple layers of the department. This is the most basic function we believe a DAO with hundreds of thousands of members must have.

In this diagram over the functions of RainbowDAO products, examples are provided to help you understand the product logic. First of all, we have an independent DAO. In the department management of this independent DAO, we established five independent departments: the Human Resources Management Committee DAO, the Financial Management Committee DAO, the Technical Management Committee DAO, the Operation Management Committee DAO and Investment Management Committee DAO. These five departments are responsible for the specific operations of this independent DAO.

Besides, these five independent departments are divided into different groups to refine the division of labor. Here are some examples: the Human Resources Committee DAO is divided into organizational management group and the salary management group; the Financial Management Committee DAO is divided into the budget management group and the fund allocation management group; the Technology Management Committee DAO is divided into the technology development management group and grant management group; the Operation Management Committee is divided into the brand management group and the promotion management group; the Investment Management Committee is divided into the project review management group and the foreign investment management group and so on.

Most of these different management groups also exist as multi-signature management committees. That is also a function of DAO's delegation of power to the subordinate independent departments. Complex coordination is achieved through refined division of labor, which is of the same pattern as the operation of a company. Only with clear division of labor and responsibilities can efficiency and execution be possibly improved.

### RainbowDAO protocol design mechanism

By the information above, you can learn the planning and design of the RainbowDAO protocol. That is a large project that allows DAO to expand and upgrade infinitely. So how is the RainbowDAO protocol constructed as a whole? What is the structure of the protocol itself? In this part, we’ll focus on the architecture design of the RainbowDAO protocol itself to give you a better understanding of the implementation method of the RainbowDAO protocol.

You can understand the design structure of the RainbowDAO protocol from the following three levels step by step.

![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/9-Design-Mechanism-1.png)

⑴ Tier 1 Architecture: RBD Governance Dao
The first level of the RainbowDAO protocol is RBD governance DAO. RBD is the governance token of the RainbowDAO protocol. The holders of RBD are members of the RBD governance DAO and are responsible for the governance of the entire RainbowDAO protocol. The RBD governance DAO manages all the parameters and conditions of the RainbowDAO protocol as a whole, and RBD holders can determine the modification and optimization of each parameter of the RainbowDAO protocol through a referendum, realizing the unlimited expansion and upgrade of the RainbowDAO protocol. The RBD governance DAO belongs to the overall control center of the RainbowDAO protocol, and all management powers belong to the owners of all RBD governance tokens.

⑵Tier 2 Architecture: Basic Protocol Layer
The second level of the RainbowDAO protocol is the protocol of the RainbowDAO. It is a part of the protocol, not part of the DAO created by the protocol. It contains six parts: the rainbow core contract, the membership management contract, the revenue management contract, the web3 suite tool contract, the DCV controller contract and the DAO factory contract. The DAO factory contract also belongs to the third level of the RainbowDAO protocol, which is mainly used for the control and management of the DAO created by the protocol.

The rainbow core contract consists of four parts: the role management contract, the authority management contract, the route management contract and the rainbow core control contract. It is the permission control center of the RainbowDAO protocol, which manages the authority and roles of the entire protocol and is responsible for the iteration and upgrade of the RainbowDAO protocol.

The membership management contract is responsible for managing the members of the entire protocol, including the management of the identity information of the member and the management of the invitation or recommendation among members. All invitation information is stored in this contract. In the future, all modules related to member management will be put in this part, including but not limited to credit system, reputation system, employee recruitment system, work representation system, etc.

The revenue management contract belongs to the revenue management control center of the RainbowDAO protocol. RainbowDAO protocol itself sets up a series of income categories. Fees are required when contracts are applied; DCV vault transfers will charge a certain percentage of transfer fees; the usage fees of the protocol will be charged based on the number of members in a DAO. In this way, the RainbowDAO protocol can capture value through the diversification of income types. More people using the agreement means more income and finally, income will go back to the holders of RBD in a certain proportion.

Web3 suite tool contracts is the center of management for some tool contracts, such as ERC20 token manufacturing factory contracts, multi-sign wallet management contracts, token airdrop system contracts, token lock-up system contracts, etc. In the future, tool contracts can be under this module.

The DCV controller contract is the center of controller management of the RainbowDAO protocol. Various controllers can be made here, especially those related to DeFi management.

⑶ Tier 3 Architecture:DAO Factory

![](https://raw.githubusercontent.com/RainbowDAO/01-RainbowDAO-Factory/main/PIC/RainbowDAO/9-Design-Mechanism-2.png)

The above contract belongs to the overall level of the RainbowDAO protocol. The third level belongs to the DAO factory contract, which is mainly used for the creation and management of DAO in a large scale.

The DAO factory contract can be divided into three parts. The first part is DAO type contract. These types are independent DAO, alliance DAO and parent-child DAO. That determines the basic attribute of the established DAO.

The second part is the DAO initialization contract, which is used for DAO creation and information initialization and the third part is the DAO management contract for the basic management of the contract after the establishment of the DAO.

The DAO management contract also has the right to conduct management. There are three types of administrators: single wallet address, multi-signature wallet address and the governance token DAO. Generally, the governance DAO acts as an administrator by default, and all governance token holders govern the entire DAO. Management authority can be transferred between different categories.

The DAO management contract is divided into 7 modules. The first module is the DAO basic setting contract, responsible for the setting of DAO basic information. The second module is the DAO authority management contract, responsible for the authority and role management in this DAO and its termination and liquidation. The third module is the DAO member management contract, responsible for the management of members in this DAO, including the entry threshold and the deletion of members. The fourth module is the DAO treasury management contract, responsible for management of DAO vault. The fifth module is the DAO voting management contract, responsible for a series of settings of voting rights. The sixth module is the DAO proposal management contract, responsible for DAO proposal management. The seventh module is the DAO department management contract, responsible for the department management of this DAO.

The above three major parts constitute the basic framework of the RainbowDAO protocol. RainbowDAO protocol spares no effort to achieve upgrading and expansion on the basis of these basic frameworks, to truly evolve into a viable and promising system and become the infrastructure of DAO industry.


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

#### Awards and Honors

- RainbowDAO protocol received contributions from over 5000 contributors in Gitcoin 12 grant, becoming one of the most popular projects in Gitcoin 12.  https://gitcoin.co/grants/4019/rainbowdao-protocol

- RainbowDAO protocol won three awards in 2021 DAO  Global Hackathon , including DAO Factory winning the first prize in Multi-Chain Track,  NFT the second prize in Community & NFTs track, Multisig Committee the third prize in Core DAO Tech track.  https://hackforfreedom.org/#winners

- RainbowDAO protocol won the first prize in DAO tool track in Metaverse Hackathon.  https://metaversealliance.com/results

- RainbowDAO Foundation received the first grant from Web3 Foundation, becoming the 12th recipient of the Web3 grant.  https://medium.com/web3foundation/web3-foundation-grants-wave-12-recipients-7e2b6bfb69be

- RainbowDAO team won three awards in the NEAR MetaBUILD Hackathon sponsored by Near Foundation.  https://devpost.com/submit-to/13979-near-metabuild-hackathon/manage/submissions

#### Media coverage

1.Rainbowcity Foundation announces official launch of DAO infrastructure project

https://ambcrypto.com/rainbowcity-foundation-announces-official-launch-of-dao-infrastructure-project/, Dec 17,2021

2.Rainbowcity Foundation Launches RainbowDAO Protocol in Gitcoin Grant 12 https://cryptopotato.com/rainbowcity-foundation-launches-rainbowdao-protocol-in-gitcoin-grant-12/, Dec 17,2021

3.Rainbowcity Foundation Announces the Official Launch of DAO Infrastructure Project RainbowDAO Protocol in Gitcoin Grant 12 https://u.today/press-releases/rainbowcity-foundation-announces-the-official-launch-of-dao-infrastructure-project, Dec 16,2021

4.The 2021 DAO Global Hackathon ended and the RainbowDAO team won three awards! https://finance.yahoo.com/news/2021-dao-global-hackathon-ended-174200673.html?.tsrc=fin-srch, Dec 27, 2021

5.The 2021 DAO Global Hackathon ended and the RainbowDAO team won three awards! https://apnews.com/press-release/kisspr/technology-philanthropy-singapore-baae13a7c821e4e7bcf0dc6c62de0b91, Dec 27, 2021

6.RainbowDAO is the champion of Metaverse Hackathon in DAO tool track https://ambcrypto.com/rainbowdao-is-the-champion-of-metaverse-hackathon-in-dao-tool-track/, Feb 1, 2022

7.Web3 Foundation Grants — Wave 12 Recipients https://medium.com/web3foundation/web3-foundation-grants-wave-12-recipients-7e2b6bfb69be, Jan 10, 2022

8.Multi-chain DAO infrastructure protocol RainbowDAO receives a Web3 Foundation grant https://medium.com/rainbowcity/multi-chain-dao-infrastructure-protocol-rainbowdao-receives-a-web3-foundation-grant-143e9fac63bd, Feb 12, 2022

9.Multi-Chain DAO Infrastructure Protocol RainbowDAO Receives a Web3 Foundation Grant https://coincodex.com/article/13686/multi-chain-dao-infrastructure-protocol-rainbowdao-receives-a-web3-foundation-grant/, Feb 16, 2022

### Future Plans
- 2022/4 until 2022/6 : Focus on product development
- 2022/7 until 2022/9 : Complete prototype, tests etc.  
- 2022/10             : Launch product
