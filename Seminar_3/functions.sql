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
	p_start_timestamp TIMESTAMP;
	p_end_timestamp   TIMESTAMP;
	new_lesson_id     INT;
BEGIN
	-- Creating timestamps
	p_start_timestamp := p_start_date + p_start_time;
	p_end_timestamp   := p_start_timestamp + p_duration;

	INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(p_instructor_id, 'Individual', p_skill_level, p_start_timestamp, p_end_timestamp)
	RETURNING
		id INTO new_lesson_id;

	INSERT INTO lesson_individual
		(lesson_id, instrument_focus)
	VALUES
		(new_lesson_id, p_instrument_focus);

	RETURN new_lesson_id;
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
	p_start_timestamp TIMESTAMP;
	p_end_timestamp   TIMESTAMP;
	new_lesson_id     INT;
BEGIN
	-- Creating timestamps
	p_start_timestamp := p_start_date + p_start_time;
	p_end_timestamp   := p_start_timestamp + p_duration;

	INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(p_instructor_id, 'Group', p_skill_level, p_start_timestamp, p_end_timestamp)
	RETURNING
		id INTO new_lesson_id;

	INSERT INTO lesson_group
		(lesson_id, number_of_places_min, number_of_places_max, instrument_focus)
	VALUES
		(new_lesson_id, p_number_of_places_min, p_number_of_places_max, p_instrument_focus);

	RETURN new_lesson_id;
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
	p_start_timestamp TIMESTAMP;
	p_end_timestamp   TIMESTAMP;
	new_lesson_id     INT;
BEGIN
	-- Creating timestamps
	p_start_timestamp := p_start_date + p_start_time;
	p_end_timestamp   := p_start_timestamp + p_duration;

	INSERT INTO lesson
		(instructor_id, lesson_type, skill_level, start_time, end_time)
	VALUES
		(p_instructor_id, 'Ensemble', p_skill_level, p_start_timestamp, p_end_timestamp)
	RETURNING
		id INTO new_lesson_id;

	INSERT INTO lesson_ensemble
		(lesson_id, number_of_places_min, number_of_places_max, genre)
	VALUES
		(new_lesson_id, p_number_of_places_min, p_number_of_places_max, p_genre);

	RETURN new_lesson_id;
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
-- Trigger to make sure an instructor is proficient in the given instrument_focus.
--
CREATE FUNCTION validate_instrument_focus()
RETURNS TRIGGER AS
$$
	BEGIN
		IF NOT EXISTS (
			SELECT 1
			FROM instructor_instrument_proficiency junction
			JOIN instrument_proficiency proficiency ON junction.instrument_proficiency_id = proficiency.id
			WHERE junction.instructor_id = (SELECT instructor_id FROM lesson WHERE lesson.id = NEW.lesson_id)
			AND proficiency.instrument_name = NEW.instrument_focus
		) THEN
			RAISE EXCEPTION 'The instrument_focus is not valid for the given instructor.';
		END IF;

		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;
