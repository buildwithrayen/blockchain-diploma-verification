// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DiplomaVerification {
    // 1. The Owner (University Admin)
    address public universityAdmin;

    // 2. Diploma Data Structure
    struct Diploma {
        bytes32 pdfHash;        // Unique SHA-256 fingerprint of the PDF
        string studentName;     // Student's full name
        string major;           // e.g. "Computer Science"
        string ipfsCID;         // IPFS address to view the actual PDF file
        uint256 issueDate;      // Timestamp of issuance
        bool isValid;           // True if valid, False if revoked
    }

    // 3. Database: Maps the PDF Hash -> Diploma details
    mapping(bytes32 => Diploma) public diplomas;

    // 4. Events (logged on the blockchain)
    event DiplomaIssued(bytes32 indexed pdfHash, string studentName, string ipfsCID);
    event DiplomaRevoked(bytes32 indexed pdfHash);

    // 5. Restrict access to only the university admin
    modifier onlyAdmin() {
        require(msg.sender == universityAdmin, "Only the university admin can perform this action");
        _;
    }

    // 6. Constructor: Runs once when contract is deployed
    constructor() {
        universityAdmin = msg.sender; // The deployer becomes the Admin
    }

    // FUNCTION 1: Issue a new diploma (Write to Blockchain - Costs Gas)
    function issueDiploma(
        bytes32 _pdfHash,
        string memory _studentName,
        string memory _major,
        string memory _ipfsCID
    ) public onlyAdmin {
        // Prevent registering the exact same PDF twice
        require(diplomas[_pdfHash].issueDate == 0, "Diploma already registered with this hash");

        diplomas[_pdfHash] = Diploma({
            pdfHash: _pdfHash,
            studentName: _studentName,
            major: _major,
            ipfsCID: _ipfsCID,
            issueDate: block.timestamp,
            isValid: true
        });

        emit DiplomaIssued(_pdfHash, _studentName, _ipfsCID);
    }

    // FUNCTION 2: Verify a diploma (Read-Only - 100% FREE, 0 Gas)
    function verifyDiploma(bytes32 _pdfHash) 
        public 
        view 
        returns (
            bool exists,
            string memory studentName,
            string memory major,
            string memory ipfsCID,
            uint256 issueDate,
            bool isValid
        ) 
    {
        Diploma memory d = diplomas[_pdfHash];
        
        // If issueDate is 0, it means it was never registered
        if (d.issueDate == 0) {
            return (false, "", "", "", 0, false);
        }

        return (true, d.studentName, d.major, d.ipfsCID, d.issueDate, d.isValid);
    }

    // FUNCTION 3: Revoke a diploma (In case of fraud or error)
    function revokeDiploma(bytes32 _pdfHash) public onlyAdmin {
        require(diplomas[_pdfHash].issueDate != 0, "Diploma does not exist");
        require(diplomas[_pdfHash].isValid == true, "Diploma is already revoked");

        diplomas[_pdfHash].isValid = false;

        emit DiplomaRevoked(_pdfHash);
    }
}