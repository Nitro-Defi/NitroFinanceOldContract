pragma solidity 0.8.7;

import "./OracleUni.sol";
import "./sol6.sol";

contract Factory {
    address immutable governor;
    address[] internal AllowedStablePair = [
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
        0x07865c6E87B9F70255377e024ace6630C1Eaa37F
    ];
    address immutable facoryAddress =
        0x1F98431c8aD98523631AE4a59f267346ea31F984;
    address immutable NFTManagerAddress;

    constructor(address _governor, address _NFTManagerAddress) {
        governor = _governor;
        NFTManagerAddress = _NFTManagerAddress;
    }

    mapping(address => mapping(address => bool)) private initialized;
    mapping(address => mapping(address => address)) public getPool;
    mapping(address => mapping(address => address)) public getPoolOracle;
    // struct Params {
    //     address token0;
    //     address token1;
    //     uint24 fee;
    // }

    modifier onlyOwner() {
        require(msg.sender == governor, "Factory: Only Governor");
        _;
    }

    function createOracle(
        address token0,
        address token1,
        uint24 fee
    ) internal returns (address FactoryAddress) {
        for (uint i = 0; i < AllowedStablePair.length; i++) {
            if (token1 == AllowedStablePair[i]) {
                FactoryAddress = address(
                    new UniswapV3Twap(facoryAddress, token0, token1, fee)
                );
            }
        }
        require(FactoryAddress != address(0), "NOT ALLOWED STABLE");
        getPoolOracle[token0][token1] = FactoryAddress;
        getPoolOracle[token1][token0] = FactoryAddress;
    }

    function deploy(
        address token0,
        address token1,
        uint24 fee
    ) external returns (address pool) {
        require(initialized[token0][token1] == false, "Already Initialized");
        pool = address(
            new SOL5(
                createOracle(token0, token1, fee),
                NFTManagerAddress,
                token1,
                token0,
                fee
            )
        );
        initialized[token0][token1] = true;
        initialized[token1][token0] = true;
        getPool[token0][token1] = pool;
        getPool[token1][token0] = pool;
    }

    function AddStableAddress(address StableAddress) external onlyOwner {
        AllowedStablePair.push(StableAddress);
    }
}
