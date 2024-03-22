// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Test, console2} from "forge-std/Test.sol";
import {MessageBoard} from "../src/MessageBoard.sol";

contract MessageBoardTest is Test {
    MessageBoard public messageBoard;

    function setUp() public {
        messageBoard = new MessageBoard();
    }


    function testFail_getMessageWhenEmpty() public view {
        string memory message = messageBoard.getMessageAtIndex(0);
    }


    function test_addMessage() public {
        messageBoard.addMessage("I must not fear.");
        assertEq(messageBoard.messageCount(), 1);
    }


    function test_getMessageAtIndex() public {
        messageBoard.addMessage("I must not fear.");
        string memory message = messageBoard.getMessageAtIndex(0);
        assertEq(message, "I must not fear.");
    }


    function test_addMessages() public {
        addLitany(messageBoard);
        assertEq(messageBoard.messageCount(), 8);
    }


    function test_getMessages() public {
        addLitany(messageBoard);
        string memory message = messageBoard.getMessageAtIndex(0);
        assertEq(message, "I must not fear.");
        message = messageBoard.getMessageAtIndex(1);
        assertEq(message, "Fear is the mind-killer.");
        message = messageBoard.getMessageAtIndex(2);
        assertEq(message, "Fear is the little death that brings total obliteration.");
        message = messageBoard.getMessageAtIndex(3);
        assertEq(message, "I will face my fear.");
        message = messageBoard.getMessageAtIndex(4);
        assertEq(message, "I will permit it to pass over and through me.");
        message = messageBoard.getMessageAtIndex(5);
        assertEq(message, "And when it has gone past, I will turn the inner eye to see its path.");
        message = messageBoard.getMessageAtIndex(6);
        assertEq(message, "Where the fear has gone there will be nothing.");
        message = messageBoard.getMessageAtIndex(7);
        assertEq(message, "Only I will remain.");
    }


    function testFail_getMessageAtIndex() public {
        addLitany(messageBoard);
        string memory message = messageBoard.getMessageAtIndex(8);
    }

    function addLitany(MessageBoard mb) internal {
        mb.addMessage("I must not fear.");
        mb.addMessage("Fear is the mind-killer.");
        mb.addMessage("Fear is the little death that brings total obliteration.");
        mb.addMessage("I will face my fear.");
        mb.addMessage("I will permit it to pass over and through me.");
        mb.addMessage("And when it has gone past, I will turn the inner eye to see its path.");
        mb.addMessage("Where the fear has gone there will be nothing.");
        mb.addMessage("Only I will remain.");
    }
}
