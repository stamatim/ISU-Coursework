/* 
AUTHOR: STAMATI MORELLAS 
CLASS: COM S 363
PROFESSOR: GADIA
DUE DATE: WEDNESDAY, FEB 6, 2019
*/

-- PART A: CREATE TABLES

/* Item 1

The Person table consists of the attributes Name, ID, Address, and DOB (date of birth). 
The types of these attributes are char(20), char(9), char(30), and date, respectively. 
ID will be the primary key of the table, and it cannot have a null value.
*/
create table Person (
	Name char(20),
	ID char(9) NOT NULL,
	Address char(30),
	DOB date,
    PRIMARY KEY (ID)
);

/* Item 2

The Instructor table consists of InstructorID, a 9 character non-null attribute that serves as the primary key and also references ID in the Person table. 
Other attributes are Rank and Salary. Rank can have up to 12 characters and Salary is an integer.
*/
create table Instructor (
	InstructorID char(9) NOT NULL,
    Rank char(12),
    Salary int,
    PRIMARY KEY (InstructorID),
    FOREIGN KEY (InstructorID) REFERENCES Person (ID)
);

/* Item 3

The Student table has StudentID that has same requirements as InstructorID. 
The Student table has four additional attributes: 
    Classification that is a string of up to 10 characters, 
    GPA that is a double, 
    MentorID, consisting of 9 characters, 
    references InstructorID in Instructor table, 
    and CreditHours that is an integer.
*/
create table Student (
	StudentID char(9) NOT NULL,
    Classification char(10),
    GPA double,
    MentorID char(9),
    CreditHours int,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (MentorID) REFERENCES Instructor (InstructorID)
);

/* Item 4

The Course table has a 6 character non-null attribute called CourseCode, a 50 character CourseName, and 6 character PreReq, representing prerequisite of a course. 

Note that a course can have several prerequisites. 

This is why CourseCode alone cannot be a key. 
If a course has no prerequisites, the string None is entered. 
For a given course a tuple, will exist for every prerequisite for the course.
*/
create table Course (
	CourseCode char(6) NOT NULL,
    CourseName char(50), 
    PreReq char(6), -- If a course has no prereqs, 'None' is entered in here; Note: a course can have multiple prereqs
    PRIMARY KEY (CourseCode, CourseName)
);

/* Item 5

The Offering table contains three non-null attributes CourseCode, SectionNo, and InstructorID that are of type char(6), int, and char(9). 
A CourseCode in the Offering table should appear in the Course table. 
The InstructorID references InstructorID in Instructor table. 
The primary key for this table will be formed using CourseCode and SectionNo attributes.
*/
create table Offering (
	CourseCode char(6) NOT NULL, 
    SectionNo int NOT NULL,
    InstructorID char(9) NOT NULL,
    FOREIGN KEY (InstructorID) references Instructor (InstructorID),
    PRIMARY KEY (CourseCode, SectionNo)
);

/* Item 6

The Enrollment table consists of four non-null attributes CourseCode, SectionNo, StudentID, and Grade, with types char(6), int, char(9), and char(4), respectively. 
CourseCode and SectionNo reference the Offering table. 
StudentID references the Student table. 
The primary key for this table will consist of CourseCode and StudentID attributes. 
SectionNo is not included in the primary key.
*/
create table Enrollment (
	CourseCode char(6) NOT NULL, 
	SectionNo int NOT NULL, 
	StudentID char(9) NOT NULL REFERENCES Student, 
	Grade char(4) NOT NULL, 
	PRIMARY KEY (CourseCode, StudentID), 
	FOREIGN KEY (CourseCode, SectionNo) REFERENCES Offering (CourseCode, SectionNo)
);

-- PART B: POPULATE THE TABLES

-- Item 7: Load Person data
load xml local infile '/Users/PrimaryFolder/Education/cs363/Project1/Person.xml' 
into table Person 
rows identified by '<Person>';

-- Item 8: Load Instructor data
load xml local infile '/Users/PrimaryFolder/Education/cs363/Project1/Instructor.xml' 
into table Instructor 
rows identified by '<Instructor>';

-- Item 9: Load Student data
load xml local infile '/Users/PrimaryFolder/Education/cs363/Project1/Student.xml' 
into table Student 
rows identified by '<Student>';

-- Item 10: Load Course data
load xml local infile '/Users/PrimaryFolder/Education/cs363/Project1/Course.xml' 
into table Course 
rows identified by '<Course>';

-- Item 11: Load Offering data
load xml local infile '/Users/PrimaryFolder/Education/cs363/Project1/Offering.xml' 
into table Offering 
rows identified by '<Offering>';

-- Item 12: Load Enrollment data
load xml local infile '/Users/PrimaryFolder/Education/cs363/Project1/Enrollment.xml' 
into table Enrollment 
rows identified by '<Enrollment>';

-- PART C: DEVELOP THE SQL COMMANDS

/* Item 13
List the IDs of students and the IDs of their Mentors for students who are junior or senior having a GPA above 3.8. 
*/
SELECT StudentID AND MentorID FROM Student
WHERE (Classification = 'Junior' OR Classification = 'Senior') AND GPA > 3.8;

/* Item 14
List the distinct course codes and sections for courses that are being taken by sophomore. 
*/
SELECT DISTINCT CourseCode AND SectionNo FROM Offering
INNER JOIN Enrollment ON Offering.CourseCode = Enrollment.CourseCode
INNER JOIN Student ON Enrollment.StudentID = Student.StudentID AND Student.Classification = 'Sophomore';

/* Item 15. 
List the name and salary for mentors of all freshmen. 
*/
SELECT DISTINCT Person.Name, Instructor.Salary FROM Person
INNER JOIN Instructor ON Person.ID = Instructor.InstructorID
INNER JOIN Student ON Instructor.InstructorID = Student.MentorID AND Student.Classification = 'Freshman';

/* Item 16
Find the total salary of all instructors who are not offering any course.
*/
SELECT Sum(Instructor.Salary) FROM Instructor
WHERE Instructor.InstructorID NOT IN (SELECT Offering.InstructorID FROM Offering);

/* Item 17
List all the names and DOBs of students who were born in 1976. 
The expression "Year(x.DOB) = 1976", checks if x is born in the year 1976. 
*/
SELECT Person.Name, Person.DOB FROM Person
INNER JOIN Student ON Person.ID = Student.StudentID
WHERE Year(Student.DOB) = 1976;

/* Item 18
List the names and rank of instructors who neither offer a course nor mentor a student.
*/
SELECT Person.Name, Instructor.Rank FROM Person
INNER JOIN Instructor ON Person.ID = Instructor.InstructorID
WHERE Instructor.InstructorID NOT IN (SELECT Offering.InstructorID FROM Offering)
AND Instructor.InstructorID NOT IN (SELECT Student.MentorID FROM Student);

/* Item 19
Find the IDs, names and DOB of the youngest student(s).
*/
SELECT Person.ID AND Person.Name AND Min(Person.DOB) FROM Person 
INNER JOIN Student ON Person.ID = Student.StudentID;

/* Item 20
List the IDs, DOB, and Names of Persons who are neither a student nor a instructor.
*/
SELECT Person.ID AND Person.DOB AND Person.Name FROM Person
WHERE Person.ID NOT IN (SELECT Student.ID FROM Student) 
AND Person.ID NOT IN (SELECT Instructor.InstructorID FROM Instructor);

/* Item 21
For each instructor list his / her name and the number of students he / she mentors.
*/
SELECT Person.Name, Count(Student.MentorID) FROM Instructor
INNER JOIN Person ON Instructor.InstructorID = Person.ID 
INNER JOIN Student ON Instructor.InstructorID = Student.MentorID 
GROUP BY Instructor.InstructorID;

/* Item 22
List the number of students and average GPA for each classification. 
Your query should not use constants such as "Freshman".
*/
SELECT Count(Student.StudentID) AND Avg(Student.GPA) FROM Student
GROUP BY Student.Classification ORDER BY Student.Classification;

/* Item 23
Report the course(s) with lowest enrollments. 
You should output the course code and the number of enrollments.
*/
SELECT Enrollment.CourseCode, Count(Enrollment.StudentID) FROM Enrollment
GROUP BY Enrollment.CourseCode ORDER BY Count(Enrollment.StudentID);

/* Item 24
List the IDs and Mentor IDs of students who are taking some course, offered by their mentor.
*/
SELECT Student.StudentID AND Student.MentorID FROM Student
LEFT JOIN Enrollment ON Student.StudentID = Enrollment.StudentID
LEFT JOIN Offering ON Enrollment.CourseCode = Offering.CourseCode
WHERE Offering.InstructorID = Student.MentorID 
AND Enrollment.StudentID = Student.StudentID;

/* Item 25
List the student id, name, and completed credit hours of all freshman born in or after 1976. 
*/
SELECT Student.StudentID, Person.Name, Student.CreditHours FROM Student
LEFT JOIN Person ON Student.StudentID = Person.ID
WHERE Student.Classification = 'Freshman'
AND Year(Person.DOB) >= 1976;

/* Item 26
Insert following information in the database:
    Student name: Briggs Jason;
    ID: 480293439;
    Address: 215 North Hyland Avenue; 
    Date of birth: 15th January 1975. 
He is a junior with a GPA of 3.48 and with 75 credit hours. 
His mentor is the instructor with InstructorID 201586985. 
Jason Briggs is taking two courses CS311 Section 2 and CS330 Section 1. 
He has an A on CS311 and A- on CS330
*/
INSERT INTO Person (Name, ID, Address, DOB)
VALUES ('Briggs Jason', '480293439', '215 North Hyland Avenue', '1975-01-15');

INSERT INTO Student (StudentID, Classification, GPA, MentorID, CreditHours)
VALUES ('480293439', 'Junior', '3.48', '201586985', '75');

INSERT INTO Enrollment (CourseCode, SectionNo, StudentID, Grade)
VALUES ('CS311', '2', '480293439', 'A');

INSERT INTO Enrollment (CourseCode, SectionNo, StudentID, Grade)
VALUES ('CS330', '1', '480293439', 'A-');

SELECT * FROM Person P
WHERE P.Name= 'Briggs Jason';

SELECT * FROM Student S
WHERE S.StudentID= '480293439';

SELECT * FROM Enrollment E 
WHERE E.StudentID = '480293439';

/* Item 27
Next, delete the records of students from the database who have a GPA less than 0.5. 
Note that it is not sufficient to delete these records from Student table; you have to
delete them from the Enrollment table first. (Why?) On the other hand, 
do not delete these students from the Person table.
*/
DELETE FROM Enrollment WHERE Enrollment.StudentID
IN (SELECT Student.StudentID FROM Student WHERE GPA < 0.5);

DELETE FROM Student WHERE Student.GPA < 0.5;

SELECT * FROM Student S WHERE S.GPA < 0.5;

/* Item 28
Update the instructor Ricky Ponting's salary to reflect a 10% raise provided there are at least 5 
different students enrolled in his courses with a grade of A. 

Note: He may be teaching more than one course, and a student having A grade in more than one course 
should be counted only once. To do this, the distinct option with the count function may be helpful.
Also, execute a query before and after the update to see if the salary is incremented or not.
*/
SELECT Person.Name, Instructor.Salary FROM Instructor, Person 
WHERE Instructor.InstructorID = Person.ID
AND Person.Name = 'Ricky Pointing';

UPDATE Instructor 
INNER JOIN Person ON Instructor.InstructorID = Person.ID
SET Instructor.Salary = CASE WHEN (
    SELECT Count(Student.MentorID)
    FROM Person 
    LEFT JOIN Student ON Person.ID = Student.MentorID
    WHERE (Person.Name = 'Ricky Pointing') 
    AND Student.GPA > 3.5
) >= 5 AND Person.Name = 'Ricky Pointing' THEN (Instructor.Salary * 1.10)
ELSE Instructor.Salary END;

/* Item 29 
Insert the following information into the Person table.
    Name: Trevor Horns;
    ID: 000957303; 
    Address: 23 Canberra Street; 
    Date of birth: 23rd November 1964. Then
execute a query
to verify that the record has been inserted.
*/
INSERT INTO Person (Name, ID, Address, DOB)
VALUES ('Trevor Horns', '000957303', '23 Canberra Street', '1964-11-23');

SELECT * FROM Person P WHERE P.Name = 'Trevor Horns';
SELECT * FROM Person P WHERE P.ID = '000957303';
SELECT * FROM Person P WHERE P.Address = '23 Canberra Street';
SELECT * FROM Person P WHERE P.DOB = '1964-11-23';


/* Item 30 
Delete the record for the student Jan Austin from Enrollment and Student tables. 
Her record from the Person table should not be deleted. 
*/
DELETE FROM Enrollment WHERE Enrollment.StudentID
IN (SELECT Person.ID FROM Person WHERE Person.Name = 'Jan Austin');

DELETE FROM Student WHERE Student.StudentID
IN (SELECT Person.ID FROM Person WHERE Person.Name = 'Jan Austin');

SELECT * FROM Person P WHERE P.Name = 'Jan Austin';