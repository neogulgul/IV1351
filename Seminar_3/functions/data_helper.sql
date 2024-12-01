--
-- Create individual lessons more easily
--
CREATE FUNCTION insert_lesson_individual
(
	p_instructor_id    INT,
	p_skill_level      skill_level,
	p_start_date       DATE,
	p_start_time       TIME,
	p_duration         INTERVAL,

	p_instrument_focus VARCHAR(50)
)
RETURNS INT AS
$$
DECLARE
	v_start_timestamp TIMESTAMP;
	v_end_timestamp   TIMESTAMP;
	v_new_lesson_id   INT;
BEGIN
	-- Creating timestamps
	v_start_timestamp := p_start_date + p_start_time;
	v_end_timestamp   := v_start_timestamp + p_duration;

	INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(p_instructor_id, 'Individual', p_skill_level, v_start_timestamp, v_end_timestamp)
	RETURNING
		id INTO v_new_lesson_id;

	INSERT INTO lesson_individual
		(lesson_id, instrument_focus)
	VALUES
		(v_new_lesson_id, p_instrument_focus);

	RETURN v_new_lesson_id;
END;
$$
LANGUAGE plpgsql;

--
-- Create group lessons more easily
--
CREATE FUNCTION insert_lesson_group
(
	p_instructor_id        INT,
	p_skill_level          skill_level,
	p_start_date           DATE,
	p_start_time           TIME,
	p_duration             INTERVAL,

	p_number_of_places_min INT,
	p_number_of_places_max INT,
	p_instrument_focus     VARCHAR(50)
)
RETURNS INT AS
$$
DECLARE
	v_start_timestamp TIMESTAMP;
	v_end_timestamp   TIMESTAMP;
	v_new_lesson_id   INT;
BEGIN
	-- Creating timestamps
	v_start_timestamp := p_start_date + p_start_time;
	v_end_timestamp   := v_start_timestamp + p_duration;

	INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(p_instructor_id, 'Group', p_skill_level, v_start_timestamp, v_end_timestamp)
	RETURNING
		id INTO v_new_lesson_id;

	INSERT INTO lesson_group
		(lesson_id, number_of_places_min, number_of_places_max, instrument_focus)
	VALUES
		(v_new_lesson_id, p_number_of_places_min, p_number_of_places_max, p_instrument_focus);

	RETURN v_new_lesson_id;
END;
$$
LANGUAGE plpgsql;

--
-- Create ensemble lessons more easily
--
CREATE FUNCTION insert_lesson_ensemble
(
	p_instructor_id        INT,
	p_skill_level          skill_level,
	p_start_date           DATE,
	p_start_time           TIME,
	p_duration             INTERVAL,

	p_number_of_places_min INT,
	p_number_of_places_max INT,
	p_genre                VARCHAR(50)
)
RETURNS INT AS
$$
DECLARE
	v_start_timestamp TIMESTAMP;
	v_end_timestamp   TIMESTAMP;
	v_new_lesson_id   INT;
BEGIN
	-- Creating timestamps
	v_start_timestamp := p_start_date + p_start_time;
	v_end_timestamp   := v_start_timestamp + p_duration;

	INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(p_instructor_id, 'Ensemble', p_skill_level, v_start_timestamp, v_end_timestamp)
	RETURNING
		id INTO v_new_lesson_id;

	INSERT INTO lesson_ensemble
		(lesson_id, number_of_places_min, number_of_places_max, genre)
	VALUES
		(v_new_lesson_id, p_number_of_places_min, p_number_of_places_max, p_genre);

	RETURN v_new_lesson_id;
END;
$$
LANGUAGE plpgsql;

--
-- Create instructors more easily
--
CREATE FUNCTION insert_instructor
(
	p_person_id                  INT,
	p_instrument_proficiency_ids INT[]
)
RETURNS VOID AS
$$
DECLARE
	v_instrument_proficiency_id INT;
BEGIN
	-- Check if the person exists in the person table
	IF NOT EXISTS (SELECT 1 FROM person WHERE id = p_person_id) THEN
		RAISE EXCEPTION 'Person with ID % does not exist', p_person_id;
	END IF;

	-- Insert the person as an instructor
	INSERT INTO instructor (person_id)
	VALUES (p_person_id)
	ON CONFLICT (person_id) DO NOTHING;

	-- For each instrument proficiency in the provided array, insert the association
	FOREACH v_instrument_proficiency_id IN ARRAY p_instrument_proficiency_ids
	LOOP
		-- Check if the instrument proficiency exists in the instrument_proficiency table
		IF NOT EXISTS (SELECT 1 FROM instrument_proficiency WHERE id = v_instrument_proficiency_id) THEN
			RAISE EXCEPTION 'Instrument proficiency with ID % does not exist', v_instrument_proficiency_id;
		END IF;

		-- Insert the instrument proficiency association
		INSERT INTO instructor_instrument_proficiency (instructor_id, instrument_proficiency_id)
		VALUES (p_person_id, v_instrument_proficiency_id)
		ON CONFLICT (instructor_id, instrument_proficiency_id) DO NOTHING;
	END LOOP;

END;
$$ LANGUAGE plpgsql;

--
-- Create relations between two siblings more easily
--
CREATE FUNCTION add_sibling_relation
(
	p_student_id_a INT,
	p_student_id_b INT
)
RETURNS VOID AS
$$
BEGIN
	IF p_student_id_a = p_student_id_b THEN
		RAISE EXCEPTION 'Student A and B can not be the same!';
	END IF;

	IF NOT EXISTS (SELECT 1 FROM student WHERE person_id = p_student_id_a) THEN
		RAISE EXCEPTION 'Student A where person_id = % does not exist.', p_student_id_a;
	END IF;

	IF NOT EXISTS (SELECT 1 FROM student WHERE person_id = p_student_id_b) THEN
		RAISE EXCEPTION 'Student B where person_id = % does not exist.', p_student_id_b;
	END IF;

	INSERT INTO sibling_junction
		(student_id, sibling_id)
	VALUES
		(p_student_id_a, p_student_id_b),
		(p_student_id_b, p_student_id_a)
	ON CONFLICT (student_id, sibling_id) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

--
-- Create relations between multiple siblings more easily
--
CREATE FUNCTION add_sibling_relation_multiple
(
	p_student_ids INT[]
)
RETURNS VOID AS
$$
DECLARE
	v_student_id_a INT;
	v_student_id_b INT;
BEGIN
	FOREACH v_student_id_a IN ARRAY p_student_ids
	LOOP
		FOREACH v_student_id_b IN ARRAY p_student_ids
		LOOP
			IF v_student_id_a != v_student_id_b THEN
				PERFORM add_sibling_relation(v_student_id_a, v_student_id_b);
			END IF;
		END LOOP;
	END LOOP;
END;
$$ LANGUAGE plpgsql;
