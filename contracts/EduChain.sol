// SPDX-License-Identifier: 3.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EduChain is ERC721URIStorage, Ownable {
    uint256 public courseCount = 0;
    uint256 public certificateCount = 0;

    struct Course {
        uint256 id;
        string title;
        string description;
        uint256 price;
        address instructor;
    }

    struct Enrollment {
        bool enrolled;
        bool completed;
    }

    mapping(uint256 => Course) public courses;
    mapping(uint256 => mapping(address => Enrollment)) public enrollments;
    mapping(uint256 => address) public certificates;

    event CourseCreated(uint256 indexed id, string title, uint256 price, address indexed instructor);
    event CourseEnrolled(uint256 indexed id, address indexed student);
    event CertificateIssued(uint256 indexed courseId, address indexed student, uint256 tokenId);

    // ✅ Pass `msg.sender` to Ownable and ERC721 constructor
    constructor() ERC721("EduChainCertificate", "EDU") Ownable(msg.sender) {}

    function createCourse(string memory _title, string memory _description, uint256 _price) external {
        require(bytes(_title).length > 0, "Title is required");
        require(_price > 0, "Price must be greater than zero");

        courseCount++;
        courses[courseCount] = Course(courseCount, _title, _description, _price, msg.sender);

        emit CourseCreated(courseCount, _title, _price, msg.sender);
    }

    function enrollCourse(uint256 _id) external payable {
        require(_id > 0 && _id <= courseCount, "Invalid course ID");
        Course storage course = courses[_id];
        require(msg.value == course.price, "Incorrect ETH amount");
        require(!enrollments[_id][msg.sender].enrolled, "Already enrolled");

        enrollments[_id][msg.sender] = Enrollment(true, false);
        payable(course.instructor).transfer(msg.value);

        emit CourseEnrolled(_id, msg.sender);
    }

    function issueCertificate(uint256 _courseId, string memory _tokenURI) external {
        require(_courseId > 0 && _courseId <= courseCount, "Invalid course ID");
        require(enrollments[_courseId][msg.sender].enrolled, "Not enrolled in this course");
        require(!enrollments[_courseId][msg.sender].completed, "Certificate already issued");

        certificateCount++;
        _mint(msg.sender, certificateCount);
        _setTokenURI(certificateCount, _tokenURI);
        certificates[certificateCount] = msg.sender;
        enrollments[_courseId][msg.sender].completed = true;

        emit CertificateIssued(_courseId, msg.sender, certificateCount);
    }

    function checkEnrollment(uint256 _courseId, address _student) external view returns (bool, bool) {
        return (enrollments[_courseId][_student].enrolled, enrollments[_courseId][_student].completed);
    }
}
