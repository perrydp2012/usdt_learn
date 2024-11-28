// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MyToken {
    string public name = "Tether";
    string public symbol = "USDT";
    uint8 public constant decimals = 6;
    uint256 public totalSupply;

    mapping(address => uint256) private balances;

    mapping(address => mapping(address => uint256)) private allowances;
    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }
    function transfer(address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Transfer to zero address");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Approve to zero address");

        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(to != address(0), "Transfer to zero address");
        require(balances[from] >= amount, "Insufficient balance");
        require(allowances[from][msg.sender] >= amount, "Allowance exceeded");

        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }
    function allowance(address ownerAddress, address spender) public view returns (uint256) {
        return allowances[ownerAddress][spender];
    }
    function mint(address to, uint256 amount) public onlyOwner {
        require(to != address(0), "Mint to zero address");

        uint256 adjustedAmount = amount * 10 ** decimals;
        totalSupply += adjustedAmount;
        balances[to] += adjustedAmount;

        emit Transfer(address(0), to, adjustedAmount);
    }
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");

        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
