struct Patient {
    string name;
    string surName;
}

enum ServiceEnum { CLEAN, REMOVE_TEETH, REPLACE_TEETH, ADD_BRACKETS }

struct Doctor {
    // workFrom, workTo -> timestamp
    string name;
    string surName;
    uint experience;
}

struct Raw {
    // Raw data for serve data
    Patient createdBy;
    uint256 createdAt;
    uint price;
    ServiceEnum service;
    Doctor doctor;
}