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
