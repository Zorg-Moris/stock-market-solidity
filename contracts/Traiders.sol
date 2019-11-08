pragma solidity >=0.4.21 < 0.7.0;

contract Traiders {
    mapping (address => mapping(string => uint)) public traiderCountShare;
    function createShareMarket(string memory _name, string memory _description) public;
    function getPrice(string memory _name) public view returns(uint);
    function getDescriptionShare(string memory _name) public view returns (string memory);
    function getAvailableQuantityShares(string memory _name) public view returns(uint);
    function traiderBuyShare(string memory _nameShare, uint _countShare) public payable;
    function traiderSellShare(string memory _nameShare, uint _countShare) public payable;
}