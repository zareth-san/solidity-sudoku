// We require the Hardhat Runtime Environment explicitly here. This is optional 
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile 
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const SudokuChallenge = await hre.ethers.getContractFactory("SudokuChallenge");
  const challenge = await SudokuChallenge.deploy(
    [
      3, 0, 6, 5, 0, 8, 4, 0, 0,
      5, 2, 0, 0, 0, 0, 0, 0, 0,
      0, 8, 7, 0, 0, 0, 0, 3, 1,
      0, 0, 3, 0, 1, 0, 0, 8, 0,
      9, 0, 0, 8, 6, 3, 0, 0, 5,
      0, 5, 0, 0, 9, 0, 6, 0, 0,
      1, 3, 0, 0, 0, 0, 2, 5, 0,
      0, 0, 0, 0, 0, 0, 0, 7, 4,
      0, 0, 5, 2, 0, 6, 3, 0, 0
    ]    
  );

  await challenge.deployed();

  console.log("SudokuChallenge deployed to:", challenge.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
