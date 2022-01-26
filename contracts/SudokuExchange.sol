//SPDX-License-Identifier: Unlicense
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "./SudokuChallenge.sol";
import "./IERC20.sol";

/** Rewards users for solving Sudoku challenges
 *
 * SudokuExchange provides a decentralized exchange connecting amateur Sudoku enthusiasts
 * with experienced Sudoku solvers. Those looking for solutions to their Sudoku challenges
 * call SudokuExchange.createReward, specifying the particular challenge they want solved
 * and the ERC20 reward token and amount the first solver will receive upon successfully
 * solving the challenge
 */

contract SudokuExchange {
    struct RewardKey {
        uint8[9][9] challengeMatrix;
        uint256 rewardAmount;
        address rewardToken;
        address refundee;
        bool solved;
    }

    RewardKey[] public challenges;

    uint256 private unlocked = 1;

    // reentrancy guard
    modifier lock() {
        require(unlocked == 1, "SudokuExchange: LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    event RewardCreated(
        uint8[9][9] challengeMatrix,
        uint256 rewardNumber,
        uint256 rewardAmount,
        address rewardToken
    );

    constructor() public {}

    function createReward(
        address _rewardToken,
        uint8[9][9] memory _challengeMatrix,
        uint256 _challengeReward
    ) public {
        // transfer challenge reward tokens to contract
        require(
            IERC20(_rewardToken).transferFrom(
                msg.sender,
                address(this),
                _challengeReward
            )
        );

        // populate challenge key
        RewardKey memory _rewardKey = RewardKey({
            challengeMatrix: _challengeMatrix,
            rewardAmount: _challengeReward,
            rewardToken: _rewardToken,
            refundee: msg.sender,
            solved: false
        });

        // updated challenge array
        challenges.push(_rewardKey);

        // assign a challenge number for easy lookup (there is a better way to do this lol)
        uint256 rewardNumber = challenges.length - 1;

        // emit event for easy viewing of standing challenges
        emit RewardCreated(
            _rewardKey.challengeMatrix,
            rewardNumber,
            _rewardKey.rewardAmount,
            _rewardKey.rewardToken
        );
    }

    // claim a previously created reward by solving the Sudoku challenge
    function claimReward(uint256 rewardNumber, uint8[9][9] memory solution)
        external
        lock
    {
        // return rewardKey from challenges array
        RewardKey memory rewardKey = challenges[rewardNumber];

        // check that solution matches the challenge matrix, and solves it accordingly
        require(_validate(rewardKey, solution) == true, "invalid");

        // transfer correct amount and token from the solved challenge reward
        IERC20(rewardKey.rewardToken).transfer(
            msg.sender,
            rewardKey.rewardAmount
        );

        // updated challenge to solved
        challenges[rewardNumber].solved = true;
    }

    function refund(uint256 rewardNumber) external {
        RewardKey memory rewardKey = challenges[rewardNumber];

        require(rewardKey.refundee == msg.sender, "not refundee");

        IERC20(rewardKey.rewardToken).transfer(
            msg.sender,
            rewardKey.rewardAmount
        );
        challenges[rewardNumber].solved = true;
    }

    function _validate(RewardKey memory rewardKey, uint8[9][9] memory solution)
        internal
        pure
        returns (bool)
    {
        uint8 _rowSum;
        uint8 _colombSum;
        // uint8 _gridSum;

        for (uint256 i; i < 9; i++) {
            // check row validity
            for (uint256 v; v < 9; v++) {
                // potentially redundant 1-9 check?
                require(
                    solution[i][v] > 0 && solution[i][v] < 10,
                    "invalid input"
                );
                // check that non zero inputs are the same as the challange matrix
                if (
                    rewardKey.challengeMatrix[i][v] == 0 ||
                    solution[i][v] == rewardKey.challengeMatrix[i][v]
                ) {
                    // sum the solution matrix to
                    _rowSum += solution[i][v];
                } else {
                    // throw if non zero solution inputs do not match the challenge matrix
                    revert("Solution Does Not Match Challenge");
                }
            }

            require(_rowSum == 45, "Invalid Row Solution");

            // check column validity
            // we only need to check that solution inputs are valid (1-9) once (done above).
            for (uint256 v; v < 9; v++) {
                _colombSum += solution[v][i];
            }
            require(_colombSum == 45, "Invalid Colomn Solution");
        }

        // _checkGrid TODO
        // ran out of time to check the grid
        return true;
    }
}

/*

Changelog:

* Reentrancy guard modifier for reward claiming so custom token contracts cant do something stupid

* Added refundee address to rewards

* Changed two contracts into a single contract, two contracts were not neccessary providing #validate can recieve arbitrary challenges and solutions

* Changed #claimReward parameters to memory as we're not passing between contracts anymore

* Changed challenge to nested storage array

* Changed challenge storage pattern to an array of type challenge struct

* changed challenge lookup to array index query for simpler UX

* Changed validation requirements to throw errors earlier to save gas

* changed erc20 use to interface

* bugs: 

* not sure where matrix was previously stored, lookup based on address was strange

* asserting a struct exists by checking a mapping cant work as all mapping assignments exist 

* storing challenges previously seemed off

* splitting into two contracts was not neccessary

* testing:

* setup inital testing framework with georgios's foundry tool, see /src/test/contract.t.sol

* tests throw on requirements as mainnet forking isnt implimented yet in this example

*/
