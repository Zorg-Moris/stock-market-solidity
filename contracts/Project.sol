pragma solidity >=0.4.21 < 0.7.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Project is ERC20 {
    string public tokenName;
    string public description;
    uint256 public tokenPrice;
    uint public totalCountToken;

    constructor(string memory _name, string memory _description, uint256 _price,uint _totalToken)
      public {
        tokenName = _name;
        description = _description;
        tokenPrice = _price;
        _mint(address(msg.sender),_totalToken);
    }
}