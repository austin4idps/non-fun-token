const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const factory = await hre.ethers.getContractFactory("TimberlandJacket");

  const supply = 62;
  const totalPrice = 369 + 20;
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
    contract: "contracts/timberland-jacket.sol:TimberlandJacket", //Filename.sol:ClassName
    constructorArguments: [supply, totalPrice, tokenURI],
  });
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
