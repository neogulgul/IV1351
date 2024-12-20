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
