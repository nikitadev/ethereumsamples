pragma solidity ^0.4.11;

import "./SampleERC20.sol";

interface ISampleICO {
    function getDecimals() returns (uint8);
    function transfer(address _receiver, uint _amount);
}

contract SampleSafeICO {

    enum ReferralLevel { Hight, Medium, Low }

    uint256 public buyPrice;
    ISampleICO public token;
    
    address[] internal members;

    function SampleSafeICO(ISampleICO _token) {
        token = _token;
        
        buyPrice = 1 ether / (10 ** uint256(_token.getDecimals()));
        
        members.push(msg.sender);
    }

    function () payable {
        _buy(msg.sender, msg.value);
    }

    function buy() payable returns (uint) {
        uint tokens = _buy(msg.sender, msg.value);
        return tokens;
    }

    function _buy(address _sender, uint256 _amount) internal returns (uint)  {
        uint tokens = _amount / buyPrice;
        token.transfer(_sender, tokens);

        return tokens;
    }
    
    function getMembers() constant returns (address[]) {
        return members;
    }
    
    function distribution(address _to, uint256 _value) {
        uint256 half = (_value / 2);
        
        token.transfer(_to, half);

        uint256 value = half / members.length;
        for (uint256 i = 0; i < members.length; i++) {
            token.transfer(members[i], value);
        }
        
        members.push(_to);
    }
}