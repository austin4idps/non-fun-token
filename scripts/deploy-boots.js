const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const factory = await hre.ethers.getContractFactory("TimberlandClassicBoots");

  const supply = 157;
  const totalPrice = 389;
  const tokenURI = "ipfs://QmPfwkVgsva3JurS2vt233WLKPqBRutiM1LrXTPeW28yV3/"; // original pic

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
    contract: "contracts/timberland-classic-boots.sol:TimberlandClassicBoots", //Filename.sol:ClassName
    constructorArguments: [supply, totalPrice, tokenURI],
  });
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
