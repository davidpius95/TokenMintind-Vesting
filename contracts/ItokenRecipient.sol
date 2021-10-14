//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
}