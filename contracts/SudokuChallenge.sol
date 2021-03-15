//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.12;

import "hardhat/console.sol";

contract SudokuChallenge {
    uint256[] public challenge;
    uint8 public size;

    // create a contract with an initial Sudoku challenge, We represent a
    // challenge as an array of uint8's where each row of the challenge is of
    // length size. Each element of the array represents the possible cell values
    // 1 - 9. A cell value of 0 is used to represent a cell which does not have
    // an assigned value yet. Note, we make no restrictions on the dimensions of
    // the challenge.
    //
    // Example for a 3x3 challenge:
    //
    // ------------
    // | 0  1  0  |
    // | 3  0  4  |
    // | 0  0  6  |
    // ------------
    //
    // challenge = [0, 1, 0, 3, 0, 4, 0, 0, 6]
    constructor(uint8[] memory _challenge, uint8 _size) public {
      challenge = _challenge;
      size = _size;
    }


    function solve( uint8[] calldata potentialSolution ) public pure returns (bool isCorrect) {
      // TODO implement me!
    }
}
