
# School Database Design

## Introduction

This database is designed to manage students, courses and student enrolments in a school.

It uses SQLite and contains three main tables: students, courses and enrolments.

## 1. Students Table

The students table stores information about students in the school.

It contains:
- student_id: The primary key that uniquely identifies each student.
- name: The student's full name.
- email: The student's email address, which must be unique.

Each student has a unique student ID and email address.

## 2. Courses Table

The courses table stores information about courses offered by the school.

It contains:
- course_id: The primary key that uniquely identifies each course.
- course_name: The name of the course.
- course_code: A unique code assigned to each course.

Each course has a unique course ID and course code.

## 3. Enrolments Table

The enrolments table connects students and courses.

It contains:
- student_id: A foreign key referencing the students table.
- course_id: A foreign key referencing the courses table.
- grade: Stores the grade a student receives in a course.

The combination of student_id and course_id forms a composite primary key.

This prevents the same student from enrolling in the same course more than once.

## 4. Relationships Between Tables

### One-to-Many Relationship

There is a one-to-many relationship between students and enrolments.

One student can have many enrolment records, but each enrolment belongs to one student.

There is also a one-to-many relationship between courses and enrolments.

One course can have many enrolment records, but each enrolment belongs to one course.

### Many-to-Many Relationship

Students and courses have a many-to-many relationship.

One student can enrol in many courses, and one course can have many students.

A join table called enrolments is needed to manage this relationship.

The enrolments table stores the student ID and course ID together with the student's grade.

Without this join table, managing the many-to-many relationship would be difficult and could cause data duplication.

## 5. Database Index

I would add an index on the course_id column in the enrolments table.

Example:

```sql
CREATE INDEX idx_enrolments_course_id
ON enrolments(course_id);
```

This index makes it faster to find all students enrolled in a particular course.

It also improves queries that search or filter enrolments using course_id.

## 6. SQL or NoSQL?

I would choose SQL for this school database.

SQL is suitable because the system contains structured data and clear relationships between students, courses and enrolments.

SQL supports primary keys, foreign keys and constraints that help maintain data accuracy and consistency.

It also supports JOIN operations, which make it easier to retrieve information from multiple related tables.

A relational database such as SQLite is therefore a good choice for this school management system.

## Conclusion

The school database uses three related tables to manage students, courses and enrolments.

Primary keys, foreign keys, unique constraints and a composite primary key help maintain data integrity.

The design makes it easy to manage enrolments, retrieve student records and track grades.
