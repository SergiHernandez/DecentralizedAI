from brownie import accounts, LinearModel
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

    for i in range(len(x)):
        lm_contract.addData(x[i], y[i], {"from": me})

    #for i in range(len(x)):
    #    print(lm_contract.getData(i, {"from": me}))
    
    lm_contract.initParams(10, 2)

    for i in range(epochs):
        lm_contract.train({"from": me})
        if i%200 == 0:
            print("Epoch", i)
            params = lm_contract.getParams({"from": me})
            print(params)
    
    print("W0 =", params[0]/decimals)
    print("W1 =", params[1]/decimals)
