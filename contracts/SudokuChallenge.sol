//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.12;

import "hardhat/console.sol";

contract SudokuChallenge {
    uint8[81] public challenge;

    // create a contract with an initial Sudoku challenge. Recall that Sudoku
    // is a boardgame with a square board made of 9 3x3 square subgrids. See
    // the following URL for an introduction to Sudoku:
    //
    // https://sudoku.com/how-to-play/sudoku-rules-for-complete-beginners/
    //
    // Each element of the array represents the possible cell values
    // 1 - 9. A cell value of 0 is used to represent a cell which does not have
    // an assigned value yet.
    //
    // Example for a challenge:
    //
    // [
    //    3, 0, 6, 5, 0, 8, 4, 0, 0,
    //    5, 2, 0, 0, 0, 0, 0, 0, 0,
    //    0, 8, 7, 0, 0, 0, 0, 3, 1,
    //    0, 0, 3, 0, 1, 0, 0, 8, 0,
    //    9, 0, 0, 8, 6, 3, 0, 0, 5,
    //    0, 5, 0, 0, 9, 0, 6, 0, 0,
    //    1, 3, 0, 0, 0, 0, 2, 5, 0,
    //    0, 0, 0, 0, 0, 0, 0, 7, 4,
    //    0, 0, 5, 2, 0, 6, 3, 0, 0
    // ]
    //
    // Example correct input to the `SudokuChallenge.validate` call
    // 
    //  [
    //    3, 1, 6, 5, 7, 8, 4, 9, 2,
    //    5, 2, 9, 1, 3, 4, 7, 6, 8,
    //    4, 8, 7, 6, 2, 9, 5, 3, 1,
    //    2, 6, 3, 4, 1, 5, 9, 8, 7,
    //    9, 7, 4, 8, 6, 3, 1, 2, 5,
    //    8, 5, 1, 7, 9, 2, 6, 4, 3,
    //    1, 3, 8, 9, 4, 7, 2, 5, 6,
    //    6, 9, 2, 3, 5, 1, 8, 7, 4,
    //    7, 4, 5, 2, 8, 6, 3, 1, 9
    //  ]
    constructor(uint8[81] memory _challenge) public {
      challenge = _challenge;
    }


    function validate(uint8[81] calldata potentialSolution ) public view returns (bool isCorrect) {
      isCorrect = false;
      uint16[] memory rows = new uint16[](9);
      uint16[] memory cols = new uint16[](9);
      uint8[][] memory boxes = new uint8[][](9);

      for (uint i = 0; i < 81; i ++) {
        uint r = i / 9;
        uint c = i % 9;

        uint8 x = challenge[i]; // takes 3 slots, and cheaper than dumping on memory
        uint8 y = potentialSolution[i]; // read-only

        if (x > 0) {
          // should not modify non-zero cell
          if (y != x) return isCorrect;
        }

        // validate a cell
        if (y < 1 || y > 9) return isCorrect;

        y -= 1; // adjust for array indexing
        
        // should be unique in the row
        if (rows[y] & (1 << r) > 0) return isCorrect;
        rows[y] = uint16(rows[y] | (1 << r));

        // should be unique in the column
        if (cols[y] & (1 << c) > 0) return isCorrect;
        cols[y] = uint16(cols[y] | (1 << c));

        // should be unique in the box
        r /= 3; // matrix scale
        c /= 3; // matrix scale
        if (boxes[y].length == 0) {
          // initialize the array if it's first time to access
          boxes[y] = new uint8[](3);
        }
        if (boxes[y][r] & (1 << c) > 0) return isCorrect;
        boxes[y][r] = uint8(boxes[y][r] | (1 << c));
      }
      isCorrect = true;
    }
}
