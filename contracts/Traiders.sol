pragma solidity >=0.4.21 < 0.7.0;

contract Traiders {
    mapping (address => mapping(string => uint)) public traiderCountToken;
    function createTokenMarket(string memory _name, string memory _description) public;
    function getPrice(string memory _name) public view returns(uint);
    function getDescriptionToken(string memory _name) public view returns (string memory);
    function getAvailableQuantityToken(string memory _name) public view returns(uint);
    function traiderBuyToken(string memory _nameToken, uint _countToken) public payable;
    function traiderSellToken(string memory _nameToken, uint _countToken) public payable;
}