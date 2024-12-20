SELECT * FROM person;

SELECT
	p.*
FROM
	person as p
	JOIN
		student as s
	ON
		s.person_id = p.id;

SELECT
	p.*
FROM
	person as p
	JOIN
		instructor as i
	ON
		i.person_id = p.id;

SELECT * FROM lesson;

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
