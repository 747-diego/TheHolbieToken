pragma solidity ^0.5.16;

contract DappToken {
    // Constructor [X]
    // set the total number of tokens []
    // read the total number of tokens []

    // Name []
    string public name = "DApp Token";
    // Symbol []
    string public symbol = "DAPP";
    // Standard Version []
    string public standard = "DApp Token v1.0";

    uint256 public totalSupply;

    // DECLARRING TRANSFER EVENT 
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // TRANSFER EVENT
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );


    // MAPPING OF THE BALANCE OF OWNER AND RETURN UNSIGNED NUMBER
    mapping(address => uint256) public balanceOf;
    // MAPPING OF ALLOWANCE
    mapping(address => mapping(address => uint256)) public allowance;



    // DAPP TOKEN CONSTRUCTOR 
    constructor (uint256 _initialSupply) public {
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
        // allocate the inital supply
    }

    // TRANSFER
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // EXCEPTION IF ACCOUNT DOESN'T HAVE ENOUGH TOKENS
        require(balanceOf[msg.sender] >= _value);
        // TRANSFER THE BALANCE
        balanceOf[msg.sender] -= _value; // deducting balance from old account
        balanceOf[_to] += _value; // adding balance to new account
        // TRANSFER EVENT
        emit Transfer(msg.sender, _to, _value);
        // RETURN A BOOL
        return true;
    }

    // DELEGATED TRANSFERS

    // APPROVE EVENT
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // ALLOWANCE
        allowance[msg.sender][_spender] = _value;
        // APPROVE EVENT
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // TRANSFER FROM
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        // REQUIRE _from HAS ENOUGH BALAMCE
        // REQUIRE ALLOWANCE IS BIG ENOUGH 
        // CHANGE THE BALANCE
        balanceOf[_from] -= _value; // deducting balance from old account
        balanceOf[_to] += _value; // adding balance to new account
        // UPDATE THE ALLOWANCE
        allowance[_from][msg.sender] -= _value;
        // TRANSFER EVENT
        emit Transfer(_from, _to, _value);
        // RETURN A BOOLEAN
        return true;
        
    }


}
