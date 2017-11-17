pragma solidity ^0.4.15;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract SampleOraclize is usingOraclize {

    struct Person {
        address delegate;
        uint number;
        uint amount;
    }

    uint constant period = 60;

    uint256 public currentNumber;

    mapping (bytes32 => Person) numbers;

    event newOraclizeQuery(string description);

    function __callback(bytes32 _myid, string _result) {
        if (msg.sender != oraclize_cbAddress()) throw;

        uint price = parseInt(_result, 2);
        Person storage sender = numbers[_myid];
        uint value = sender.amount;
        if ((value / price) >= 1 * 10) {
            
            if (sender.delegate.send(value)) throw;

            currentNumber = sender.number;
        }
    }

    function updateNumber(address _to, uint8 _number) payable {
        if (oraclize_getPrice("URL") > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 myid = oraclize_query(period, "URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");

            numbers[myid] = Person({delegate: _to, number: _number, amount: msg.value});
        }
    }
}