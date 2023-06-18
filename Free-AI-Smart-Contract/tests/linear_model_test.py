from brownie import accounts, web3, LinearModel
from random import randint

def test():

    me = accounts[0]

    epochs = 2000
    alpha = 0.0001
    decimals = 10000000
    alpha_int = alpha*decimals

    lm_contract = LinearModel.deploy(decimals, alpha_int, {"from": me})

    x = [0, 20, 50, 10, 70, 90, 20, 30, 10]
    y = [70, 80, 40, 90, 20, 0, 40, 60, 90]

    web3_lm = web3.eth.contract(address=lm_contract.address, abi=lm_contract.abi)

    print("Cost of calling addData() once", web3_lm.functions.addData(20, 30).estimate_gas())

    total_estimated_gas = 0

    for i in range(len(x)):
        total_estimated_gas += web3_lm.functions.addData(x[i], y[i]).estimate_gas()
        lm_contract.addData(x[i], y[i], {"from": me})

    print(f"Est. Gas after adding data:  {total_estimated_gas}")
    print("")
    
    #for i in range(len(x)):
    #    print(lm_contract.getData(i, {"from": me}))
    
    lm_contract.initParams(10, 2)

    print("Cost of calling train() once", web3_lm.functions.train().estimate_gas())

    for i in range(epochs):
        total_estimated_gas += web3_lm.functions.train().estimate_gas()
        tx = lm_contract.train({"from": me})
        if i%200 == 0:
            #print(tx.gas_used)
            print("Epoch", i)
            params = lm_contract.getParams({"from": me}) # no fa falta el from me
            print(params)
    
    print(f"Est. Gas after adding data and training:  {total_estimated_gas}")

    print("W0 =", params[0]/decimals)
    print("W1 =", params[1]/decimals)
