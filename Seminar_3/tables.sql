CREATE TYPE lesson_type AS ENUM ('Individual', 'Group', 'Ensemble');
CREATE TYPE skill_level AS ENUM ('Beginner', 'Intermediate', 'Advanced');

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
	FOREIGN KEY (person_id) REFERENCES person(id) ON DELETE CASCADE
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
	FOREIGN KEY (student_id) REFERENCES student(person_id) ON DELETE CASCADE,
	FOREIGN KEY (sibling_id) REFERENCES student(person_id) ON DELETE CASCADE,
	CONSTRAINT avoid_self_reference CHECK (student_id <> sibling_id)
);

CREATE TABLE contact_person
(
	student_id        INT,
	contact_person_id INT,
	PRIMARY KEY (student_id, contact_person_id),
	FOREIGN KEY (student_id)        REFERENCES student(person_id) ON DELETE CASCADE,
	FOREIGN KEY (contact_person_id) REFERENCES person(id)         ON DELETE CASCADE
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
	FOREIGN KEY (instructor_id)             REFERENCES instructor(person_id)      ON DELETE CASCADE,
	FOREIGN KEY (instrument_proficiency_id) REFERENCES instrument_proficiency(id) ON DELETE CASCADE
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
	FOREIGN KEY (instructor_id) REFERENCES instructor(person_id) ON DELETE CASCADE
);

CREATE TABLE lesson_individual
(
	lesson_id        INT,
	instrument_focus VARCHAR(50) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id) ON DELETE CASCADE
);

CREATE TABLE lesson_group
(
	lesson_id            INT,
	number_of_places_min INT         NOT NULL,
	number_of_places_max INT         NOT NULL,
	instrument_focus     VARCHAR(50) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id) ON DELETE CASCADE
);

CREATE TABLE lesson_ensemble
(
	lesson_id            INT,
	number_of_places_min INT         NOT NULL,
	number_of_places_max INT         NOT NULL,
	genre                VARCHAR(50) NOT NULL,
	PRIMARY KEY (lesson_id),
	FOREIGN KEY (lesson_id) REFERENCES lesson(id) ON DELETE CASCADE
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
	FOREIGN KEY (lesson_id)  REFERENCES lesson(id)          ON DELETE CASCADE,
	FOREIGN KEY (student_id) REFERENCES student(person_id) ON DELETE CASCADE
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
	FOREIGN KEY (model_id) REFERENCES instrument_model(id) ON DELETE CASCADE
);

CREATE TABLE rental
(
	student_id    INT,
	instrument_id INT,
	start_date    DATE NOT NULL,
	due_date      DATE NOT NULL,
	PRIMARY KEY (student_id, instrument_id),
	FOREIGN KEY (student_id)    REFERENCES student(person_id) ON DELETE CASCADE,
	FOREIGN KEY (instrument_id) REFERENCES instrument(id)     ON DELETE CASCADE
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
