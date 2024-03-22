// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

contract MessageBoard {
    uint256 public messageCount;
    mapping(uint256 => string) messages;

    function addMessage(string calldata message) public returns (uint256) {
        messages[messageCount] = message;
        messageCount++;
        return messageCount;
    }

    function getMessageAtIndex(uint256 index) public view returns (string memory) {
        require(index < messageCount);
        return messages[index];
    }
}
