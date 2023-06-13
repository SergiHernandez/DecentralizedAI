// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.8.0;

contract DecentralizedAi{

    // variables
    string public name;
    string public symbol;
    uint256 public totalSupply;
    address public model;
    address public dataset;
    mapping(address => uint256) private balances;

    // constructor
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        address _model,
        address _dataset)
    {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        model = _model;
        dataset = _dataset;
        balances[msg.sender] = totalSupply;
    }

    //functions
    function train() public{

    }

    function predict() public {

    }

    function addData() public {

    }

    function getData() public {
        
    }

}