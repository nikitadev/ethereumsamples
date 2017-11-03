pragma solidity ^0.4.15;

contract LessonFirst {
    uint256 public number;

    function () payable {
        if (msg.value >= 1 * 0.1 ether)
            number = block.number;
    }
}