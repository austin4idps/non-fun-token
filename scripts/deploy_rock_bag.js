const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const factory = await hre.ethers.getContractFactory("TimberlandRockBag");

  const supply = 102;
  const totalPrice = 79 + 20;
  const tokenURI = process.env.TOKEN_URI;

  console.log(supply);
  console.log(totalPrice);
  console.log(tokenURI);

  const contract = await factory.deploy(supply, totalPrice, tokenURI);

  // console.log(contract);
  console.log("NFT deployed to:", contract.address);

  //wait for 5 block transactions to ensure deployment before verifying

  await contract.deployTransaction.wait(5);

  //verify

  await hre.run("verify:verify", {
    address: contract.address,
    contract: "contracts/timeberland-rock-bag.sol:TimberlandRockBag", //Filename.sol:ClassName
    constructorArguments: [supply, totalPrice, tokenURI],
  });
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
