pragma solidity 0.8.7;

library Position {
    struct LOCUS {
        uint256 collateralFactor;
        uint256 interestRate;
        uint256 locusId;
        uint256 liquidity;
        uint256 k;
    }

    function get(mapping(uint256 => Position.LOCUS) storage data) internal returns (LOCUS memory locus) {}

    function put(
        mapping(uint256 => Position.LOCUS) storage data,
        uint256 _collateralFactor,
        uint256 _interestRate,
        uint256 _count,
        uint256 _liquidity
    ) internal {
        data[_count].collateralFactor = _collateralFactor;
        data[_count].interestRate = _interestRate;
        data[_count].locusId = _count;
        data[_count].liquidity = _liquidity;
        data[_count].k = 1;
    }

    function update() internal {}
}

/*   function _updatePosition(
        address owner,
        int24 tickLower,
        int24 tickUpper,
        int128 liquidityDelta,
        int24 tick
    ) private returns (Position.Info storage position) {
        position = positions.get(owner, tickLower, tickUpper);
        
        
        
         function get(
        mapping(bytes32 => Info) storage self,
        address owner,
        int24 tickLower,
        int24 tickUpper
    ) internal view returns (Position.Info storage position) {
        
        
        
        */
