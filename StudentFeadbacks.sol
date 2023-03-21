// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract StudentFeadbacks{
    address public owner; 
    constructor() {
        owner = msg.sender; 
    }
    struct Feedback{
        string courseCode; 
        string rating;
        string comment; 
    }
    struct Faculty{
        address _to;
        string courseCode; 
        string rating;
        string comment;
    }
    struct TakenCourse{
        address facultyAddress; 
        string courseCode;
        string courseTitle;
        bool assign;
    }
    struct Course{
        address to; 
        string courseCode;
        string courseTitle;
    }
    mapping(string => TakenCourse) takenCourses; 
    mapping(address => Feedback[]) studentFeedbacks;
    mapping(address=> mapping(string=>bool)) feedbackTrack; 
    mapping(address => bool) existfaculty;  
    Course[] allCourses;
    Faculty[] private feedbacks; 

    modifier onlyOwner(){
        require(msg.sender==owner, "You are not allowed"); 
        _;
    }
    
    function assignCourse(address _to, string memory _courseCode, string memory _courseTitle) public onlyOwner {
        require( takenCourses[_courseCode].assign==false, "Already Assigned");
        takenCourses[_courseCode] = TakenCourse(_to, _courseCode, _courseTitle, true); 
        allCourses.push(Course(_to, _courseCode, _courseTitle));
    }

    function submitFeadback(address _to, string memory _courseCode, string memory _rating, string memory _comment) public{
        require( msg.sender!=_to ); 
        require(takenCourses[_courseCode].facultyAddress==_to, "Address does not match with faculty account");
        require(!feedbackTrack[msg.sender][_courseCode], "Your feedback already exist"); 
        studentFeedbacks[_to].push(Feedback({
            courseCode: _courseCode,
            rating: _rating, 
            comment: _comment
        }));
        feedbackTrack[msg.sender][_courseCode] = true; 
        feedbacks.push(Faculty(_to, _courseCode, _rating, _comment)); 
    }

    function getFeedbackByAddress() public view returns(Feedback[] memory){
        return studentFeedbacks[msg.sender]; 
    }

    function getAllFeedbacks() public view onlyOwner returns(Faculty[] memory){
        return feedbacks;
    }

    function getAllCourses() public view onlyOwner returns(Course[] memory){
        return allCourses;
    }
}