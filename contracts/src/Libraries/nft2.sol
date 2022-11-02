// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.8.7;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/// @title NFTSVG
/// @notice Provides a function for generating an SVG associated with a Nitro NFT
library NFTbuilder {
    using Strings for uint256;

    struct Data {
        string amount;
        string collateralFactor;
        string interestRate;
        string tokenId;
        string name;
        string x;
        string y;
    }

    function getmetadata(Data memory param)
        public
        pure
        returns (string memory)
    {
        string memory base = "data:application/json;base64,";
        string memory metadata = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "',
                        param.name,
                        '","description":"This NFT is a representation of a Liquidity Position in Nitro Finance",',
                        '"image":"',
                        generateSVG(
                            param.tokenId,
                            param.amount,
                            param.collateralFactor,
                            param.interestRate,
                            param.x,
                            param.y
                        ),
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked(base, metadata));
    }

    function generateSVG(
        string memory tokenId,
        string memory Position_size,
        string memory col,
        string memory interest,
        string memory x,
        string memory y
    ) internal pure returns (string memory svg) {
        string memory BASEURL = "data:image/svg+xml;base64,";
        return
            string(
                abi.encodePacked(
                    BASEURL,
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                generategraphUpper(x, y),
                                generategraphLower(col, interest, x, y),
                                generateInfo(tokenId, Position_size)
                            )
                        )
                    )
                )
            );
    }

    function generategraphUpper(string memory x, string memory y)
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '<svg id="eGd1sBp6XHe1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"',
                    ' viewBox="0 0 600 700" shape-rendering="geometricPrecision" text-rendering="geometricPrecision">',
                    "<style><![CDATA[",
                    "#eGd1sBp6XHe7 {animation-name: eGd1sBp6XHe7_s_do, eGd1sBp6XHe7_s_da;animation-duration: 3000ms;animation-fill-mode: forwards;animation-timing-function: linear;animation-direction: normal;animation-iteration-count: infinite;}@keyframes eGd1sBp6XHe7_s_do { 0% {stroke-dashoffset: 198.092395} 66.666667% {stroke-dashoffset: 0} 100% {stroke-dashoffset: 0}}@keyframes eGd1sBp6XHe7_s_da { 0% {stroke-dasharray: 198.092395} 66.666667% {stroke-dasharray: 0} 100% {stroke-dasharray: 0}} #eGd1sBp6XHe8 {animation-name: eGd1sBp6XHe8_s_do, eGd1sBp6XHe8_s_da;animation-duration: 3000ms;animation-fill-mode: forwards;animation-timing-function: linear;animation-direction: normal;animation-iteration-count: infinite;}@keyframes eGd1sBp6XHe8_s_do { 0% {stroke-dashoffset: 200.227096} 66.666667% {stroke-dashoffset: 0} 100% {stroke-dashoffset: 0}}@keyframes eGd1sBp6XHe8_s_da { 0% {stroke-dasharray: 200.227096} 66.666667% {stroke-dasharray: 0} 100% {stroke-dasharray: 0}} #eGd1sBp6XHe9 {animation: eGd1sBp6XHe9_s_do 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe9_s_do { 0% {stroke-dashoffset: 127.86458} 20% {stroke-dashoffset: 127.86458} 53.333333% {stroke-dashoffset: 0} 100% {stroke-dashoffset: 0}} #eGd1sBp6XHe10 {animation: eGd1sBp6XHe10_s_do 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe10_s_do { 0% {stroke-dashoffset: 154.817815} 20% {stroke-dashoffset: 154.817815} 53.333333% {stroke-dashoffset: 0} 100% {stroke-dashoffset: 0}} #eGd1sBp6XHe11 {animation: eGd1sBp6XHe11_c_o 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe11_c_o { 0% {opacity: 0} 93.333333% {opacity: 1} 100% {opacity: 1}} #eGd1sBp6XHe13 {animation: eGd1sBp6XHe13_c_o 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe13_c_o { 0% {opacity: 0} 93.333333% {opacity: 1} 100% {opacity: 1}} #eGd1sBp6XHe24 {animation: eGd1sBp6XHe24_s_do 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe24_s_do { 0% {stroke-dashoffset: 94.25} 66.666667% {stroke-dashoffset: 94.25} 93.333333% {stroke-dashoffset: 0} 100% {stroke-dashoffset: 0}} #eGd1sBp6XHe25 {animation: eGd1sBp6XHe25_c_o 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe25_c_o { 0% {opacity: 0} 56.666667% {opacity: 1} 100% {opacity: 1}} #eGd1sBp6XHe27 {animation: eGd1sBp6XHe27_c_o 3000ms linear infinite normal forwards}@keyframes eGd1sBp6XHe27_c_o { 0% {opacity: 0} 56.666667% {opacity: 1} 100% {opacity: 1}}",
                    "]]></style>",
                    '<defs><linearGradient id="eGd1sBp6XHe3-fill" x1="0" y1="0.5" x2="1" y2="0.5" spreadMethod="pad" gradientUnits="objectBoundingBox" gradientTransform="translate(0 0)"><stop id="eGd1sBp6XHe3-fill-0" offset="0%" stop-color="hsl(',
                    x,
                    ', 30%, 30%)"/><stop id="eGd1sBp6XHe3-fill-1" offset="100%" stop-color="hsl(',
                    y,
                    ', 30%, 30%)"/></linearGradient><linearGradient id="eGd1sBp6XHe4-fill" x1="0" y1="0.5" x2="1" y2="0.5" spreadMethod="pad" gradientUnits="objectBoundingBox" gradientTransform="translate(0 0)"><stop id="eGd1sBp6XHe4-fill-0" offset="0%" stop-color="hsl(',
                    x,
                    ',30%,30%)"/><stop id="eGd1sBp6XHe4-fill-1" offset="100%" stop-color="hsl(',
                    y
                )
            );
    }

    function generategraphLower(
        string memory col,
        string memory interest,
        string memory x,
        string memory y
    ) internal pure returns (string memory) {
        return
            string(
                abi.encodePacked(
                    ',30%,30%)"/></linearGradient><linearGradient id="eGd1sBp6XHe5-fill" x1="0" y1="0.5" x2="1" y2="0.5" spreadMethod="pad" gradientUnits="objectBoundingBox" gradientTransform="translate(0 0)"><stop id="eGd1sBp6XHe5-fill-0" offset="0%" stop-color="hsl(',
                    x,
                    ',30%,30%)"/><stop id="eGd1sBp6XHe5-fill-1" offset="50%" stop-color="#cac7d1"/><stop id="eGd1sBp6XHe5-fill-2" offset="100%" stop-color="hsl(',
                    y,
                    ',30%,30%)"/></linearGradient></defs><g transform="matrix(.947751 0 0 1 22.651511 0.97908)"><rect width="453.497457" height="529.96533" rx="49" ry="49" transform="matrix(.957357 0 0 1.212803 90.286582 27.649125)" fill="url(#eGd1sBp6XHe3-fill)" stroke-width="0"/><rect width="374.862338" height="603.237506" rx="53" ry="53" transform="translate(119.568831 43.915902)" fill="url(#eGd1sBp6XHe4-fill)" stroke="rgb(170, 172, 172)" stroke-width="2"/><rect width="276.38725" height="313.704718" rx="51" ry="51" transform="matrix(1.079362 0 0 1 159.777836 145.796893)" fill="url(#eGd1sBp6XHe5-fill)" stroke-width="0"/><g transform="translate(22.309595 62.612809)"><line id="eGd1sBp6XHe7" x1="0" y1="-96.742877" x2="0" y2="101.349518" transform="matrix(2.5 0 0 1.07 200.567329 234.751148)" fill="none" stroke="rgb(255,255,255)" stroke-width="3" stroke-linecap="round" stroke-linejoin="bevel" stroke-dashoffset="198.092395" stroke-dasharray="198.092395"/><line id="eGd1sBp6XHe8" x1="-100.113548" y1="0" x2="100.113548" y2="0" transform="matrix(1.25 0 0 2.5 299.680878 317.445186)" fill="none" stroke="rgb(255,255,255)" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" stroke-dashoffset="200.227096" stroke-dasharray="200.227096"/><line id="eGd1sBp6XHe9" x1="-49.716335" y1="0" x2="78.148245" y2="0" transform="matrix(1 0 0 2.5 250.283665 185.273981)" fill="none" stroke="rgb(255,255,255)" stroke-width="3" stroke-dashoffset="127.86458" stroke-dasharray="127.86458"/><line id="eGd1sBp6XHe10" x1="0.159561" y1="-88.731884" x2="-0.159561" y2="66.085602" transform="matrix(2.5 0 0 1 299.84044 251.359584)" fill="none" stroke="rgb(255,255,255)" stroke-width="3" stroke-linecap="round" stroke-linejoin="bevel" stroke-dashoffset="154.817815" stroke-dasharray="154.817815"/><text id="eGd1sBp6XHe11" dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Concert One&quot;" font-size="20" font-weight="700" transform="translate(158.584806 195.968057)" opacity="0" fill="rgb(255,255,255)" stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[',
                    col,
                    '%]]></tspan></text><text id="eGd1sBp6XHe13" dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Concert One&quot;" font-size="20" font-weight="700" transform="matrix(1 0 0 0.85693 281.359128 339.789038)" opacity="0" fill="rgb(255,255,255)" stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[',
                    interest,
                    "%]]></tspan></text></g>"
                )
            );
    }

    function generateInfo(string memory tokenId, string memory Position_size)
        internal
        pure
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    '<g transform="matrix(.926126 0 0 1 27.098619 0)"><rect width="245" height="29.99997" rx="8" ry="8" transform="matrix(1 0 0 1.000001 121.822116 491.41555)" fill="#222222" opacity="0.5" stroke-width="0"/><rect width="215.676229" height="30" rx="8" ry="8" transform="matrix(1.135962 0 0 1 121.822117 534.701626)" fill="#222222" opacity="0.5" stroke-width="0"/><text dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Lora&quot;" font-size="20" font-weight="700" transform="translate(136.176978 516.355203)" fill="rgb(255,255,255)" stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[TokenId: ',
                    tokenId,
                    ']]></tspan></text><text dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Lora&quot;" font-size="20" font-weight="700" fill="rgb(255,255,255)" transform="translate(133.335679 557.812398)" stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[Position Size: ',
                    Position_size,
                    'K ]]></tspan></text></g><text dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Noto Serif&quot;" font-size="50" font-weight="700" letter-spacing="3" transform="translate(239.974119 108.685884)" fill="rgba(243,239,239,0.97)" stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[ETH/USDC',
                    ']]></tspan></text><ellipse id="eGd1sBp6XHe24" rx="15" ry="15" transform="translate(322 247.05)" paint-order="stroke fill markers" fill="none" stroke="rgb(255,255,255)" stroke-width="2" stroke-dashoffset="94.25" stroke-dasharray="94.25"/></g><text id="eGd1sBp6XHe25" dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Concert One&quot;" font-size="20" font-weight="700" transform="matrix(1.408805 0 0 1 196.825757 207.391139)" opacity="0" fill="rgb(255,255,255)" stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[C',
                    ']]></tspan></text><text id="eGd1sBp6XHe27" dx="0" dy="0" font-family="&quot;eGd1sBp6XHe1:::Concert One&quot;" font-size="20" font-weight="700" transform="translate(435.678629 413.266281)" opacity="0" fill="rgb(255,255,255)"  stroke-width="0"><tspan y="0" font-weight="700" stroke-width="0"><![CDATA[I',
                    "]]></tspan></text></svg>"
                )
            );
    }
}
