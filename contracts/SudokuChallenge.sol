//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;


//import "hardhat/console.sol";
import "./SafeMath.sol";

contract SudokuChallenge {
    uint8[9][9] public challenge;

   

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
    constructor(uint8[9][9] memory _challenge) public {
        challenge = _challenge;
    }

    function validate(bytes calldata data)
        public
        view
        returns (bool)
    {
        // TODO implement me!


        (uint8[][] memory solution) = abi.decode(data, (uint8[][]));
       
        uint8 _rowSum;
        uint8 _colombSum;
       // uint8 _gridSum;
        for (uint i; i < 9; i++){

            // check row validity
            for (uint v; v < 9; v++){
              _rowSum += solution[i][v];
            }
            require (_rowSum == 45, "Invalid Row Solution");

            // check column sum
            for (uint v; v < 9; v++){
              _colombSum += solution[v][i];
            }
            require (_rowSum == 45, "Invalid Colomn Solution");

        }
        // _checkGrid
        return true;

    }

    function _checkGrid() internal returns (bool){
      return true;
    }
}
