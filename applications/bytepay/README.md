# Acala x PolkaWorld Dapp Hackathon 2022

- Project Name: BytePay
- Team Name: CPL (crypto pay labs) 
- Project online usage link: https://bytepay.online/
- Payment Address: 2242iyfHKCtnE9jMMVta7yzntgC3yMUu6KfgsYEaffLabo7f

## Project Overview 📄

### Overview
#### What is BytePay?
- Coding to earn! Sell opensource product as NFT!
- Bytepay is a platform that supports paid tasks to complete open-source tasks on Github. And the project owner or maintainer can sell the opensource product like (bin files apk etc.) as NFT. 
- You can create paid open-source tasks in issue. Those who complete the task as required can receive tokens after the pull request accepted. The owner can upload opensource product for example a bin file to bytepay, the consumer who need use the bin file need to buy the NFT and get the download permission.
#### Why BytePay
- So many open source developers are too poor!
- Developers can't support themselves through open-source, so they have to be hired by some companies
- Many excellent open-source projects have no business model.
#### Integration with Acala / Karura EVM+
- Bytepay supports payment in aUSD
- Bytepay supports decentralized transaction on Acala EVM+
- Bytepay supports opensource product owner to mint NFT on Karura

### Project Details

#### Description of the core function
- User management, create an account for each developer
We will provide login function, you can login our website using Github, and we will create an Acala account for each user by default
- Repo & webhook management
We will fetch your GitHub repo list, so you can activate the repo you want to integrate with Acala, the webhook module will listen to the pay event and trigger the transform module to pay developer aUSD
- Address binding
Develop using GitHub issue comments to bind their Acala address.
- Recharge management
Recharge aUSD to your platform account
- Transfer contract
We will provide a contract, provide transfer limit, whitelist, and transfer function.
- Task management
Create a paid task by comment an issue, it will trigger the create task event through the webhook, and the webhook server will save the task and show it on our page, when the developer complete the task, will trigger transfer module to pay the developer
- Transfer module
Trigger a payment by comment an issue, like /pay Bob 1 aUSD, the payment will be transferred to the developer platform account
- Withdraw module
Withdraw the aUSD from our platform to developer's own wallet, if the developer bind its own address, payment will be transferred to the account directly
- Informal
The developer will receive the event, tell him how to withdraw aUSD from our platform, the robot will comment on the issue.
- Mint NFT
Using Open-source Product like bin apk docker image to mint NFT.
Mange the NFT price, circulation, and other metadata.
- NFT market
Marketplace to show all open-source NFTs, and search NFT what you want.
- NFT details and buy NFT
Details to show the NFT metadata like price, owner, version.
Anyone can buy what open-source product they need.

#### Deployment step instructions
#### How to run this project (dev mode)

#### 1. Run docker command

```bash
docker run --rm -p 10086:80 sulnong/bytepay:app-v1
```

#### 2. Open your browser

Open http://localhost:10086
<br/>

#### How To Run Test

#### Method 1 - By docker
```bash
docker pull sulnong/bytepay:test
docker run --rm sulnong/bytepay:test
```

#### Method 2 - By local environment
```bash
git clone git@github.com:bytepayment/bytepaytest.git
cd bytepay/test
npm i
npm run test
```

#### Test Report

After you run the command

**Notice**: Test will create an issue and does the main workflow like create task, apply task and pay for the task.

`In the end, test report would print an issue html url, please visit to check detail.`

You will get a test repost as following:

```bash
  Github Public Repo
    ✔ get() should be ok (1545ms)

  Github Public Userinfo
    ✔ get() should be ok (964ms)

  Interact With Repo
    ✔ userinfo:get() should be ok (2046ms)
    ✔ binded-repos:get() should be ok (1007ms)
    ✔ all-repos:get() should be ok (8579ms)
    ✔ unbind a binded repo should be ok (1118ms)
    ✔ bind a unbind repo should be ok (1246ms)

  Polkadot Related API
    ✔ userinfo:get() should be ok (901ms)
    ✔ polkadot-address:get() should be ok (809ms)
    ✔ polkadot-mnemonic:get() should be null (715ms)
    ✔ polkadot-account-info:get() should be ok (800ms)
    ✔ developer:bind_own_address() should be ok (2291ms)
    ✔ polkadot-transfers-record:get() should be ok (2380ms)
    ✔ polkadot-transfer:signAndSend() should be ok (1394ms)
    ✔ polkadot:ensure-transfer-success() should be ok (7984ms)

  Get Tasks From Bytepay
    ✔ dev_task:get() should be ok (2866ms)
    ✔ author_task:get() should be ok (1473ms)

  Interact With Repo
    ✔ Issue:create() should be ok (1196ms)
    ✔ Task:create() sould be ok (3206ms)
    ✔ Task:apply() should be ok (3531ms)
    ✔ Task:pay() should be ok (4686ms)
    ✔ Task:check() should be ok (2000ms)


  22 passing (60s)
Please visit https://github.com/bytepayment/bytepaytest/issues/4 check this full workflow...
```


### Ecosystem Fit

Help us locate your project in the Polkadot/Substrate/Kusama landscape and what problems it tries to solve by answering each of these questions:

- Where and how does your project fit into the ecosystem?
1. It enables all open-source project owners to pay developers with aUSD by BytePay, thus attracting more developers to use aUSD.

2. It enables owners of Acala ecosystem projects to pay developers by BytePay. Therefore, more and more developers will take part in Acala ecosystem projects.

- What need(s) does your project meet?

1. Bytepay is not only a solution for open source developer remuneration, but also a profitable solution for excellent open source projects. 

2. Through blockchain technology, Bytepay enables open-source projects to receive cryptocurrency commercial support for better future development. 

- What makes your project unique?

We are the pioneers of NFT of open-source product.


## Team 👥

### Team members

- Richard Fang: Team leader, core developer. As an expert in the field of cloud computing in one of the biggest Internet listed companies with 7 years of rich working experience. The author of a well-known cloud native project which has more than 8K stars and 4K paid enterprise users. 
- Fugen Wang: Background development. CEO of an Internet start-up company and manages more than a dozen employees with 7 years working experience. 
- Tang Chen: Top algorithm engineer, won the championship and top three in many national programming competitions in China, and the world's third in the StarCraft AI algorithm competition(SSCAIT). Github link: https://github.com/luanshaotong
- Yang Li: Front-end development. Android/IOS front-end engineer with 5 years working experience. Github link: https://github.com/geekFeier
- Sun Long: A core member of AI Research Institute which is one of the top AI-listed companies in China with 5 years working experience. Github link: https://github.com/sulnong
- Wei Zhang: An advertising director, one of the top AI-listed companies in China with 7 years of rich working experience.
- Layla Zhou: PD/PMO. Familiar with product design and project schedule management. Github link: https://github.com/layla1994

### Contact

- Contact Name: Richard Fang
- Contact Email: bytepayteam@outlook.com
- Website:https://bytepay.online/


### Future Plans

Please include here

- how you intend to use, enhance, promote and support your project in the short term, and
- the team's long-term plans and intentions in relation to it.

1. To verify the feasibility of Bytepay, we will heavily use it in our own open source project which has 8k+ stars and plan to attract 100 developers to participate. At the same time, our open source project will also be available for sale in Bytepay NFT market.
2. We plan to attract and select five open source projects as the early adopters, and then investigate their demand as well as the willingness to renew. We will carry out large-scale marketing and promotion for Bytepay if more than 40% of the adopters says yes to us. 
