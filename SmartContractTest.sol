// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.1;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// ----------------------------------------------------------------------------

interface IERC20 {
    
function totalSupply() external view returns (uint256);
function balanceOf(address tokenOwner) external view returns (uint);
function allowance(address tokenOwner, address spender) external view returns (uint);
function transfer(address to, uint tokens) external returns (bool);
function approve(address spender, uint tokens)  external returns (bool);
function transferFrom(address from, address to, uint tokens) external returns (bool);

event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
event Transfer(address indexed from, address indexed to, uint tokens);

}

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------

library SafeMath { 
function sub(uint256 a, uint256 b) internal pure returns (uint256) {
  assert(b <= a);
  return a - b;
}
function add(uint256 a, uint256 b) internal pure returns (uint256)   {
  uint256 c = a + b;
  assert(c >= a);
  return c;
}
function safeDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        assert(b > 0);
        c = a / b;
    }
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a * b;
        assert(a == 0 || c / a == b);
    }
}
//------------------------------------------------------------------------
//------------------------------------------------------------------------

contract MinorityProgram is IERC20 {
    using SafeMath for uint256;
    string public  symbol;
    string public  name;
    uint8 public decimals;
    uint256 public totalSupply_;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
  
    constructor() public {
        symbol = "MPS";
        name = "MinorityPrograms";
        decimals = 18;
        totalSupply_ = 1000000;
        balances[msg.sender] = totalSupply_ ;
        emit Transfer(address(0), msg.sender, totalSupply_ );
    }

  // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view  override returns (uint256) {
  return totalSupply_;
}
  // ------------------------------------------------------------------------
    // Get the token balance for account tokenOwner
    // ------------------------------------------------------------------------
function balanceOf(address tokenOwner) public view  override returns (uint) {
  return balances[tokenOwner];
}
// ------------------------------------------------------------------------
    // Transfer Tokens to Another Account
    // ------------------------------------------------------------------------
function transfer(address receiver, uint numTokens) public override returns (bool) {
  require(numTokens <= balances[msg.sender]);
  balances[msg.sender] = balances[msg.sender].sub(numTokens);
  balances[receiver] = balances[receiver].add(numTokens);
  emit Transfer(msg.sender, receiver, numTokens);
  return true;
}
// ------------------------------------------------------------------------
    // Approve Delegate to Withdraw Tokens
    // ------------------------------------------------------------------------
function approve(address delegate, uint numTokens) public  override returns (bool) {
  allowed[msg.sender][delegate] = numTokens;
  emit Approval(msg.sender, delegate, numTokens);
  return true;
}
// ------------------------------------------------------------------------
    // Get Number of Tokens Approved for Withdrawal
    // ------------------------------------------------------------------------
function allowance(address owner, address delegate) public view  override returns (uint) {
  return allowed[owner][delegate];
}
// ------------------------------------------------------------------------
    // Transfer Tokens by Delegate
    // ------------------------------------------------------------------------
function transferFrom(address owner, address buyer, uint numTokens) public  override returns (bool) {
  require(numTokens <= balances[owner]);
  require(numTokens <= allowed[owner][msg.sender]);
  balances[owner] = balances[owner].sub( numTokens);
  balances[buyer] = balances[buyer].add( numTokens);
 // allowed[owner][ msg.sender] = allowed[owner][msg.sender] - numTokens;
  balances[buyer] = balances[buyer].add( numTokens);
  Transfer(owner, buyer, numTokens);
  return true;
}
}