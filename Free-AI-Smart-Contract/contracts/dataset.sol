// SPDX-License-Identifier: UNKNOWN 
pragma solidity ^0.8.0;

contract Dataset{

    //variables
    int[] x;
    int[] y;
    uint256 size;

    //constructor
    constructor(){
        size = 0;
    }

    //functions
    function addData (int _x, int _y) public {
        x.push(_x);
        y.push(_y);
        size++;
    }

    function getData (uint256 i) external view returns(int, int){
        require(i<size);
        return (x[i], y[i]);
    }

    function getSize () external view returns(uint256){
        return(size);
    }
}