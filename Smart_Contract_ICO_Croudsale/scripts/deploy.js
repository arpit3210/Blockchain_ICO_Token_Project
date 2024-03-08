const hre  = require("hardhat");
// const { ethers } = require("hardhat");

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const startTime = currentTimestampInSeconds;
  const endTime = startTime + 86400; // Sale duration: 1 day
  const tokenPrice = hre.ethers.parseEther("0.001"); // Price of each token
  const fundingGoal = hre.ethers.parseEther("10"); // Funding goal: 10 ETH

  // Deploy MyToken contract
  const MyToken = await hre.ethers.deployContract("MyToken", [1000000]);
  await MyToken.waitForDeployment();
  console.log("MyToken deployed to:", MyToken.target);

  // Deploy ICOSale contract
  const ICOSale = await hre.ethers.deployContract("ICOSale", [MyToken.target,   tokenPrice, fundingGoal,  startTime, endTime  ],
   );

   await ICOSale.waitForDeployment();

  console.log("ICOSale deployed to:", ICOSale.target);

  // Transfer tokens to ICOSale contract

  // const TotalSupplyOfToken = await MyToken.totalSupply();
  // const TotalSupplyInString =await TotalSupplyOfToken.toString();
  // console.log(TotalSupplyOfToken.toString());
  // const initialSupply = await hre.ethers.utils.parseUnits( TotalSupplyInString , 18); // Parse total supply assuming 18 decimals
  // const tokensToTransfer = initialSupply.mul(10).div(100); // Now you can use mul and div
  // await MyToken.transfer(ICOSale.target, tokensToTransfer);
  
  const TotalSupplyOfToken = await MyToken.totalSupply();
if (TotalSupplyOfToken) {
  const TotalSupplyInString = TotalSupplyOfToken.toString();
  console.log(TotalSupplyOfToken.toString());
  const initialSupply = await hre.ethers.utils.parseUnits(  await TotalSupplyInString, 18);
  const tokensToTransfer = initialSupply.mul(10).div(100);
  await MyToken.transfer(ICOSale.target, tokensToTransfer);
  console.log("Tokens transferred to ICOSale contract");
} else {
  console.error("Failed to get total supply");
}


  // await MyToken.transfer( ICOSale.target, hre.ethers.parseUnits("100000", 18));  // Transfer 100,000 tokens to sale contract with 6 decimals
  console.log("Tokens transferred to ICOSale contract", tokensToTransfer );

  console.log("Deployment completed successfully!");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
