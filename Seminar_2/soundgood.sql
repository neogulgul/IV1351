DROP DATABASE IF EXISTS soundgood;

CREATE DATABASE soundgood;

\! clear

\c soundgood

-- TABLES

CREATE TABLE persons(
	id            SERIAL,
	person_number VARCHAR(64) NOT NULL UNIQUE,
	first_name    VARCHAR(64) NOT NULL,
	last_name     VARCHAR(64) NOT NULL,
	phone_number  VARCHAR(64) NOT NULL,
	email         VARCHAR(64) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE addresses(
	person_id INT,
	city      VARCHAR(64) NOT NULL,
	zip_code  VARCHAR(64) NOT NULL,
	street    VARCHAR(64) NOT NULL,
	PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES persons(id)
);

CREATE TABLE instructors(
	person_id INT,
	PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE
);

CREATE TABLE students(
	person_id INT,
	PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE
);

CREATE TABLE sibling_junctions(
	student_id INT,
	sibling_id INT,
	PRIMARY KEY (student_id, sibling_id),
	FOREIGN KEY (student_id) REFERENCES students(person_id),
	FOREIGN KEY (sibling_id) REFERENCES students(person_id)
);

CREATE TABLE contact_persons(
	student_id        INT,
	contact_person_id INT,
	PRIMARY KEY (student_id, contact_person_id),
	FOREIGN KEY (student_id)        REFERENCES students(person_id),
	FOREIGN KEY (contact_person_id) REFERENCES persons(id)
);

CREATE TABLE instrument_proficiencies(
	id SERIAL,
	instrument_name VARCHAR(64) NOT NULL UNIQUE,
	PRIMARY KEY (id)
);

CREATE TABLE instructors_instrument_proficiencies(
	instructor_id             INT,
	instrument_proficiency_id INT,
	PRIMARY KEY (instructor_id, instrument_proficiency_id),
	FOREIGN KEY (instructor_id)             REFERENCES instructors(person_id),
	FOREIGN KEY (instrument_proficiency_id) REFERENCES instrument_proficiencies(id)
);

CREATE TYPE lesson_type as ENUM ('Individual', 'Group', 'Ensemble');
CREATE TYPE skill_level as ENUM ('Beginner', 'Intermediate', 'Advanced');

CREATE TABLE lessons(
	id            SERIAL,
	instructor_id INT         NOT NULL,
	lesson_type   lesson_type NOT NULL,
	skill_level   skill_level NOT NULL,
	start_time    TIMESTAMP   NOT NULL,
	end_time      TIMESTAMP   NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (instructor_id) REFERENCES instructors(person_id)
);

CREATE TABLE lessons_individual(
	lesson_id        INT,
	instrument_focus VARCHAR(64) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

CREATE TABLE lessons_group(
	lesson_id            INT,
	number_of_places_min INT         NOT NULL,
	number_of_places_max INT         NOT NULL,
	instrument_focus     VARCHAR(64) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

CREATE TABLE lessons_ensemble(
	lesson_id            INT,
	number_of_places_min INT         NOT NULL,
	number_of_places_max INT         NOT NULL,
	genre                VARCHAR(64) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id)
);

CREATE TABLE lesson_payment(
	lesson_id        INT,
	student_id       INT,
	sibling_discount DECIMAL(1, 3) NOT NULL,
	cost             DECIMAL(9, 2) NOT NULL,
	PRIMARY KEY (lesson_id, student_id),
	FOREIGN KEY (lesson_id)  REFERENCES lessons(id),
	FOREIGN KEY (student_id) REFERENCES students(person_id)
);

CREATE TABLE student_lesson_bookings(
	lesson_id  INT,
	student_id INT,
	PRIMARY KEY (lesson_id, student_id),
	FOREIGN KEY (lesson_id) REFERENCES lessons(id),
	FOREIGN KEY (student_id) REFERENCES students(person_id)
);

CREATE TABLE instrument_models(
	id SERIAL,
	model_name      VARCHAR(64) NOT NULL UNIQUE,
	instrument_name VARCHAR(64) NOT NULL,
	brand           VARCHAR(64) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE instruments(
	id       SERIAL,
	model_id INT,
	PRIMARY KEY (id),
	FOREIGN KEY (model_id) REFERENCES instrument_models(id)
);

CREATE TABLE rental(
	student_id    INT,
	instrument_id INT,
	start_date    DATE NOT NULL,
	due_date      DATE NOT NULL,
	PRIMARY KEY (student_id, instrument_id),
	FOREIGN KEY (student_id)    REFERENCES students(person_id),
	FOREIGN KEY (instrument_id) REFERENCES instruments(id)
);

CREATE TABLE rental_payment(
	student_id    INT,
	instrument_id INT,
	cost          DECIMAL(9, 2) NOT NULL,
	PRIMARY KEY (student_id, instrument_id),
	FOREIGN KEY (student_id, instrument_id) REFERENCES rental(student_id, instrument_id)
);

-- test
INSERT INTO persons
		(person_number, first_name, last_name, phone_number, email)
	VALUES
		('0000', 'neo', '', '0123456789', 'user@mail-client.com'),
		('0001', 'bob', '', '0123456789', 'user@mail-client.com');

INSERT INTO students
		(person_id)
	VALUES
		(1);

INSERT INTO instructors
		(person_id)
	VALUES
		(2);

INSERT INTO lessons
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(2, 'Individual', 'Beginner', '2024-12-01 13:00:00', '2024-12-01 15:00:00'),
		(2, 'Individual', 'Beginner', '2024-12-02 13:00:00', '2024-12-02 15:00:00'),
		(2, 'Individual', 'Beginner', '2024-12-03 13:00:00', '2024-12-03 15:00:00');

INSERT INTO student_lesson_bookings
		(lesson_id, student_id)
	VALUES
		(1, 1),
		(3, 1);

\! echo -n "\033[32m"
\! echo "Persons"
\! echo -n "\033[0m"

SELECT * FROM persons;

\! echo -n "\033[32m"
\! echo "Students"
\! echo -n "\033[0m"

SELECT
	*
FROM
	persons as p
	INNER JOIN
	students as s
ON
	s.person_id = p.id;

\! echo -n "\033[32m"
\! echo "Instructors"
\! echo -n "\033[0m"

SELECT
	*
FROM
	persons as p
	INNER JOIN
	instructors as i
ON
	i.person_id = p.id;

\! echo -n "\033[32m"
\! echo "Lessons"
\! echo -n "\033[0m"

SELECT * FROM lessons;

\! echo -n "\033[32m"
\! echo "Lesson Bookings"
\! echo -n "\033[0m"

SELECT
	b.lesson_id,
	p.first_name as student_name
FROM
	persons as p
	INNER JOIN
	student_lesson_bookings as b
ON
	p.id = b.student_id;

\c postgres
