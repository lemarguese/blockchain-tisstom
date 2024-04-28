// contracts/BEP20.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Structures.sol";

contract Stom is ERC20 {
    constructor() ERC20("Tisstom", "TST") {
        price[ServiceEnum.CLEAN] = 1 ether;
        price[ServiceEnum.REMOVE_TEETH] = 5 ether;
        price[ServiceEnum.REPLACE_TEETH] = 10 ether;
        price[ServiceEnum.ADD_BRACKETS] = 25 ether;
        _mint(msg.sender, 1000 ether);
    }

    mapping(address => Patient) public patients;
    mapping(address => Doctor) public doctors;
    mapping(ServiceEnum => uint) public price;
    Raw[] public visit;

    event PatientVisit(
        address _patient,
        address _doctor,
        ServiceEnum _service,
        uint256 _when
    );
    event PatientAdded(string _name, string _surName);
    event DoctorAdded(string _name, string _surName, uint _exp);

    function addPatient(
        string calldata _name,
        string calldata _surName,
        bool _servedBefore
    ) public {
        patients[msg.sender].name = _name;
        patients[msg.sender].surName = _surName;
        patients[msg.sender].servedBefore = _servedBefore;

        emit PatientAdded(_name, _surName);
    }

    function getDoctor(
        address _docAddress
    ) public view returns (Doctor memory doctor) {
        return doctors[_docAddress];
    }

    function addDoctor(
        address _docAddress,
        string calldata _name,
        string calldata _surName,
        uint _experience
    ) public {
        doctors[_docAddress].name = _name;
        doctors[_docAddress].surName = _surName;
        doctors[_docAddress].experience = _experience;

        emit DoctorAdded(_name, _surName, _experience);
    }

    function serve(
        string calldata _name,
        string calldata _surName,
        ServiceEnum _whatService,
        address doctorAddress
    ) external {
        if (!patients[msg.sender].servedBefore) {
            this.addPatient(_name, _surName, true);
        }

        visit.push(
            Raw(
                patients[msg.sender],
                block.timestamp,
                price[_whatService],
                _whatService,
                doctors[doctorAddress]
            )
        );
        approve(address(this), price[_whatService]);
        _transfer(msg.sender, address(this), price[_whatService]);

        emit PatientVisit(
            msg.sender,
            doctorAddress,
            _whatService,
            block.timestamp
        );
    }

    function getInformationAboutPatient(
        address _patient
    ) public view returns (Patient memory patient) {
        return patients[_patient];
    }
}
