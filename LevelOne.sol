contract LessonFirst {
    uint256 public number;

    public () payable {
        number = block.number;
    }
}