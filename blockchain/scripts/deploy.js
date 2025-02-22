async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Deploy BlockMaster first (if Auction.sol relies on it)
    const BlockMaster = await ethers.getContractFactory("BlockMaster");
    const blockMaster = await BlockMaster.deploy();
    await blockMaster.deployed();
    console.log("BlockMaster deployed to:", blockMaster.address);

    // Deploy Auction contract, passing BlockMaster address if needed
    const Auction = await ethers.getContractFactory("Auction");
    const auction = await Auction.deploy(blockMaster.address);
    await auction.deployed();
    console.log("Auction deployed to:", auction.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
