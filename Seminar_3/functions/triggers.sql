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
