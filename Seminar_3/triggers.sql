CREATE TRIGGER lesson_individual_validate_instrument_focus
BEFORE INSERT OR UPDATE ON lesson_individual
FOR EACH ROW
EXECUTE FUNCTION validate_instrument_focus();

CREATE TRIGGER lesson_group_validate_instrument_focus
BEFORE INSERT OR UPDATE ON lesson_group
FOR EACH ROW
EXECUTE FUNCTION validate_instrument_focus();
