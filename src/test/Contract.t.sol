// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.6.0 <0.8.0;
//pragma experimental ABIEncoderV2;

import "lib/ds-test/src/test.sol";
import "contracts/SudokuChallenge.sol";
import "contracts/SudokuExchange.sol";

contract ContractTest is DSTest {
    SudokuExchange sudokuExchange;

    uint8[9][9] public challenge;

    function setUp() public {
        sudokuExchange = new SudokuExchange();
    }

    function testCorrectInput() public returns (uint8[9][9] memory) {
        uint8[9][9] memory challenge = [
            [3, 1, 6, 5, 7, 8, 4, 9, 2],
            [5, 2, 9, 1, 3, 4, 7, 6, 8],
            [4, 8, 7, 6, 2, 9, 5, 3, 1],
            [2, 6, 3, 4, 1, 5, 9, 8, 7],
            [9, 7, 4, 8, 6, 3, 1, 2, 5],
            [8, 5, 1, 7, 9, 2, 6, 4, 3],
            [1, 3, 8, 9, 4, 7, 2, 5, 6],
            [6, 9, 2, 3, 5, 1, 8, 7, 4],
            [7, 4, 5, 2, 8, 6, 3, 1, 9]
        ];
    }

    function testNotCorrectInput() public returns (uint8[9][9] memory) {
        uint8[9][9] memory challenge = [
            [3, 1, 8, 9, 7, 8, 4, 9, 2],
            [5, 2, 9, 1, 3, 4, 7, 6, 8],
            [4, 8, 7, 6, 2, 9, 5, 3, 1],
            [2, 6, 3, 4, 1, 5, 9, 8, 7],
            [9, 7, 4, 8, 6, 3, 1, 2, 5],
            [8, 5, 1, 7, 9, 2, 6, 4, 3],
            [1, 3, 8, 9, 4, 7, 2, 5, 6],
            [6, 9, 2, 3, 5, 1, 8, 7, 4],
            [7, 4, 5, 2, 8, 6, 3, 1, 9]
        ];
    }

    function testChallenge() public returns (uint8[9][9] memory) {
        uint8[9][9] memory challenge = [
            [3, 0, 6, 5, 0, 8, 4, 0, 0],
            [5, 2, 0, 0, 0, 0, 0, 0, 0],
            [0, 8, 7, 0, 0, 0, 0, 3, 1],
            [0, 0, 3, 0, 1, 0, 0, 8, 0],
            [9, 0, 0, 8, 6, 3, 0, 0, 5],
            [0, 5, 0, 0, 9, 0, 6, 0, 0],
            [1, 3, 0, 0, 0, 0, 2, 5, 0],
            [0, 0, 0, 0, 0, 0, 0, 7, 4],
            [0, 0, 5, 2, 0, 6, 3, 0, 0]
        ];
    }

    function testRewardCreation() public {
        sudokuExchange.createReward(
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            testChallenge(),
            100
        );
    }

    function testCorrectAnswer() public {
        sudokuExchange.claimReward(0, testCorrectInput());
    }

    // function testNotCorrectAnswer() public {
    //     sudokuExchange.claimReward(0, testNotCorrectInput());
    // }

    function testExample() public {
        assertTrue(true);
    }
}
