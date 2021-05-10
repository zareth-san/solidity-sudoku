//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "hardhat/console.sol";
import "./SudokuChallenge.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/** Rewards users for solving Sudoku challenges
 *
 * SudokuExchange provides a decentralized exchange connecting amateur Sudoku enthusiasts
 * with experienced Sudoku solvers. Those looking for solutions to their Sudoku challenges
 * call SudokuExchange.createReward, specifying the particular challenge they want solved
 * and the ERC20 reward token and amount the first solver will receive upon successfully
 * solving the challenge
*/
contract SudokuExchange {

    /** All the data necessary for solving a Sudoku challenge and claiming the reward */
    struct ChallengeReward {
        SudokuChallenge challenge;
        uint256 reward;
        ERC20 token;
        bool solved;
    }

    // stores the Sudoku challenges and the data necessary to claim the reward
    // for a successful solution
    // key: SudokuChallenge
    // value: ChallengeReward
    mapping(address => ChallengeReward) rewardChallenges;

    constructor() public {
    }

    //
    function createReward(ChallengeReward memory challengeReward) public {
        // first transfer in the user's token approved in a previous transaction
        challengeReward.token.transferFrom(msg.sender, address(this), challengeReward.reward);

        // now store the reward so future callers of SudokuExchange.claimReward can solve the challenge
        // and claim the reward
        rewardChallenges[address(challengeReward.challenge)] = challengeReward;

    }

    // claim a previously created reward by solving the Sudoku challenge
    function claimReward(SudokuChallenge challenge, uint8[81] calldata solution) public {
        // does this challenge even have a reward for it?
        require(address(rewardChallenges[address(challenge)].token) != address(0x0), "Sudoku challenge does not exist at this address");

        // now try to solve it
        bool isCorrect = challenge.validate(solution);

        require(isCorrect, "the solution is not correct");

        // they solved the Sudoku challenge! pay them and then mark the challenge as solved
        ChallengeReward memory challengeReward = rewardChallenges[address(challenge)];
        challengeReward.token.transfer(address(this), challengeReward.reward);
        challengeReward.solved = true;
    }
}
