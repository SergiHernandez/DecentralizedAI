from brownie import accounts, Ai, Model, Dataset
from random import randint

def test():
    me = accounts[0]
    dataset_contract = Dataset.deploy({"from": me})
    model_contract = Model.deploy(dataset_contract, 2, {"from": me})
    ai_contract = Ai.deploy("Simple Linear Regressor", "SLR", 1e4, model_contract, dataset_contract, {"from": me})

    x = [0, 2, 5, 1, 7, 9, 2, 3, 1]
    y = [7, 8, 4, 9, 2, 0, 4, 6, 9]

    print("TESTING DATASET...")
    for i in range(len(x)):
        dataset_contract.addData(x[i], y[i], {"from": me})

    for i in range(len(x)):
        print(dataset_contract.getData(i, {"from": me}))

    print("TESTING MODEL...")
    model_contract.initParams(2, 8, {"from": me})#randint(-20, 20), randint(-20, 20), {"from": me})
    print(model_contract.getParams({"from": me}))
    
    EPOCHS = 100
    for i in range(EPOCHS):
        print(model_contract.totalError())
        model_contract.train()
        if i%20==0:
            print("Epoch", i, "-", model_contract.getParams({"from": me}))
    print(model_contract.getParams({"from": me}))