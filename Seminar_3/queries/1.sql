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
