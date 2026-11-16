
-- DAY 6 ASSIGNMENT: A SCHOOL DATABASE

-- Enable foreign key enforcement in SQLite
PRAGMA foreign_keys = ON;

-- 1. CREATE TABLES

-- Students table
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- Courses table
CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_name TEXT NOT NULL,
    course_code TEXT NOT NULL UNIQUE
);

-- Enrolments table (join table)
CREATE TABLE enrolments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade TEXT,

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

-- 2. INSERT SAMPLE STUDENTS

INSERT INTO students (name, email) VALUES
('John Kamau', 'john@gmail.com'),
('Mary Wanjiku', 'mary@gmail.com'),
('Peter Otieno', 'peter@gmail.com'),
('Grace Achieng', 'grace@gmail.com');

-- 3. INSERT SAMPLE COURSES

INSERT INTO courses (course_name, course_code) VALUES
('Database Systems', 'DB101'),
('Web Development', 'WD102'),
('Computer Networking', 'CN103');

-- 4. INSERT SAMPLE ENROLMENTS

INSERT INTO enrolments (student_id, course_id, grade) VALUES
(1, 1, 'A'),
(1, 2, 'B'),
(2, 1, 'A'),
(2, 3, 'B'),
(3, 2, 'A');

-- 5. QUERY: ALL COURSES FOR ONE STUDENT (BY NAME)

SELECT
    students.name AS student_name,
    courses.course_name,
    enrolments.grade
FROM enrolments
JOIN students
    ON enrolments.student_id = students.student_id
JOIN courses
    ON enrolments.course_id = courses.course_id
WHERE students.name = 'John Kamau';

-- 6. QUERY: ALL STUDENTS ON ONE COURSE

SELECT
    students.name AS student_name,
    courses.course_name
FROM enrolments
JOIN students
    ON enrolments.student_id = students.student_id
JOIN courses
    ON enrolments.course_id = courses.course_id
WHERE courses.course_name = 'Database Systems';

-- 7. QUERY: NUMBER OF STUDENTS PER COURSE

SELECT
    courses.course_name,
    COUNT(enrolments.student_id) AS number_of_students
FROM courses
LEFT JOIN enrolments
    ON courses.course_id = enrolments.course_id
GROUP BY courses.course_id, courses.course_name;

-- 8. QUERY: STUDENTS WHO HAVE NO ENROLMENTS

SELECT
    students.student_id,
    students.name,
    students.email
FROM students
LEFT JOIN enrolments
    ON students.student_id = enrolments.student_id
WHERE enrolments.student_id IS NULL;

-- 9. UPDATE ONE ENROLMENT'S GRADE

UPDATE enrolments
SET grade = 'A'
WHERE student_id = 1
AND course_id = 2;

-- 10. VERIFY THE UPDATED GRADE

SELECT
    students.name,
    courses.course_name,
    enrolments.grade
FROM enrolments
JOIN students
    ON enrolments.student_id = students.student_id
JOIN courses
    ON enrolments.course_id = courses.course_id
WHERE students.student_id = 1
AND courses.course_id = 2;
