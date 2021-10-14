
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ItokenRecipient.sol";

contract MeshaToken is Ownable,IERC20 {
    
    string public _name;
    string public _symbol;
    uint8 public _decimals; 
    uint public _totalSupply;
    uint timeMintedLast;
    uint amountToMint = 225*10**18;
    uint public  totalToMint = 1000*10**18;
    
    mapping (address => uint256) public balances;
    // `allowed` tracks any extra transfer rights as in all ERC20 tokens
    mapping (address => mapping (address => uint256)) public allowed;
    mapping(address=>bool) public whitelistedDapps; //dapps that can burn tokens
    //makes sure only dappstore apps can burn tokens
    modifier timeElapse(){
        require( _totalSupply <= totalToMint, "STOP" );
        require(block.timestamp - timeMintedLast <= 365 days, "Minted Token");
        _;
    }


    constructor() public {
        _name="MESHA";
        _symbol="MSH";
        _decimals=18;
       _totalSupply = 100*10**18;
       timeMintedLast = block.timestamp;
       
        // Give the creator all initial tokens
        
        balances[msg.sender] = 100*10**18;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    //transfers an amount of tokens from one account to another
    //accepts two variables
    function transfer(address _to, uint256 _amount) public override  returns (bool success) {
        doTransfer(msg.sender, _to, _amount);
        return true;
}
  /**
   * @dev Returns the token symbol.
   */

  /**
  * @dev Returns the token name.
  */

    //transfers an amount of tokens from one account to another
    //accepts three variables
    function transferFrom(address _from, address _to, uint256 _amount
    ) public override returns (bool success) {
        // The standard ERC 20 transferFrom functionality
        require(allowed[_from][msg.sender] >= _amount);
        allowed[_from][msg.sender] -= _amount;
        doTransfer(_from, _to, _amount);
        return true;
    }
    //internal function to implement the transfer function and perform some safety checks
    function doTransfer(address _from, address _to, uint _amount
    ) internal {
        // Do not allow transfer to 0x0 or the token contract itself
        require((_to != address(0)) && (_to != address(this)));
        require(_amount <= balances[_from]);
        balances[_from] = balances[_from] - (_amount);
        balances[_to] = balances[_to]+ _amount;
        emit Transfer(_from, _to, _amount);
    }
   //returns balance of an address
    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }
    //allows an address to approve another address to spend its tokens
    function approve(address _spender, uint256 _amount) public override returns (bool success) {
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender,0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
    //sends the approve function but with a data argument
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public  returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }
    

    //returns the allowance an address has granted a spender
    function allowance(address _owner, address _spender
    ) public view override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }
    function _mint(address account) internal virtual onlyOwner() timeElapse {
        require(account !=address(0), "ERC20: mint to the zero address");
        _totalSupply += amountToMint;
        balances[account] += amountToMint;
        timeMintedLast = block.timestamp;
        emit Transfer(address (0), account, amountToMint);
    }
     fallback() external payable {}
    
    function minTokens(address to) public {
        _mint(to);
    }
}