pragma solidity 0.8.7;

import "./SoulBoundToken.sol";

contract Verify {
    SoulBoundToken SoulNFT = SoulBoundToken(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

    mapping(address => uint256) public verifiedAddresses;

    function verifier(string calldata _uri) external {
        verifiedAddresses[msg.sender] = SoulNFT.count();
        SoulNFT.issue(msg.sender, _uri);
    }
}
