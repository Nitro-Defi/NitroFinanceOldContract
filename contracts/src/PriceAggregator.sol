// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./Interfaces/IOracle.sol";

contract PriceAggregator {
    IOracle public constant OracleEth =
        IOracle(0x3ad03DDdF9c0D73613DC6A2Ab325c172C1Eb8cC1);
    IOracle public constant OracleUSDC =
        IOracle(0x1a6F78E58D0811Db2a742d6C67F3F06b703979E1);
    bytes constant oracleDataETH = "0x62CAe0FA2da220f43a51F86Db2EDb36DcA9A5A08";
    bytes constant oracleDataUSDC =
        "0x1692Bdd32F31b831caAc1b0c9fAF68613682813b";

    uint256 public priceEth;
    uint256 public priceUsdc;
    uint256 public EthPrice;
    uint256 public UsdcPrice;

    uint256 public UsdcAmountInUsd;
    uint256 public ethAmountInUsd;

    uint256 public valueUsdc;
    uint256 public valueETH;

    function getPriceEth() public returns (uint256) {
        (, uint256 raw) = OracleEth.get(oracleDataETH);
        EthPrice = raw / 1e10;
        return priceEth;
    }

    function getPriceUsdc() public returns (uint256) {
        (, uint256 raw) = OracleUSDC.get(oracleDataUSDC);
        UsdcPrice = raw / 1e18;
        return priceUsdc;
    }

    function inverseConversionEth(uint256 _amount) public returns (uint256) {
        valueETH = (_amount * EthPrice) / 1e26;
        return valueETH;
    }

    function inverseConversionUsdc(uint256 _amount) public returns (uint256) {
        valueUsdc = (_amount * UsdcPrice) / 1e34;
        return valueUsdc;
    }

    function getConversionRateEth(uint256 _value) public returns (uint256) {
        //getPriceEth();
        return ethAmountInUsd = (1e18 * _value) / EthPrice;
    }

    function getConversionRateUsdc(uint256 _value) public returns (uint256) {
        //getPriceUsdc();

        return UsdcAmountInUsd = (1e18 * _value) / UsdcPrice;
    }

    function setDummyPriceEth(uint256 _priceEth) public {
        EthPrice = _priceEth;
    }

    function setDummyPriceUsdc(uint256 _priceUsdc) public {
        UsdcPrice = _priceUsdc;
    }

    function updatePrices() public returns (uint256, uint256) {
        getPriceUsdc();
        getPriceEth();
        return (priceUsdc, priceEth);
    }
}
