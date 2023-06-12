// SPDX-License-Identifier: UNKNOWN 
// Some code from: kidwai/LinearModel.sol

pragma solidity ^0.8.0;

/*
library Math {

    function mul (uint a, uint b, uint decimals) internal pure returns (uint) {
        return a*b/10**decimals;
    }
    
    function div (uint a, uint b, uint decimals) internal pure returns (uint) {
        return a*10**decimals/b;
    }
    
    function sqr(uint a, uint decimals) internal pure returns (uint) {
        return mul(a,a, decimals);
    }
}*/

interface Dataset{
    function getData (uint256 i) external view returns(int, int);
    function getSize () external view returns(uint256);
}

contract Model{

    // THIS MODEL IMPLEMENTS A LINEAR REGRESSION FUNCTION

    //variables
    int a;
    int b;
    uint256 alpha_decimal_points; // alpha = 1/10**alpha_decimal_points
    uint public decimals = 12;
    Dataset dataset;

    //parameters

    //constructor
    constructor(address _dataset, uint256 _alpha_decimal_points){
        dataset = Dataset(_dataset);
        alpha_decimal_points = _alpha_decimal_points;
    }

    //functions
    /*
    function mul (uint _a, uint _b) private view returns (uint) {
        return Math.mul(_a, _b, decimals);
    }
    
    function div (uint _a, uint _b) private view returns (uint) {
        return Math.div(_a, _b, decimals);
    }*/

    function initParams(int _a, int _b) public {
        a = _a**decimals;
        b = _b**decimals;
    }

    function train() public{
        /*
        int total_error = 0;
        int total_error_x = 0;
        uint256 n = dataset.getSize();
        int x = 0;
        int y = 0;
        int y_predicted = 0;

        for (uint256 i=0; i<n; i++){
            //(bool success, (x,y)) = dataset.call(abi.encodeWithSignature("getData(i)", i));
            (x, y) = dataset.getData(i);
            y_predicted = predict(x);
            total_error += y - y_predicted;
            total_error_x += x * (y - y_predicted);
        }
        int da = (-2 * total_error)/int(n);
        int db = (-2 * total_error_x)/int(n);
        
        a = a - int(1/10**alpha_decimal_points)*da;
        b = b - int(1/10**alpha_decimal_points)*db; */

        uint256 n = dataset.getSize();
        int x = 0;
        int y = 0;
        int alpha = 1;
        int y_predicted = 0;
        for (uint256 i = 0 ; i < n; i++) {
            (x, y) = dataset.getData(i);
            y_predicted = predict(x);
            //a -= Math.mul(Math.mul(200, alpha, decimals), y_predicted - y, decimals);
            //b -= Math.mul(Math.mul(200, alpha, decimals), Math.mul(x, (y_predicted - y), decimals), decimals);
        }
    }

    function totalError() public view returns (int, int, int){
        int total_error = 0;
        int total_error_x = 0;
        uint256 n = dataset.getSize();
        int x = 0;
        int y = 0;
        int y_predicted = 0;

        for (uint256 i=0; i<n; i++){
            //(bool success, (x,y)) = dataset.call(abi.encodeWithSignature("getData(i)", i));
            (x, y) = dataset.getData(i);
            y_predicted = predict(x);
            total_error += y - y_predicted;
            total_error_x += x * (y - y_predicted);
        }
        int da = (-2 * total_error)/int(n);
        int db = (-2 * total_error_x)/int(n);

        return (total_error, da, db);
    }

    function predict(int x) public view returns (int) {
        return (b*x + a);
    }

    function getParams() public view returns (int, int){
        return (a,b);
    }
}