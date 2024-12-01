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
