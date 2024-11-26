DO
$$
BEGIN
	-- 2 siblings
	PERFORM add_sibling_relation(20, 21);
	PERFORM add_sibling_relation(22, 23);
	PERFORM add_sibling_relation(24, 25);
	PERFORM add_sibling_relation(26, 27);
	PERFORM add_sibling_relation(28, 29);
	-- 3 siblings
	PERFORM add_sibling_relation_multiple(ARRAY[30, 31, 32]);
	PERFORM add_sibling_relation_multiple(ARRAY[33, 34, 35]);
	PERFORM add_sibling_relation_multiple(ARRAY[36, 37, 38]);
	PERFORM add_sibling_relation_multiple(ARRAY[39, 40, 41]);
	PERFORM add_sibling_relation_multiple(ARRAY[42, 43, 44]);
	PERFORM add_sibling_relation_multiple(ARRAY[45, 46, 47]);
	PERFORM add_sibling_relation_multiple(ARRAY[48, 49, 50]);
END;
$$
LANGUAGE plpgsql;
