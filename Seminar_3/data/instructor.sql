INSERT INTO instrument_proficiency (instrument_name)
VALUES ('Guitar'), ('Piano'), ('Drums');

-- 1 -> Guitar
-- 2 -> Piano
-- 3 -> Drums

SELECT insert_instructor(1, ARRAY[1, 2, 3]);
