const { utils } = require("ethers");
const { ethers, getNamedAccounts } = require("hardhat");
const hre = require("hardhat");
const { verify } = require("../verify");

async function main() {
  const amount = hre.ethers.utils.parseEther("1");
  const { deployer } = await getNamedAccounts();
  // const UniswapV3Twap = await hre.ethers.getContractFactory("UniswapV3Twap");
  // const uniswapV3Twap = await UniswapV3Twap.deploy(
  //   "0x1f98431c8ad98523631ae4a59f267346ea31f984",
  //   "0x514910771AF9Ca656af840dff83E8264EcF986CA",
  //   "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
  //   3000
  // );
  // await uniswapV3Twap.deployed();

  // console.log(
  //   "This is the address of uniswpa price Oracle",
  //   uniswapV3Twap.address
  // );
  console.log("        ");

  // const NFTbuilder = await hre.ethers.getContractFactory("NFTbuilder");
  // const nftBuilder = await NFTbuilder.deploy();
  // await nftBuilder.deployed();
  // console.log(
  //   "This is the address  of the library contract",
  //   nftBuilder.address
  // );
  // console.log("        ");

  // const NFTManager = await hre.ethers.getContractFactory("NFTManager", {
  //   libraries: {
  //     NFTbuilder: "0x4466122d2f618a2f80e160c52f15860b652f8cec",
  //   },
  // });
  // const nftmanager = await NFTManager.deploy();
  // await nftmanager.deployed();
  // console.log("This is the address of the NFTManager", nftmanager.address);

  // const Pool = await hre.ethers.getContractFactory("Factory");
  // const pool = await Pool.deploy(
  //   deployer,
  //   "0x2C17DbcEbbBa4Df058684CE8586D330dc60A6C6F"
  // );
  // await pool.deployed();

  // console.log("This is the Factory Address", pool.address);

  // const pool_address = await pool.deploy(
  //   "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6",
  //   "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
  //   3000
  // );
  // const PoolAdd = await pool_address.wait(1);
  //console.log("💪💪 You created a pool", PoolAdd);
  await verify("0x0f861AEcD99b6e6Fc429FE2c3fac5b65D98a3266", [
    "0x3e6ce5458b8928cc2e20a74f86d74735897a9934",
    "0x2C17DbcEbbBa4Df058684CE8586D330dc60A6C6F",
    "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6",
    "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
    3000,
  ]);
  console.log("        ");

  //"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",

  // const ethprice = await uniswapV3Twap.estimateAmountOut(
  //   "0x514910771AF9Ca656af840dff83E8264EcF986CA",
  //   amount,
  //   10
  // );

  // const price = await uniswapV3Twap.getInverseConvertion(
  //   "0x514910771AF9Ca656af840dff83E8264EcF986CA",
  //   amount,
  //   10
  // );

  // // const image = await nftBuilder.generateSVG(
  // //   "1",
  // //   "1030",
  // //   "85",
  // //   "3",
  // //   "201",
  // //   "30"
  // // );
  // //200323790041029514164;
  // console.log("The price of LINK in USDC is ", ethprice, "LINK");
  // console.log("The price of LINK in USDC is ", price, "LINK");
  // console.log(image);

  // console.log(image);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
