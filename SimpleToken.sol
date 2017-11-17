pragma solidity ^0.4.11;

contract SimpleToken {

    uint8 public decimals;
    uint256 public totalSupply;

    uint index;
    string currentMessage;

    address[] entities;

    mapping (address => uint256) public balanceOf;

    function SimpleToken() {

        decimals = 8;
        totalSupply = 10000000 * (10 ** uint256(decimals));

        balanceOf[msg.sender] = 100000;
    }

    function setMessage(address _to, uint256 _value, string _msg) {
        transfer(_to, _value);
        
        _setMessage(_value, _msg);
        
        entities.push(_to);
        index++;
    }
    
    function _setMessage(uint256 _value, string _msg) {
        
        bool canRewrite = true;
        if (index != 0) {
            uint256 prevToken = balanceOf[entities[index]];

            canRewrite = prevToken < _value;
        }

        if (canRewrite) {
            currentMessage = _msg;
        }
    }

    function transfer(address _to, uint256 _value) {
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}