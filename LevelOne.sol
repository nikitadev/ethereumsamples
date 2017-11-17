pragma solidity ^0.4.15;

contract LessonFirst {
    
    uint256 public currentNumber;

    // lesson 1-3
    function _setNumber(address _to, uint8 _number) {

        if (msg.value != 1 * 0.1 ether) throw;
        
        if(!_to.send(msg.value)) throw;

        currentNumber = _number;
    }

    // lesson 1-3
    function setNumber(uint8 _number) payable {
        _setNumber(msg.sender, _number);
    }
}