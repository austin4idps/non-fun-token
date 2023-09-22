const hre = require("hardhat");

async function main() {
  const factory = await hre.ethers.getContractFactory("Sphere");
  const contract = await factory.deploy();
  await contract.deployed();
  // console.log(contract);
  console.log("NFT deployed to:", contract.address);

  //wait for 5 block transactions to ensure deployment before verifying

  await contract.deployTransaction.wait(5);

  //verify

  await hre.run("verify:verify", {
    address: contract.address,
    contract: "contracts/sphere_nft.sol:Sphere", //Filename.sol:ClassName
  });
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
