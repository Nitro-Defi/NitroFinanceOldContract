pragma solidity 0.8.7;

contract Position {
    struct LOCUS {
        uint256 collateralFactor;
        uint256 interestRate;
        uint256 locusId;
        uint256 liquidity;
        uint256 k;
        bool initialized;
    }

    struct TOKENDATA {
        uint256 amount;
        uint256 collateralFactor;
        uint256 interestRate;
        uint256 locusId;
        uint256 tokenId;
        uint256 kAtInstance;
        string name;
        string bgHue;
        string textHue;
    }

    mapping(uint256 => mapping(uint256 => Position.LOCUS)) public getLocus;

    //mapping(uint => Position.LOCUS) public locus;

    /*function get(uint _locusId) internal view returns (LOCUS memory data) {
        data = locus[_locusId];
    }
    */

    function put(
        uint256 _collateralFactor,
        uint256 _interestRate,
        uint256 _count,
        uint256 _liquidity
    ) internal {
        getLocus[_collateralFactor][_interestRate] = (
            LOCUS({
                collateralFactor: _collateralFactor,
                interestRate: _interestRate,
                locusId: _count,
                liquidity: _liquidity,
                k: 1e10,
                initialized: true
            })
        );
    }

    // function update(
    //     uint _locusId,
    //     uint _deltaK,
    //     uint _deltaLiquidity,
    //     uint _colFactor,
    //      uint _interestRate
    // ) internal {
    //     getLocus[_colFactor][_interestRate].k += _deltaK;
    //     getLocus[_collateralFactor][_interestRate].liquidity += _deltaLiquidity;
    // }
}
