// SPDX-License-Identifier: MIT 
// CODE FROM: Github kidwai/LinearModel.sol
pragma solidity ^0.8.0;

contract LinearModel {
    
    int[] public x;
    int[] public y;
    int public w0;
    int public w1;
    int public decimals;
    int public alpha;

    constructor(
        int _decimals,
        int _alpha // this alpha should be an integer already scaled with the decimals
        ) 
    {
        decimals = _decimals;
        alpha = _alpha;
    }

    function initParams(int _w0, int _w1) public {
        w0 = _w0*decimals;
        w1 = _w1*decimals;
    }
    
    function step () public view returns (int, int){
        return(alpha, (-2*(y[0]-full_predict(x[0], w0, w1))));
    }

    function train () public {
        int new_w0 = 0;
        int new_w1 = 0;
        int local_w0 = w0;
        int local_w1 = w1;
        for (uint256 i = 0 ; i < x.length; i++) {
            int y_pred = full_predict(x[i], local_w0, local_w1);
            //new_a_int = a_int - int(alpha_int * int(-2 * int(y[i] - int(predict(x[i], a_int, b_int)))))
            new_w0 = local_w0 - (alpha * (-2*(y[i]-y_pred)));

            //new_b_int = b_int - int(alpha_int * int(-2 * int(x[i] * int(y[i] - int(predict(x[i], a_int, b_int))))))
            new_w1 = local_w1 - (alpha * (-2*(x[i]*(y[i]-y_pred))));

            //a_int = new_a_int
            local_w0 = new_w0;
            //b_int = new_b_int
            local_w1 = new_w1;
        }
        w0 = local_w0;
        w1 = local_w1;
    }

    function predict(int _x) public view returns(int) {
        return int(int(w0 + int(w1*_x))/decimals);
    }

    function full_predict(int _x, int _w0, int _w1) private view returns(int) {
        return int(int(_w0 + int(_w1*_x))/decimals);
    }
    
    function push(int _x, int _y) public {
        x.push(_x);
        y.push(_y);
    }

    function getData (uint256 i) external view returns(int, int){
        require(i<x.length);
        return (x[i], y[i]);
    }

    function getParams() view public returns(int, int){
        return(w0, w1);
    }
}