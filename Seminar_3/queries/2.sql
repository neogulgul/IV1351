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
