// pragma solidity 0.8.7;

// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "./Libraries/SafeMath.sol";
// //import "./Libraries/FullMath.sol";
// import "./PriceAggregator.sol";
// import "./Positions.sol";
// import "./NFTManager.sol";
// import "./sol6.sol";

// contract AuctioPool {
//     SOL5 private solAdd;
//     NFTManager immutable NFT;
//     IERC20 immutable USDC;
//     PriceAggregator immutable priceB;

//     constructor(
//         address _nft,
//         address _usdc,
//         address _price
//     ) {
//         NFT = NFTManager(_nft);
//         USDC = IERC20(_usdc);
//         priceB = PriceAggregator(_price);
//     }

//     uint256 public discount = 8;
//     uint256 public fee = 3;

//     function auction(uint256 _amount) external {
//         uint256 ethAmount = priceB.inverseConversionEth(_amount);
//         ethAmount = FullMath.mulDivRoundingUp(ethAmount, 98, 100);
//         //USDC.approve(address(solAdd), ethAmount);
//         USDC.transferFrom(msg.sender, address(solAdd), ethAmount);
//         (bool sent, ) = payable(msg.sender).call{value: _amount}("");
//         require(sent, "Failed to send Ether");
//     }

//     function setAdd(address sol) external {
//         solAdd = SOL5(payable(sol));
//     }

//     function auctionWithNft(
//         uint256 _id,
//         uint256 _amount,
//         uint256 _colFactor,
//         uint256 _interestRate
//     ) external {
//         uint256 _Kdata = solAdd.accuredK(_colFactor, _interestRate);
//         (uint256 IdAmount, , , , , , , , ) = NFT.tokenData(_id);

//         uint256 ethAmountbuy = priceB.inverseConversionEth(_amount);
//         uint256 newAmount = FullMath.mulDivRoundingUp(_Kdata, IdAmount, 1e10);
//         ethAmountbuy = FullMath.mulDivRoundingUp(ethAmountbuy, 95, 100);
//         require(ethAmountbuy <= newAmount, "INSUFFIENT LIQUIDITY");
//         if (ethAmountbuy < newAmount) {
//             newAmount -= ethAmountbuy;
//             uint256 remainingAmount = SafeMath.div(newAmount * 1e10, _Kdata);
//             solAdd.updatePosition(
//                 _id,
//                 remainingAmount,
//                 _colFactor,
//                 _interestRate,
//                 0
//             );
//             (bool sent, ) = payable(msg.sender).call{value: _amount}("");
//             require(sent, "Failed to send Ether");
//         } else {
//             NFT.transferFrom(msg.sender, address(this), _id);
//             NFT.burn(_id);
//             (bool sent, ) = payable(msg.sender).call{value: _amount}("");
//             require(sent, "Failed to send Ether");
//         }
//     }

//     receive() external payable {}

//     fallback() external payable {}
// }
