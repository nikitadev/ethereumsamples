pragma solidity ^0.4.11;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

interface IMessageToken {
    function destribution();
}

contract ExampleContract is usingOraclize {

    IMessageToken public messageToken;
    uint constant scheduler = 1;

    event onUpdate(string price);
    event newOraclizeQuery(string description);

    function ExampleContract(IMessageToken _messageToken) {
        messageToken = _messageToken;
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;

        messageToken.destribution();

        onUpdate(result);
        update();
    }

    function update() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer.");
            oraclize_query(scheduler + 60, "WolframAlpha", "destribution update");
        }
    }
}