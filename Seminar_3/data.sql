\i data/person.sql

\i data/instrument_proficiency.sql

INSERT INTO instructor
	(person_id)
VALUES
	(1);

INSERT INTO instructor_instrument_proficiency
	(instructor_id, instrument_proficiency_id)
VALUES (1, 2);

SELECT insert_lesson_individual(1, 'Beginner', '2024-12-01', '15:00:00', '01:00:00', 'Piano');

SELECT insert_lesson_group(1, 'Beginner', '2024-12-01', '16:00:00', '02:00:00', 2, 10, 'Piano');

SELECT insert_lesson_ensemble(1, 'Beginner', '2024-12-02', '15:00:00', '03:00:00', 2, 10, 'Jazz');

SELECT * FROM lesson;

SELECT * FROM lesson_individual;

SELECT * FROM lesson_group;

SELECT * FROM lesson_ensemble;
