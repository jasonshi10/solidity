// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
/*
4 steps to verify signature
1. message to sign
2. hash(message)
3. sign(hash(message), private key) | offchain
4. ecrecover(hash(message), signature) == sginer
*/
contract VerifySig {
    function getMessageHash(string memory _message)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        /*
        This is the actual hash that is signed, keccak256 of
        \x19Ethereum Signed Message\n + len(msg) + msg
        */
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    // Function to split signature into 3 parameters needed by ecrecover
    function _split(bytes memory _sig)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
        // implicitly return (r, s, v)
    }

    // Recovers the signer
    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    // Function to verify signature
    // returns true if `_message` is the signed by `_signer`
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    bool public signed;

    function testSignature(address _signer, bytes memory _sig) external {
        string memory message = "secret";

        bytes32 messageHash = getMessageHash(message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        require(recover(ethSignedMessageHash, _sig) == _signer, "invalid sig");
        signed = true;
    }
}


/*
Delegatecall is like call, except the code of callee is executed inside the caller.
For example contract A calls delegatecall on contract B.
Code inside B is executed using A's context such as storage, msg.sender and msg.value.
*/
contract DelegateCall {
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable {
        // This contract's storage is updated, TestDelegateCall's storage is not modified.
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
        require(success, "tx failed");
    }

    function setNum(address _test, uint _num) external {
        (bool success, bytes memory data) = _test.delegatecall(
            abi.encodeWithSignature("setNum(uint256)", _num)
        );
        require(success, "tx failed");
    }
}

/*
Implement Piggybank
Anyone can send Ether to this contract.
However only the owner can withdraw, upon which the contract will be deleted.
*/

contract PiggyBank {
    event Deposit(uint amount);
    event Withdraw(uint amount);
    address public owner = msg.sender;
    // enable contract to receive ether
    receive() external payable {
        emit Deposit(msg.value);
    }


    function withdraw() external {
        require(owner == msg.sender, "not the owner");
        emit Withdraw(address(this).balance);
        // delete contract upon withdraw all eth to the owner
        selfdestruct(payable(msg.sender));
    }
}
