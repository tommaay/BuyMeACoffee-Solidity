//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

// BuyMeACoffee deployed to: 0x889F8dc7aBB1e4533a18fa8Ce57Be1FB8e625dB4

contract BuyMeACoffee {
    // Event to emit when a Memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received from friends
    Memo[] memos;

    // Address of contract deployer
    address owner;
    address payable withdrawToAddress;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract creator can call this function."
        );
        _; // run the function code
    }

    constructor() {
        owner = msg.sender;
        withdrawToAddress = payable(msg.sender);
    }

    /**
     * @dev buy a coffee for contract owner
     * @param _name name of the coffee buyer
     * @param _message a nice message from the coffee buyer
     */
    function buyCoffee(string memory _name, string memory _message)
        public
        payable
    {
        require(msg.value > 0, "You can't buy coffee with 0 ETH");

        // Add the memo to storage
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        // Emit a log event when a new memo is created
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
     * @dev send the entire balance stored in this contract to the owner
     */
    function withdrawTips() public {
        require(withdrawToAddress.send(address(this).balance));
    }

    /**
     * @dev retrieve all the memos received and stored on the blockchain
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    /**
     * @dev update the withdraw to address
     */
    function updateWithdrawAddress(address _address) public onlyOwner {
        withdrawToAddress = payable(_address);
    }

    /**
     * @dev get withdraw to address
     */
    function getWithdrawAddress() public view onlyOwner returns (address) {
        return withdrawToAddress;
    }
}
