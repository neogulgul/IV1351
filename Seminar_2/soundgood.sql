DROP DATABASE IF EXISTS soundgood;

CREATE DATABASE soundgood;

\! clear

\c soundgood

--
-- COLORS
--

\! echo -n "\033[93m"
\! echo "-- COLORS"
\! echo -n "\033[0m"

-- dark
\! echo -n "\033[30m"
\! echo -n "██"
\! echo -n "\033[31m"
\! echo -n "██"
\! echo -n "\033[32m"
\! echo -n "██"
\! echo -n "\033[33m"
\! echo -n "██"
\! echo -n "\033[34m"
\! echo -n "██"
\! echo -n "\033[35m"
\! echo -n "██"
\! echo -n "\033[36m"
\! echo -n "██"
\! echo -n "\033[37m"
\! echo -n "██"
\! echo "\033[0m"

-- bright
\! echo -n "\033[90m"
\! echo -n "██"
\! echo -n "\033[91m"
\! echo -n "██"
\! echo -n "\033[92m"
\! echo -n "██"
\! echo -n "\033[93m"
\! echo -n "██"
\! echo -n "\033[94m"
\! echo -n "██"
\! echo -n "\033[95m"
\! echo -n "██"
\! echo -n "\033[96m"
\! echo -n "██"
\! echo -n "\033[97m"
\! echo -n "██"
\! echo "\033[0m"

--
-- TABLES
--

\! echo -n "\033[93m"
\! echo "-- TABLES"
\! echo -n "\033[0m"

CREATE TYPE lesson_type as ENUM ('Individual', 'Group', 'Ensemble');
CREATE TYPE skill_level as ENUM ('Beginner', 'Intermediate', 'Advanced');

CREATE TABLE person
(
	id            SERIAL,
	person_number VARCHAR(20) NOT NULL UNIQUE,
	first_name    VARCHAR(50) NOT NULL,
	last_name     VARCHAR(50) NOT NULL,
	phone_number  VARCHAR(50) NOT NULL,
	email         VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE address
(
	person_id INT,
	city      VARCHAR(50) NOT NULL,
	street    VARCHAR(50) NOT NULL,
	zip_code  VARCHAR(10) NOT NULL,
	PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES person(id)
);

CREATE TABLE instructor
(
	person_id INT,
	PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
);

CREATE TABLE student
(
	person_id INT,
	PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
);

CREATE TABLE sibling_junction
(
	student_id INT,
	sibling_id INT,
	PRIMARY KEY (student_id, sibling_id),
	FOREIGN KEY (student_id) REFERENCES student(person_id),
	FOREIGN KEY (sibling_id) REFERENCES student(person_id)
);

CREATE TABLE contact_person
(
	student_id        INT,
	contact_person_id INT,
	PRIMARY KEY (student_id, contact_person_id),
	FOREIGN KEY (student_id)        REFERENCES student(person_id),
	FOREIGN KEY (contact_person_id) REFERENCES person(id)
);

CREATE TABLE instrument_proficiency
(
	id SERIAL,
	instrument_name VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY (id)
);

CREATE TABLE instructor_instrument_proficiency
(
	instructor_id             INT,
	instrument_proficiency_id INT,
	PRIMARY KEY (instructor_id, instrument_proficiency_id),
	FOREIGN KEY (instructor_id)             REFERENCES instructor(person_id),
	FOREIGN KEY (instrument_proficiency_id) REFERENCES instrument_proficiency(id)
);

CREATE TABLE lesson
(
	id            SERIAL,
	instructor_id INT         NOT NULL,
	lesson_type   lesson_type NOT NULL,
	skill_level   skill_level NOT NULL,
	start_time    TIMESTAMP   NOT NULL,
	end_time      TIMESTAMP   NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (instructor_id) REFERENCES instructor(person_id)
);

CREATE TABLE lesson_individual
(
	lesson_id        INT,
	instrument_focus VARCHAR(50) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id)
);

CREATE TABLE lesson_group
(
	lesson_id            INT,
	number_of_places_min INT         NOT NULL,
	number_of_places_max INT         NOT NULL,
	instrument_focus     VARCHAR(50) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id)
);

CREATE TABLE lesson_ensemble
(
	lesson_id            INT,
	number_of_places_min INT         NOT NULL,
	number_of_places_max INT         NOT NULL,
	genre                VARCHAR(50) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id)
);

CREATE TABLE lesson_payment
(
	lesson_id        INT,
	student_id       INT,
	sibling_discount DECIMAL(1, 3) NOT NULL,
	cost             DECIMAL(9, 2) NOT NULL,
	payed            BOOLEAN       NOT NULL,
	PRIMARY KEY (lesson_id, student_id),
	FOREIGN KEY (lesson_id)  REFERENCES lesson(id),
	FOREIGN KEY (student_id) REFERENCES student(person_id)
);

CREATE TABLE student_lesson_booking
(
	lesson_id  INT,
	student_id INT,
	PRIMARY KEY (lesson_id, student_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id),
	FOREIGN KEY (student_id) REFERENCES student(person_id)
);

CREATE TABLE instrument_model
(
	id SERIAL,
	model_name      VARCHAR(50) NOT NULL UNIQUE,
	instrument_name VARCHAR(50) NOT NULL,
	brand           VARCHAR(50) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE instrument
(
	id       SERIAL,
	model_id INT,
	PRIMARY KEY (id),
	FOREIGN KEY (model_id) REFERENCES instrument_model(id)
);

CREATE TABLE rental
(
	student_id    INT,
	instrument_id INT,
	start_date    DATE NOT NULL,
	due_date      DATE NOT NULL,
	PRIMARY KEY (student_id, instrument_id),
	FOREIGN KEY (student_id)    REFERENCES student(person_id),
	FOREIGN KEY (instrument_id) REFERENCES instrument(id)
);

CREATE TABLE rental_payment
(
	student_id    INT,
	instrument_id INT,
	cost          DECIMAL(9, 2) NOT NULL,
	payed         BOOLEAN       NOT NULL,
	PRIMARY KEY (student_id, instrument_id),
	FOREIGN KEY (student_id, instrument_id) REFERENCES rental(student_id, instrument_id)
);

--
-- TESTS
--

\! echo -n "\033[93m"
\! echo "-- TESTS"
\! echo -n "\033[0m"

\! echo -n "\033[92m"
\! echo "- Inserts"
\! echo -n "\033[0m"

INSERT INTO person
		(person_number, first_name, last_name, phone_number, email)
	VALUES
		('0001', 'Bert' , 'Bertson' , '0123456789', 'user@mail-client.com'),
		('0002', 'Bob'  , 'Bobson'  , '0123456789', 'user@mail-client.com'),
		('0003', 'Bodil', 'Bodilson', '0123456789', 'user@mail-client.com');

INSERT INTO student
		(person_id)
	VALUES
		(1), (3);

INSERT INTO instructor
		(person_id)
	VALUES
		(2);

INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(2, 'Individual', 'Beginner'    , '2024-12-01 13:00:00', '2024-12-01 15:00:00'),
		(2, 'Individual', 'Intermediate', '2024-12-02 13:00:00', '2024-12-02 15:00:00'),
		(2, 'Individual', 'Advanced'    , '2024-12-03 13:00:00', '2024-12-03 15:00:00'),
		(2, 'Ensemble'  , 'Intermediate', '2024-12-12 13:00:00', '2024-12-12 17:00:00');

INSERT INTO student_lesson_booking
		(lesson_id, student_id)
	VALUES
		(1, 3),
		(3, 1),
		(4, 1),
		(4, 3);

\! echo -n "\033[92m"
\! echo "- Persons"
\! echo -n "\033[0m"

SELECT * FROM person;

\! echo -n "\033[92m"
\! echo "- Students"
\! echo -n "\033[0m"

SELECT
	p.*
FROM
	person as p
	JOIN
		student as s
	ON
		s.person_id = p.id;

\! echo -n "\033[92m"
\! echo "- Instructors"
\! echo -n "\033[0m"

SELECT
	p.*
FROM
	person as p
	JOIN
		instructor as i
	ON
		i.person_id = p.id;

\! echo -n "\033[92m"
\! echo "- Lessons"
\! echo -n "\033[0m"

SELECT * FROM lesson;

\! echo -n "\033[92m"
\! echo "- Lesson Bookings"
\! echo -n "\033[0m"

SELECT
	slb.lesson_id,
	l.lesson_type,
	CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
	CONCAT(s.first_name, ' ', s.last_name) AS student_name
FROM
	student_lesson_booking slb
	JOIN
		lesson l ON slb.lesson_id = l.id
	JOIN
		person s ON slb.student_id = s.id
	JOIN
		person i ON l.instructor_id = i.id
ORDER BY
	slb.lesson_id ASC;

\c postgres
