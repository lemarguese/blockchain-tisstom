// contracts/BEP20.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Stom is ERC20 {

    constructor(uint256 initialSupply) ERC20("Tisstom", "TST") {
        price[ServiceEnum.CLEAN] = 1;
        price[ServiceEnum.REMOVE_TEETH] = 5;
        price[ServiceEnum.REPLACE_TEETH] = 10;
        price[ServiceEnum.ADD_BRACKETS] = 25;
        _mint(msg.sender, initialSupply);
    }

    mapping(ServiceEnum => uint) public price;
    mapping(address => uint[]) public visit;
    uint counter;

    enum ServiceEnum { CLEAN, REMOVE_TEETH, REPLACE_TEETH, ADD_BRACKETS }

    struct Patient {
        string name;
        string surName;
    }

    function getCount(address _who) public view returns(uint count) {
        return visit[_who].length;
    }

    ServiceEnum serviceEnum = ServiceEnum.CLEAN;

    mapping (address => Patient) public patients;

    function addPatient(string calldata _name, string calldata _surName) external {
        patients[msg.sender].name = _name;
        patients[msg.sender].surName = _surName;
    }

    function serve (string calldata _name, string calldata _surName, ServiceEnum _whatService) external  {
        this.addPatient(_name, _surName);
        visit[msg.sender].push(getCount(msg.sender) + 1);
        approve(address(this), price[_whatService]);
        _transfer(msg.sender, address(this), price[_whatService]);
    }
}