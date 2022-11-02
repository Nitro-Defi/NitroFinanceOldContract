// //SPDX-License-Identifier: MIT
// pragma solidity 0.8.7;
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "./Positions.sol";
// import "./NFTManager.sol";
// import "./Libraries/errors.sol";
// import "./Libraries/SafeMath.sol";
// import "./Libraries/FullMath.sol";
// import "./PriceAggregator.sol";
// import "./BorrowLogic.sol";
// import "./AuctionPool.sol";

// contract SOL7 is Position, errors, PriceAggregator, BorrowLogic {
//     using SafeMath for uint256;
//     using FullMath for uint256;
//     NFTManager immutable NFT;
//     IERC20 immutable USDC;
//     PriceAggregator immutable priceB;
//     //BorrowLogic immutable logic;
//     AuctioPool immutable auctionPool;

//     uint256 public nextId = 1;
//     uint public locusTracker = 1;
//     uint64 LasttimeStamp;
//     uint256 liquidationThreshold;
//     uint256 LiquidationFee;
//     uint totalBorrow;

//     uint256 private constant DELTA_K_PRECISION = 1e10;
//     uint256 private constant K_MANTISSA = 1e6;
//     uint256 private constant SECONDS_PER_YEAR = 31536000;

//     struct TOKENID {
//         uint _tokenId;
//     }

//     mapping(address => uint) public collateralAmount;
//     mapping(address => uint) public collateralValue;
//     mapping(address => uint) public borrowedValue;
//     mapping(address => uint) public tmcr;
//     mapping(address => uint) public air;
//     //mapping(address => uint) public TIR;
//     mapping(uint256 => uint64) public differenceInTime_K;
//     mapping(uint256 => uint64) public LasttimeStamp_k;
//     mapping(address => uint64) public borrowerTimer;
//     mapping(uint => uint) public NFTidToAmount;
//     mapping(uint => TOKENID[]) public locusToNftId;
//     mapping(uint256 => mapping(uint256 => uint64))
//         public LastDebtAccuredTimeLocus;
//     mapping(address => mapping(uint => mapping(uint => uint)))
//         public userNftPerLocus;

//     mapping(uint256 => mapping(uint256 => BORROWTRANSACTIONS[]))
//         public LocusBorrowData;
//     mapping(uint256 => mapping(uint256 => uint256)) public TotalPositionSize;
//     mapping(uint256 => mapping(uint256 => uint256))
//         public AmountBorrowedFromLocus;
//     mapping(uint256 => mapping(uint256 => uint256))
//         public AmountBorrowedFromLocuswithInterest;
//     mapping(uint256 => mapping(uint256 => uint64)) public LastKtimeStamp;

//     constructor(
//         address _nft,
//         address _usdc,
//         address _price,
//         address _auctionPool
//     ) {
//         NFT = NFTManager(_nft);
//         USDC = IERC20(_usdc);
//         priceB = PriceAggregator(_price);
//         auctionPool = AuctioPool(payable(_auctionPool));
//     }

//     function addLiquidity(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) external {
//         LOCUS memory data = getLocus[_collateralFactor][_interestRate];
//         if (
//             data.collateralFactor != _collateralFactor &&
//             data.interestRate != _interestRate
//         ) {
//             _create(_collateralFactor, _interestRate, _value);
//         } else {
//             _update(_collateralFactor, _interestRate, _value);
//         }
//     }

//     function _create(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) internal {
//         if (_collateralFactor > 0 && _interestRate > 0 && _value > 0) {
//             uint kInitialValue = DELTA_K_PRECISION;
//             put(_collateralFactor, _interestRate, locusTracker, _value);

//             USDC.transferFrom(msg.sender, address(this), _value);
//             NFT.createPosition(
//                 msg.sender,
//                 nextId,
//                 _collateralFactor,
//                 _interestRate,
//                 _value,
//                 kInitialValue,
//                 locusTracker
//             );
//             NFTidToAmount[nextId] = _value;
//             TOKENID[] storage data = locusToNftId[locusTracker];
//             data.push(TOKENID({_tokenId: nextId}));
//             userNftPerLocus[msg.sender][_collateralFactor][
//                 _interestRate
//             ] = nextId;
//             TotalPositionSize[_collateralFactor][_interestRate] += _value;
//             locusTracker++;
//             nextId++;
//         } else {
//             revert INPUT_DATA_SHOULD_BE_GREATER_THAN_ZERO();
//         }
//     }

//     function _update(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) public {
//         if (_collateralFactor > 0 && _interestRate > 0 && _value > 0) {
//             LOCUS storage data = getLocus[_collateralFactor][_interestRate];
//             USDC.transferFrom(msg.sender, address(this), _value);
//             //update(data.locusId, 0, _value);

//             if (
//                 AmountBorrowedFromLocus[_collateralFactor][_interestRate] == 0
//             ) {
//                 NFT.createPosition(
//                     msg.sender,
//                     nextId,
//                     _collateralFactor,
//                     _interestRate,
//                     _value,
//                     1 * DELTA_K_PRECISION,
//                     data.locusId
//                 );
//                 NFTidToAmount[nextId] = _value;
//                 TOKENID[] storage tokenId = locusToNftId[locusTracker];
//                 tokenId.push(TOKENID({_tokenId: nextId}));
//                 userNftPerLocus[msg.sender][_collateralFactor][
//                     _interestRate
//                 ] = nextId;
//                 data.liquidity += _value;
//                 nextId++;
//                 TotalPositionSize[_collateralFactor][_interestRate] += _value;
//             } else {
//                 accuredK(_collateralFactor, _interestRate);
//                 uint amount = SafeMath.div(_value * 1e10, data.k);
//                 NFT.createPosition(
//                     msg.sender,
//                     nextId,
//                     _collateralFactor,
//                     _interestRate,
//                     amount,
//                     data.k,
//                     data.locusId
//                 );
//                 NFTidToAmount[nextId] += amount;
//                 data.liquidity += _value;
//                 TOKENID[] storage tokenId = locusToNftId[locusTracker];
//                 TotalPositionSize[_collateralFactor][_interestRate] += amount;
//                 tokenId.push(TOKENID({_tokenId: nextId}));
//                 userNftPerLocus[msg.sender][_collateralFactor][
//                     _interestRate
//                 ] = nextId;
//                 nextId++;
//             }
//         } else {
//             revert INPUT_DATA_SHOULD_BE_GREATER_THAN_ZERO();
//         }
//     }

//     function updatePosition(
//         uint _amount,
//         uint _colFactor,
//         uint _interestRate,
//         uint _updateOption
//     ) external {
//         accuredK(_colFactor, _interestRate);
//         LOCUS storage data = getLocus[_colFactor][_interestRate];
//         uint _tokenId = userNftPerLocus[msg.sender][_colFactor][_interestRate];
//         if (data.initialized != true) revert NON_EXITING_POSITION();
//         uint amount = SafeMath.div(_amount * 1e10, data.k);
//         if (_updateOption == 1) {
//             USDC.transferFrom(msg.sender, address(this), _amount);

//             NFT.getPoolandUpdateLiquidity(
//                 _tokenId,
//                 amount,
//                 _colFactor,
//                 _interestRate,
//                 _updateOption
//             );
//             TotalPositionSize[_colFactor][_interestRate] += amount;
//             NFTidToAmount[_tokenId] += _amount;
//             data.liquidity += _amount;
//         } else if (_amount == NFTidToAmount[_tokenId]) {
//             withdrawLiquidity(_tokenId, _colFactor, _interestRate);
//         } else {
//             require(
//                 NFTidToAmount[_tokenId] >= _amount,
//                 "INSUFFICIENT LIQUIDITY"
//             );
//             NFT.getPoolandUpdateLiquidity(
//                 _tokenId,
//                 amount,
//                 _colFactor,
//                 _interestRate,
//                 _updateOption
//             );
//             NFTidToAmount[_tokenId] -= _amount;
//             data.liquidity -= _amount;
//             TotalPositionSize[_colFactor][_interestRate] -= amount;
//             USDC.transfer(msg.sender, _amount);
//         }
//     }

//     //locusid

//     function borrow(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) external {
//         if (borrowedValue[msg.sender] == 0) {
//             _initBorrow(_collateralFactor, _interestRate, _value);
//         } else {
//             _subBorrows(_collateralFactor, _interestRate, _value);
//         }
//     }

//     function _initBorrow(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) internal {
//         cook();
//         accureInterestRate(_interestRate);
//         LOCUS storage data = getLocus[_collateralFactor][_interestRate];
//         if (data.initialized != true) revert NON_EXITING_POSITION();
//         if (
//             data.collateralFactor != _collateralFactor &&
//             data.interestRate != _interestRate
//         ) {
//             revert LOCUS_NOT_IN_EXISTENCE();
//         } else {
//             require(
//                 collateralValue[msg.sender] > _value,
//                 "not enough collateral"
//             );
//             require(
//                 FullMath.mulDivRoundingUp(
//                     collateralValue[msg.sender],
//                     _collateralFactor,
//                     100
//                 ) > _value,
//                 "more than max borrow"
//             );
//             require(_value <= data.liquidity, "not enough liquidity");
//             borrowedValue[msg.sender] += _value;
//             tmcr[msg.sender] = _collateralFactor;
//             AmountBorrowedFromLocus[_collateralFactor][_interestRate] += _value;
//             AmountBorrowedFromLocuswithInterest[_collateralFactor][
//                 _interestRate
//             ] += _value * 1e27;

//             USDC.transfer(msg.sender, _value);
//             data.liquidity -= _value;
//             air[msg.sender] += _interestRate;
//             BORROWTRANSACTIONS[]
//                 storage borrowData = addressToBorrowTransaction[msg.sender];
//             borrowData.push(
//                 BORROWTRANSACTIONS({
//                     interestRateBorrowedAt: _interestRate,
//                     collateralFactorBorrowedAt: _collateralFactor,
//                     totalBorrowed: _value,
//                     borrower: msg.sender,
//                     locusId: data.locusId,
//                     lastAccuredTimeStamp: uint64(block.timestamp)
//                 })
//             );

//             BORROWTRANSACTIONS[] storage Locusdata = LocusBorrowData[
//                 _collateralFactor
//             ][_interestRate];
//             Locusdata.push(
//                 BORROWTRANSACTIONS({
//                     interestRateBorrowedAt: _interestRate,
//                     collateralFactorBorrowedAt: _collateralFactor,
//                     totalBorrowed: _value,
//                     borrower: msg.sender,
//                     locusId: data.locusId,
//                     lastAccuredTimeStamp: uint64(block.timestamp)
//                 })
//             );
//         }
//     }

//     function _subBorrows(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) internal {
//         cook();
//         accureInterestRate(_interestRate);
//         LOCUS storage data = getLocus[_collateralFactor][_interestRate];
//         if (data.initialized != true) revert NON_EXITING_POSITION();
//         if (
//             data.collateralFactor != _collateralFactor &&
//             data.interestRate != _interestRate
//         ) {
//             revert LOCUS_NOT_IN_EXISTENCE();
//         } else {
//             BORROWTRANSACTIONS[]
//                 storage borrowData = addressToBorrowTransaction[msg.sender];
//             require(
//                 collateralValue[msg.sender] > _value,
//                 "not enough collateral"
//             );
//             require(_value <= data.liquidity, "not enough liquidity");
//             _tmcr(_collateralFactor, _interestRate, _value);
//             uint MaxiBorrow = FullMath.mulDivRoundingUp(
//                 collateralValue[msg.sender],
//                 tmcr[msg.sender],
//                 100
//             );
//             require(
//                 _value <= MaxiBorrow,
//                 "not enough collateral to support more borrow"
//             );
//             require(
//                 _value <=
//                     FullMath.mulDivRoundingUp(
//                         _collateralFactor,
//                         collateralValue[msg.sender],
//                         100
//                     ),
//                 "ppppp"
//             );
//             borrowedValue[msg.sender] += _value;
//             AmountBorrowedFromLocus[_collateralFactor][_interestRate] += _value;
//             AmountBorrowedFromLocuswithInterest[_collateralFactor][
//                 _interestRate
//             ] += _value * 1e27;
//             data.liquidity -= _value;
//             uint newInterestRate;
//             air[msg.sender] += newInterestRate;
//             BORROWTRANSACTIONS[] storage Locusdata = LocusBorrowData[
//                 _collateralFactor
//             ][_interestRate];
//             Locusdata.push(
//                 BORROWTRANSACTIONS({
//                     interestRateBorrowedAt: _interestRate,
//                     collateralFactorBorrowedAt: _collateralFactor,
//                     totalBorrowed: _value,
//                     borrower: msg.sender,
//                     locusId: data.locusId,
//                     lastAccuredTimeStamp: uint64(block.timestamp)
//                 })
//             );
//             for (uint i; i < borrowData.length; i++) {
//                 if (
//                     borrowData[i].collateralFactorBorrowedAt ==
//                     data.collateralFactor &&
//                     borrowData[i].interestRateBorrowedAt == data.interestRate
//                 ) {
//                     borrowData[i].totalBorrowed += _value;
//                     USDC.transfer(msg.sender, _value);
//                 } else {
//                     borrowData.push(
//                         BORROWTRANSACTIONS({
//                             interestRateBorrowedAt: _interestRate,
//                             collateralFactorBorrowedAt: _collateralFactor,
//                             totalBorrowed: _value,
//                             borrower: msg.sender,
//                             locusId: data.locusId,
//                             lastAccuredTimeStamp: uint64(block.timestamp)
//                         })
//                     );
//                     USDC.transfer(msg.sender, _value);
//                 }
//             }
//         }
//     }

//     function _tmcr(
//         uint _collateralFactor,
//         uint _interestRate,
//         uint _value
//     ) internal {
//         BORROWTRANSACTIONS[] storage borrowData = addressToBorrowTransaction[
//             msg.sender
//         ];
//         if (borrowData.length == 0) {
//             tmcr[msg.sender] = 0;
//         } else {
//             uint presumedDebt = borrowedValue[msg.sender] + _value;
//             uint yColFactor = FullMath.mulDivRoundingUp(
//                 _value,
//                 100,
//                 presumedDebt
//             );
//             uint bColFactor = FullMath.mulDivRoundingUp(
//                 yColFactor,
//                 _collateralFactor,
//                 100
//             );
//             uint bInterestRate = FullMath.mulDivRoundingUp(
//                 yColFactor,
//                 _interestRate,
//                 100
//             );

//             tmcr[msg.sender] = 0;
//             air[msg.sender] = 0;
//             for (uint i; i < borrowData.length; i++) {
//                 uint zColFactor = FullMath.mulDivRoundingUp(
//                     borrowData[i].totalBorrowed,
//                     100,
//                     presumedDebt
//                 );
//                 uint aColFactor = FullMath.mulDivRoundingUp(
//                     zColFactor,
//                     borrowData[i].collateralFactorBorrowedAt,
//                     100
//                 );
//                 uint aInterestRate = FullMath.mulDivRoundingUp(
//                     zColFactor,
//                     borrowData[i].interestRateBorrowedAt,
//                     100
//                 );
//                 tmcr[msg.sender] += aColFactor;
//                 air[msg.sender] += aInterestRate;
//             }

//             tmcr[msg.sender] += bColFactor;
//             air[msg.sender] += bInterestRate;
//         }
//     }

//     function addCollateral() external payable {
//         address(this).balance + msg.value;
//         collateralAmount[msg.sender] += msg.value;
//         collateralValue[msg.sender] = priceB.inverseConversionEth(
//             collateralAmount[msg.sender]
//         );
//     }

//     function withdrawLiquidity(
//         uint256 _id,
//         uint _colFactor,
//         uint _interestRate
//     ) internal {
//         cook();
//         accuredK(_colFactor, _interestRate);
//         LOCUS storage data = getLocus[_colFactor][_interestRate];
//         if (data.initialized != true) revert NON_EXITING_POSITION();
//         require(NFT.ownerOf(_id) == msg.sender, "NOT OWNER");
//         //LOCUS storage data = locus[_id];
//         NFT.transferFrom(msg.sender, address(this), _id);
//         NFTidToAmount[_id] = 0;
//         uint value = NFT.withdraw(_id);
//         uint _amount = FullMath.mulDivRoundingUp(value, data.k, 1e10);
//         NFT.burn(_id);
//         userNftPerLocus[msg.sender][_colFactor][_interestRate] = 0;
//         data.liquidity -= _amount;
//         TotalPositionSize[_colFactor][_interestRate] -= _amount;
//         USDC.transfer(msg.sender, _amount);
//     }

//     function withdrawCollateral(uint _amount) external payable {
//         cook();
//         if (_amount <= 0) revert INVALID_AMOUNT();
//         require(
//             _amount <= collateralAmount[msg.sender],
//             "amount greater than available collateral"
//         );
//         if (borrowedValue[msg.sender] == 0) {
//             collateralAmount[msg.sender] -= _amount;
//             (bool sent, ) = payable(msg.sender).call{value: _amount}("");
//             require(sent, "Failed to send Ether");
//         } else {
//             validatWithdraw(msg.sender, _amount);
//         }
//     }

//     function validatWithdraw(address recepient, uint _amount)
//         internal
//         returns (uint pass)
//     {
//         BORROWTRANSACTIONS[] storage data = addressToBorrowTransaction[
//             msg.sender
//         ];

//         for (uint i; i < data.length; i++) {
//             if (data.length == 0) {
//                 revert NOT_OWING();
//             } else {
//                 if (data[i].borrower == recepient) {
//                     if (tmcr[recepient] == data[i].collateralFactorBorrowedAt) {
//                         uint factor = (
//                             ((data[i].collateralFactorBorrowedAt *
//                                 collateralValue[recepient]) / 100)
//                         ) - borrowedValue[recepient];
//                         require(
//                             _amount < factor,
//                             "cant withdraw collateral used to support borrow"
//                         );
//                         collateralAmount[recepient] -= _amount;
//                         (bool sent, ) = payable(recepient).call{value: _amount}(
//                             ""
//                         );
//                         require(sent, "Failed to send Ether");
//                         pass = 1;
//                     } else {
//                         uint factor = (
//                             ((tmcr[recepient] * collateralValue[recepient]) /
//                                 100)
//                         ) - borrowedValue[recepient];
//                         require(
//                             _amount < factor,
//                             "cant withdraw collateral used to support borrow"
//                         );
//                         collateralAmount[recepient] -= _amount;
//                         (bool sent, ) = payable(recepient).call{value: _amount}(
//                             ""
//                         );
//                         require(sent, "Failed to send Ether");
//                         pass = 1;
//                     }
//                 }
//             }
//         }

//         return pass;
//     }

//     //increase of data.Liquidity
//     function repay(
//         uint _amount,
//         uint256 _collateralFactor,
//         uint256 _interestRate
//     ) external {
//         cook();
//         accureInterestRate(_interestRate);
//         BORROWTRANSACTIONS[] storage borrowData = addressToBorrowTransaction[
//             msg.sender
//         ];
//         LOCUS storage data = getLocus[_collateralFactor][_interestRate];
//         if (data.initialized != true) revert NON_EXITING_POSITION();
//         if (borrowData.length == 0) {
//             revert NOT_OWING();
//         }
//         for (uint i; i < borrowData.length; i++) {
//             if (
//                 data.collateralFactor ==
//                 borrowData[i].collateralFactorBorrowedAt &&
//                 data.interestRate == borrowData[i].interestRateBorrowedAt
//             ) {
//                 require(
//                     _amount <= (borrowedValue[msg.sender]), //1e23
//                     "amount more than borrowed amount"
//                 );
//                 //uint usdcAmount = priceB.getConversionRateUsdc(_amount);
//                 USDC.transferFrom(msg.sender, address(this), _amount);
//                 borrowedValue[msg.sender] -= _amount;
//                 data.liquidity += _amount;
//                 AmountBorrowedFromLocus[_collateralFactor][
//                     _interestRate
//                 ] -= _amount;
//                 if (_amount == (borrowedValue[msg.sender])) {
//                     //1e23
//                     borrowData[i] = borrowData[borrowData.length - 1];
//                     borrowData.pop();
//                     (borrowedValue[msg.sender] == 0);
//                 } else {
//                     borrowData[i].totalBorrowed -= _amount;
//                 }
//             }
//         }
//     }

//     function getHealthFactor(address _borrower)
//         public
//         view
//         returns (uint healthFactor)
//     {
//         uint x = SafeMath.mul(borrowedValue[_borrower], 100);
//         return
//             FullMath.mulDivRoundingUp(
//                 collateralValue[_borrower] * 1e10,
//                 liquidationThreshold,
//                 x
//             );
//     }

//     function liquidate(address _borrower) external {
//         cook();
//         require(borrowedValue[_borrower] > 0, "no borrow");

//         uint healthFactor = getHealthFactor(_borrower);
//         uint amountOfcoll = collateralAmount[_borrower];

//         if (healthFactor < 1e10) {
//             BORROWTRANSACTIONS[] memory borrowData = addressToBorrowTransaction[
//                 _borrower
//             ];
//             collateralAmount[_borrower] = 0;
//             borrowedValue[_borrower] = 0;
//             collateralValue[_borrower] = 0;

//             // address(this).balance - collateralAmount[_borrower];
//             (bool sent, ) = payable(address(auctionPool)).call{
//                 value: amountOfcoll
//             }("");
//             require(sent, "Failed to send Ether");
//             for (uint i; i < borrowData.length; i++) {
//                 liquidatedTransactions.push(
//                     LIQUIDATEDTRANSACTIONS({
//                         locusId: borrowData[i].locusId,
//                         interestRateBorrowedAt: borrowData[i]
//                             .interestRateBorrowedAt,
//                         collateralFactorBorrowedAt: borrowData[i]
//                             .collateralFactorBorrowedAt,
//                         amountLiquidatedFromPool: borrowData[i].totalBorrowed
//                     })
//                 );
//                 AmountBorrowedFromLocus[
//                     borrowData[i].collateralFactorBorrowedAt
//                 ][borrowData[i].interestRateBorrowedAt] -= borrowData[i]
//                     .totalBorrowed;
//             }

//             borrowData = new BORROWTRANSACTIONS[](0);
//             allLiquidators.push(msg.sender);
//             UpdatePoolAfterLiquidation();
//         } else if (healthFactor >= 1e10) {
//             revert CANT_BE_LIQUIDATED();
//         }
//     }

//     function UpdatePoolAfterLiquidation() public {
//         if (liquidatedTransactions.length == 0) {
//             revert NO_PENDING_LIQUIDITY_UPDATE_FOR_LOCUSES();
//         } else {
//             for (uint i; i > liquidatedTransactions.length; i++) {
//                 LIQUIDATEDTRANSACTIONS
//                     storage LiquidationData = liquidatedTransactions[i];
//                 LOCUS storage data = getLocus[
//                     LiquidationData.collateralFactorBorrowedAt
//                 ][LiquidationData.interestRateBorrowedAt];
//                 if (LiquidationData.locusId == data.locusId) {
//                     data.liquidity += LiquidationData.amountLiquidatedFromPool;
//                     LiquidationData.amountLiquidatedFromPool = 0;
//                 }
//             }
//         }
//     }

//     function chackIfLiquidationIsAllowed(address _borrower)
//         public
//         view
//         returns (bool CAN_BE_LIQUIDATED)
//     {
//         require(borrowedValue[_borrower] > 0, "no borrow");
//         // uint x = SafeMath.mul(borrowedValue[_borrower], 100);
//         uint healtFactor = getHealthFactor(_borrower);
//         if (healtFactor < 1e10) {
//             return true;
//         } else if (healtFactor >= 1e10) {
//             return false;
//         }
//     }

//     function setLiquidationThreshold(uint _LiquidationFee) external {
//         LiquidationFee = _LiquidationFee;
//         liquidationThreshold = 100 - _LiquidationFee;
//     }

//     function cook() internal {
//         collateralValue[msg.sender] = priceB.inverseConversionEth(
//             collateralAmount[msg.sender] * 1e10
//         );
//         //getPriceUsdc();
//         //getPriceEth();
//     }

//     function getNowInternal() public view virtual returns (uint64) {
//         if (block.timestamp >= 2**64) revert TimestampTooLarge();
//         return uint64(block.timestamp);
//     }

//     function calBorrowInt(uint _collateralFactor, uint _interestRate) internal {
//         uint64 now_ = getNowInternal();
//         uint64 formerTime = LastDebtAccuredTimeLocus[_collateralFactor][
//             _interestRate
//         ];
//         uint64 timeElapsed = now_ - formerTime;
//         uint acuuredDebt = SafeMath.mul(_interestRate, timeElapsed);
//         uint timeDf = SafeMath.mul(100, SECONDS_PER_YEAR);
//         uint debt = AmountBorrowedFromLocuswithInterest[_collateralFactor][
//             _interestRate
//         ];
//         uint gwt = FullMath.mulDivRoundingUp(acuuredDebt, debt, timeDf);
//         AmountBorrowedFromLocuswithInterest[_collateralFactor][
//             _interestRate
//         ] += gwt;
//         LastDebtAccuredTimeLocus[_collateralFactor][_interestRate] = now_;
//     }

//     function accuredK(uint _collateralFactor, uint _interestRate)
//         public
//         returns (uint newK)
//     {
//         LOCUS storage data = Position.getLocus[_collateralFactor][
//             _interestRate
//         ];
//         calBorrowInt(_collateralFactor, _interestRate);

//         uint newDebt = (data.liquidity.mul(1e27)).add(
//             AmountBorrowedFromLocuswithInterest[_collateralFactor][
//                 _interestRate
//             ]
//         );
//         uint position_size = TotalPositionSize[_collateralFactor][_interestRate]
//             .mul(1e17);
//         data.k = newDebt.div(position_size);
//         return data.k;
//     }

//     /*function accureInterestRate() internal {
//         uint64 now_ = getNowInternal();
//         uint64 formerTime = borrowerTimer[msg.sender];
//         uint64 timeElapsed = now_ - formerTime;

//         uint Scaledtime = SECONDS_PER_YEAR * 100;
//         uint scaledInterestRate = air[msg.sender];
//         uint TimeDiff = timeElapsed * borrowedValue[msg.sender];
//         uint newTotalborrows = FullMath.mulDivRoundingUp(
//             scaledInterestRate,
//             TimeDiff,
//             Scaledtime
//         );

//         borrowedValue[msg.sender] += newTotalborrows;

//         borrowerTimer[msg.sender] = now_;
//     }*/

//     function accureInterestRate(uint _interestRate) internal {
//         uint64 now_ = getNowInternal();
//         uint64 formerTime = borrowerTimer[msg.sender];
//         uint64 timeElapsed = now_ - formerTime;
//         uint acuuredDebt = SafeMath.mul(_interestRate, timeElapsed);
//         uint timeDf = SafeMath.mul(100, SECONDS_PER_YEAR);
//         uint debt = borrowedValue[msg.sender];

//         uint gwt = FullMath.mulDivRoundingUp(acuuredDebt, debt, timeDf);

//         borrowedValue[msg.sender] += gwt;
//         borrowerTimer[msg.sender] = now_;
//     }

//     function getValueofInvariant(
//         uint256 _collateralFactor,
//         uint256 _interestRate
//     ) external view returns (uint invariantValue) {
//         LOCUS memory data = getLocus[_collateralFactor][_interestRate];
//         if (data.k == 0) {
//             invariantValue = 1e10;
//         } else {
//             invariantValue = data.k;
//         }
//     }

//     function getPresumedPositionSize(
//         uint _amount,
//         uint256 _collateralFactor,
//         uint256 _interestRate
//     ) external view returns (uint positionSize) {
//         LOCUS memory data = getLocus[_collateralFactor][_interestRate];
//         if (data.k == 0) {
//             uint invariantValue = 1e10;
//             positionSize = (_amount * 1e10) / invariantValue;
//         } else {
//             uint invariantValue = data.k;
//             positionSize = (_amount * 1e10) / invariantValue;
//         }
//     }

//     function getAllUserBorrowedTransaction()
//         external
//         view
//         returns (BORROWTRANSACTIONS[] memory)
//     {
//         return addressToBorrowTransaction[msg.sender];
//     }

//     function getUserLiquidationPoint(address _user)
//         external
//         view
//         returns (uint liquidationPoint)
//     {
//         liquidationPoint = ((collateralValue[_user] * liquidationThreshold) /
//             100);
//     }

//     function getAvaliableLiquidity(
//         uint256 _collateralFactor,
//         uint256 _interestRate
//     ) external view returns (uint avaliableLiquidity) {
//         LOCUS memory data = getLocus[_collateralFactor][_interestRate];
//         avaliableLiquidity = data.liquidity;
//         return avaliableLiquidity;
//     }

//     // function getAllExistingLocus()external view returns (LOCUS [] memory){
//     //         return  allExistingLocus;

//     //     }

//     receive() external payable {}

//     fallback() external payable {}
// }
