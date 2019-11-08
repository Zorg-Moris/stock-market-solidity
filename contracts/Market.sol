pragma solidity >=0.4.21 < 0.7.0;
import "./../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./../node_modules/@openzeppelin/contracts/math/SafeMath.sol";
import "./Traiders.sol";

contract Market is Traiders, Ownable, ERC20 {

     using SafeMath for uint256;
     using SafeMath for uint32;
     using SafeMath for uint16;

     event NewShare(string name);
     event TransferShare(address _from, address _to, string _nameShare);

     struct Share {
        string name;
        string descriptionShare;
        uint priceShare;
        uint totalCountShares;
        uint availableQuantityShares;
     }

     Share[] public shares;
     mapping(string => uint) public indexShareArray;
     
     modifier getShareInfo(string memory _nameShare) {
       require(address(indexShareArray[_nameShare]) != address(0), "Market INFO: Information not found");
     _;
    }

     function createShareMarket(string memory _name, string memory _description) public {
         uint index = shares.push(Share(_name, _description, 1, 100, 0)) - 1;
         indexShareArray[_name] = index;
         emit NewShare(_name);
     }

    function getPrice(string memory _name) public view getShareInfo(_name) returns(uint) {
      uint index = indexShareArray[_name];
      return shares[index].priceShare;
     }

    function getDescriptionShare(string memory _name) public view getShareInfo(_name) returns (string memory) {
      uint index = indexShareArray[_name];
      return shares[index].descriptionShare;
     }

    function getAvailableQuantityShares(string memory _name) public view getShareInfo(_name) returns(uint) {
      uint index = indexShareArray[_name];
      return shares[index].availableQuantityShares;
     }

    function _transferShareToTraider(string memory _nameShare, uint countShare) private {
        uint index = indexShareArray[_nameShare];
        shares[index].availableQuantityShares = shares[index].availableQuantityShares.sub(countShare);
        traiderCountShare[msg.sender][_nameShare] = traiderCountShare[msg.sender][_nameShare].add(countShare);
        emit TransferShare(address (this), msg.sender,_nameShare);
    }

    function _transferShareFromTraider(string memory _nameShare, uint countShare) private {
        uint index = indexShareArray[_nameShare];
        shares[index].availableQuantityShares = shares[index].availableQuantityShares.add(countShare);
        traiderCountShare[msg.sender][_nameShare] = traiderCountShare[msg.sender][_nameShare].sub(countShare);
        emit TransferShare(msg.sender, address (this),_nameShare);
     }

     function traiderBuyShare(string memory _nameShare, uint _countShare) public payable {
        require(getAvailableQuantityShares(_nameShare)>=_countShare, "ERROR: the number of shares does not match the declared");
        require(getPrice(_nameShare).mul(_countShare) <= balanceOf(msg.sender), "ERROR: the number of shares does not match the declared");
        uint totalPrice = getPrice(_nameShare).mul(_countShare);
        transfer(address(this), totalPrice);
        _transferShareToTraider(_nameShare, _countShare);
     }

     function traiderSellShare(string memory _nameShare, uint _countShare) public payable {
        require(traiderCountShare[msg.sender][_nameShare] >= _countShare, "ERROR: the number of shares does not match the declared");
        uint totalPrice = getPrice(_nameShare).mul(_countShare);
        transfer(msg.sender, totalPrice);
        _transferShareFromTraider(_nameShare, _countShare);
     }
}