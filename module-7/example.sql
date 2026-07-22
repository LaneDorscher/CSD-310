DROP DATABASE IF EXISTS school_demo;
CREATE DATABASE school_demo;
USE school_demo;

-- ==========================
-- Create Tables
-- ==========================

CREATE TABLE student (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50)
);

CREATE TABLE instructor (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50)
);

CREATE TABLE course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_id INT,
    FOREIGN KEY (instructor_id)
        REFERENCES instructor(instructor_id)
);

CREATE TABLE enrollment (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id)
        REFERENCES student(student_id),
    FOREIGN KEY (course_id)
        REFERENCES course(course_id)
);

-- ==========================
-- Sample Data
-- ==========================

INSERT INTO student VALUES
(1,'Alice'),
(2,'Bob'),
(3,'Charlie');

INSERT INTO instructor VALUES
(1,'Smith'),
(2,'Johnson');

INSERT INTO course VALUES
(101,'Database Systems',1),
(102,'Programming I',2),
(103,'Networking',1);

INSERT INTO enrollment VALUES
(1,101),
(1,102),
(2,101),
(3,103);