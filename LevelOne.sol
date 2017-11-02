contract LessonFirst {
    uint256 public number;

    function () payable {
        number = block.number;
    }
}