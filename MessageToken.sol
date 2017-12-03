pragma solidity ^0.4.11;

contract SimpleToken {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;

    function SimpleToken() {

        decimals = 8;
        totalSupply = 10000000 * (10 ** uint256(decimals));

        balanceOf[msg.sender] = totalSupply;

        name = "SimpleToken";
        symbol = "ST";
    }

    function transfer(address _to, uint256 _value) {
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}

contract  MessageToken is SimpleToken {

    struct Voter {
        bool voted;
        uint timestamp;
    }

    uint constant period = 1;

    string public currentMessage;

    uint currentAmount;
    uint countAddresses;
    uint currentAmountMsg;    

    mapping (address => Voter) public voters;
    mapping (uint => address) addresses;

    function MessageToken() {
        countAddresses = currentAmountMsg = 0;
    }

    function setMessage(address _to, uint _value, string _msg) public {

        require(currentAmountMsg < _value);

        Voter storage voter = voters[_to];
        require(voter.voted != false);

        voter.timestamp = now;

        currentAmount += _value;

        transfer(_to, _value);
        
        _setMessage(_value, _msg);
    }
    
    function _setMessage(uint256 _value, string _msg) internal {
        
        uint prevToken = balanceOf[addresses[countAddresses]];
        
        require(prevToken < _value);

        currentMessage = _msg;
    }

    function vote(address _to, uint _amount) public {

        Voter storage voter = voters[_to];
        addresses[countAddresses] = _to;

        // Раз в какое-то время владельцы токена могут проголосовать за стоимость установки рекламной записи в токенах
        voter.voted = now < voter.timestamp + period * 1 minutes;

        if (voter.voted == false) {
            voter.voted = true;
            voter.timestamp = now;
        }

        countAddresses++;

        currentAmountMsg = _amount;
    }

    function destribution() public {

        require(currentAmount != 0);

        uint sum = currentAmount / countAddresses;
        for (uint i = 0; i < countAddresses; i++) {
            balanceOf[addresses[i]] += sum;
            currentAmount -= sum;
        }
    }
}

