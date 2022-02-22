Edit migrations/2_deploy.js: Deployer of MalloryAttack should be the second accound from Ganache (or 3rd,..)

truffle migrate --reset
truffle console
bob = await BobWallet.deployed()
mal = await MalloryAttack.deployed()
val = await web3.utils.toWei('1','ether')
await bob.pay(bob.address,val,{value:val})      //optinal: multiple times
bal = await bob.balanceOfBob()
bal.toNumber()
await bob.pay(mal.address,val,{value:val})
bal = await mal.balanceOfAttacker()
bal.toNumber()
