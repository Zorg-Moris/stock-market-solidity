pragma solidity >=0.4.21 < 0.7.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import './Project.sol';

contract Market is ERC20 {
     using SafeMath for uint256;
     using SafeMath for uint32;
     using SafeMath for uint16;

     event NewProject(string name);
     event TransferProject(
          address _from,
          address _to,
          string _nameProject
      );

     mapping(string => Project) public projectMap;
     mapping(string => uint) private _availableQuantityProject;
     
     modifier checkTokenMarket(string memory _nameProject) {
       require(address(projectMap[_nameProject]) != address(0), "Market INFO: Information not found");
       _;
    }

    function createTokenMarket(
        string memory _name,
        string memory _description,
        uint256 _price,
        uint256 _totalProject
    )
      public
    {
        Project project = new Project(_name, _description, _price, _totalProject);
        projectMap[_name] = project;
        emit NewProject(_name);
    }

    function getPrice(string memory _name) public view checkTokenMarket(_name) returns(uint256) {
        return projectMap[_name].tokenPrice();
    }

    function getDescriptionProject(string memory _name) public view checkTokenMarket(_name) returns (string memory) {
        return projectMap[_name].description();
    }

    function getAvailableQuantityProject(string memory _name) public view checkTokenMarket(_name) returns(uint256) {
        return _availableQuantityProject[_name];
    }

    function traiderBuyToken(string memory _nameToken, uint256 _countToken) public payable {
        require(getAvailableQuantityProject(_nameToken)>=_countToken, "ERROR: the number of Token does not match the declared");
        require(getPrice(_nameToken).mul(_countToken) <= balanceOf(msg.sender), "ERROR: the number of Token does not match the declared");
        require(projectMap[_nameToken].transfer(msg.sender, _countToken),"Market: transaction error");
        uint totalPrice = getPrice(_nameToken).mul(_countToken);
        msg.sender.transfer(totalPrice);
        subAvailableQuantityProject(_nameToken, _countToken);
    }

    function traiderSellToken(string memory _nameToken, uint _countToken) public payable {
        require(balanceOf(msg.sender) >= _countToken, "ERROR: the number of sharesToken does not match the declared");
        uint totalPrice = getPrice(_nameToken).mul(_countToken);
        require(projectMap[_nameToken].transferFrom(msg.sender, address(this), _countToken), "Market: transaction error");
        addAvailableQuantityProject(_nameToken, _countToken);
        transfer(msg.sender, totalPrice);
    }

    function addAvailableQuantityProject(string memory _name, uint _countToken) internal {
        _availableQuantityProject[_name] = _availableQuantityProject[_name].add(_countToken);
    }

    function subAvailableQuantityProject(string memory _name, uint _countToken) internal {
        _availableQuantityProject[_name] = _availableQuantityProject[_name].sub(_countToken);
    }
}