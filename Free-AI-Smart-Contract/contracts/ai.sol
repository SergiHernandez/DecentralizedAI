// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.8.0;

import "../interfaces/IERC20.sol";

contract DecentralizedAi is IERC20{

    // variables
    string public name;
    string public symbol;
    uint256 public totalSupply;
    address public model;
    mapping(address => uint256) private balances;

    // constructor
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        address _model)
    {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply;
        model = _model;
        balances[msg.sender] = totalSupply;
    }

    //functions
    function train() public{
        (bool success, ) = model.call(abi.encodeWithSignature("train()"));
    }

    function predict() public {
        (bool success, ) = model.call(abi.encodeWithSignature("predict()"));
    }

    function addData(int _x, int _y) public {
        (bool success, ) = model.call(abi.encodeWithSignature("addData(int, int)", _x, _y));
    }

    function getData(uint256 i) public {
        (bool success, bytes memory data) = model.call(abi.encodeWithSignature("getData(uint256)", i));
        return data;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balances[sender] >= amount, "ERC20: insufficient balance");

        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }
}