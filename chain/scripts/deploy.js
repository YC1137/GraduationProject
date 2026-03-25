async function main() {
  const Factory = await ethers.getContractFactory("HeritageNFT");
  const contract = await Factory.deploy();
  await contract.waitForDeployment();

  const address = await contract.getAddress();
  console.log("HeritageNFT deployed to:", address);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
