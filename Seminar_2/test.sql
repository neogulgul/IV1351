DROP DATABASE IF EXISTS soundgood;

CREATE DATABASE soundgood;

\c soundgood

CREATE TABLE people(
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

INSERT INTO people (name) VALUES ('name1');

INSERT INTO people (name) VALUES ('name2');

-- test
SELECT * FROM people;
