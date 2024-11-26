INSERT INTO instrument_proficiency (instrument_name)
VALUES ('Guitar'), ('Piano'), ('Drums');

-- 1 -> Guitar
-- 2 -> Piano
-- 3 -> Drums

DO
$$
BEGIN
	PERFORM insert_instructor(1, ARRAY[1, 2, 3]);
	PERFORM insert_instructor(2, ARRAY[1]);
	PERFORM insert_instructor(3, ARRAY[2]);
	PERFORM insert_instructor(4, ARRAY[3]);
END;
$$
LANGUAGE plpgsql;
