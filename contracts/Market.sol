pragma solidity >=0.4.21 < 0.7.0;
import "./../node_modules/@openzeppelin/contracts/math/SafeMath.sol";
import "./../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "./../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import './Token.sol';

contract Market is Ownable, ERC20 {

     using SafeMath for uint256;
     using SafeMath for uint32;
     using SafeMath for uint16;

     event NewToken(string name);
     event TransferToken(address _from, address _to, string _nameToken);

     mapping(string => Token) public tokenMap;
     mapping(string => uint) private _availableQuantityToken;
     
     modifier getTokenInfo(string memory _nameToken) {
       require(address(tokenMap[_nameToken]) != address(0), "Market INFO: Information not found");
     _;
    }

    function createTokenMarket(string memory _name, string memory _description,uint256 _price, uint256 _totalToken) public {
        Token token = new Token(_name, _description, _price, _totalToken);
        tokenMap[_name] = token;
        emit NewToken(_name);
     }

    function getPrice(string memory _name) public view getTokenInfo(_name) returns(uint256) {
         return tokenMap[_name].tokenPrice();
     }

    function getDescriptionToken(string memory _name) public view getTokenInfo(_name) returns (string memory) {
      return tokenMap[_name].description();
     }

    function getAvailableQuantityToken(string memory _name) public view getTokenInfo(_name) returns(uint256) {
      return _availableQuantityToken[_name];
     }

      function addAvailableQuantityToken(string memory _name, uint _countToken) internal {
       _availableQuantityToken[_name] = _availableQuantityToken[_name].add(_countToken);
     }

      function subAvailableQuantityToken(string memory _name, uint _countToken) internal {
       _availableQuantityToken[_name] = _availableQuantityToken[_name].sub(_countToken);
     }

     function traiderBuyToken(string memory _nameToken, uint256 _countToken) public payable {
        require(getAvailableQuantityToken(_nameToken)>=_countToken, "ERROR: the number of Token does not match the declared");
        require(getPrice(_nameToken).mul(_countToken) <= balanceOf(msg.sender), "ERROR: the number of Token does not match the declared");
      //   require(transferFrom(address(this), msg.sender, _countToken), "Market: transaction error");
        require(tokenMap[_nameToken].transfer(msg.sender, _countToken),"Market: transaction error");
        uint totalPrice = getPrice(_nameToken).mul(_countToken);
      //   require(transfer(address(this), totalPrice),"Market: transaction error");
        msg.sender.transfer(totalPrice);
        subAvailableQuantityToken(_nameToken, _countToken);
     }

     function traiderSellToken(string memory _nameToken, uint _countToken) public payable {
        require(balanceOf(msg.sender) >= _countToken, "ERROR: the number of sharesToken does not match the declared");
        uint totalPrice = getPrice(_nameToken).mul(_countToken);
        require(tokenMap[_nameToken].transferFrom(msg.sender, address(this), _countToken), "Market: transaction error");
       //   require(transferFrom(msg.sender, address(this), _countToken), "Market: transaction error");
       addAvailableQuantityToken(_nameToken, _countToken);
        transfer(msg.sender, totalPrice);
     }
}