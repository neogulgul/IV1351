--
-- 1
--
SELECT
	TO_CHAR(start_time, 'Mon')                                AS month,
	COUNT(*)                                                  AS total,
	COUNT(*) FILTER (WHERE lesson.lesson_type = 'Individual') AS individual,
	COUNT(*) FILTER (WHERE lesson.lesson_type = 'Group')      AS group,
	COUNT(*) FILTER (WHERE lesson.lesson_type = 'Ensemble')   AS ensemble
FROM
	lesson
WHERE
	EXTRACT(YEAR FROM start_time) = 2024
GROUP BY
	EXTRACT(MONTH FROM start_time), TO_CHAR(start_time, 'Mon')
ORDER BY
	EXTRACT(MONTH FROM start_time);

--
-- 2
--
SELECT
	number_of_siblings,
	COUNT(*) AS number_of_students
FROM
(
	SELECT
		s.person_id,
		COUNT(j.student_id) AS number_of_siblings
	FROM
		student AS s
	LEFT JOIN
		sibling_junction AS j ON s.person_id = j.student_id
	GROUP BY s.person_id
) subquery
GROUP BY number_of_siblings
ORDER BY number_of_siblings;

--
-- 3
--
SELECT
	lesson.instructor_id,
	person.first_name,
	person.last_name,
	COUNT(*) AS number_of_lessons
FROM
	lesson
JOIN
	person ON lesson.instructor_id = person.id
WHERE
	DATE_TRUNC('month', start_time) = DATE_TRUNC('month', CURRENT_DATE)
GROUP BY
	lesson.instructor_id, person.first_name, person.last_name
ORDER BY
	number_of_lessons DESC;

--
-- 4
--
SELECT
	TO_CHAR(lesson.start_time, 'Dy') AS day,
	ensemble.genre,
	CASE
		WHEN (ensemble.number_of_places_max - COUNT(booking.lesson_id)) <= 0 THEN 'No seats'
		ELSE (ensemble.number_of_places_max - COUNT(booking.lesson_id))::TEXT
	END AS free_seats
FROM
	lesson
JOIN
	lesson_ensemble AS ensemble ON lesson.id = ensemble.lesson_id
LEFT JOIN
	student_lesson_booking AS booking ON booking.lesson_id = lesson.id
WHERE
	EXTRACT(WEEK FROM lesson.start_time) = EXTRACT(WEEK FROM CURRENT_DATE + INTERVAL '1 week')
GROUP BY
	lesson.start_time, ensemble.genre, ensemble.number_of_places_max
ORDER BY
	lesson.start_time, ensemble.genre;

--
-- 4 (more information about the following week just for clarity)
--
SELECT
	TO_CHAR(lesson.start_time, 'Dy') AS day,
	ensemble.*,
	COUNT(booking.lesson_id) as booked_seats,
	CASE
		WHEN (ensemble.number_of_places_max - COUNT(booking.lesson_id)) <= 0 THEN 'No seats'
		ELSE (ensemble.number_of_places_max - COUNT(booking.lesson_id))::TEXT
	END AS free_seats
FROM
	lesson
JOIN
	lesson_ensemble AS ensemble ON lesson.id = ensemble.lesson_id
LEFT JOIN
	student_lesson_booking AS booking ON booking.lesson_id = lesson.id
WHERE
	EXTRACT(WEEK FROM lesson.start_time) = EXTRACT(WEEK FROM CURRENT_DATE + INTERVAL '1 week')
GROUP BY
	lesson.start_time, ensemble.genre, ensemble.number_of_places_max, ensemble.lesson_id
ORDER BY
	lesson.start_time, ensemble.genre;
