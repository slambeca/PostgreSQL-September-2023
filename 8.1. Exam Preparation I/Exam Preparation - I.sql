-- 1.1. Database Design

DROP TABLE IF EXISTS owners CASCADE;

CREATE TABLE
	owners (
		id SERIAL PRIMARY KEY,
		name VARCHAR(50) NOT NULL,
		phone_number VARCHAR(15) NOT NULL,
		address VARCHAR(50)
);

DROP TABLE IF EXISTS animal_types CASCADE;

CREATE TABLE
	animal_types (
		id SERIAL PRIMARY KEY,
		animal_type VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS cages CASCADE;

CREATE TABLE cages(
	id SERIAL PRIMARY KEY,
	animal_type_id INT NOT NULL
);

ALTER TABLE 
	cages
ADD CONSTRAINT 
	fk_cages_animal_types
FOREIGN KEY 
	(animal_type_id)
REFERENCES 
	animal_types(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

DROP TABLE IF EXISTS animals CASCADE;

CREATE TABLE animals (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	birthdate DATE NOT NULL,
	owner_id INT,
	animal_type_id INT NOT NULL
);

ALTER TABLE 
	animals
ADD CONSTRAINT
	fk_animals_owners
FOREIGN KEY
	(owner_id)
REFERENCES
	owners(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT
	fk_animals_animal_types
FOREIGN KEY
	(animal_type_id)
REFERENCES
	animal_types(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

DROP TABLE IF EXISTS volunteers_departments CASCADE;

CREATE TABLE volunteers_departments (
	id SERIAL PRIMARY KEY,
	department_name VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS volunteers CASCADE;

CREATE TABLE volunteers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50),
	animal_id INT,
	department_id INT NOT NULL
);

ALTER TABLE
	volunteers
ADD CONSTRAINT
	fk_volunteers_animals
FOREIGN KEY
	(animal_id)
REFERENCES
	animals(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT
	fk_volunteers_volunteers_departments
FOREIGN KEY
	(department_id)
REFERENCES
	volunteers_departments(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

DROP TABLE IF EXISTS animals_cages CASCADE;

CREATE TABLE animals_cages (
	cage_id INT NOT NULL,
	animal_id INT NOT NULL
);

ALTER TABLE
	animals_cages
ADD CONSTRAINT
	fk_animals_cages_cages
FOREIGN KEY
	(cage_id)
REFERENCES
	cages(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
ADD CONSTRAINT
	fk_animals_cages_animals
FOREIGN KEY
	(animal_id)
REFERENCES
	animals(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE;

-- 2.2 Insert

INSERT INTO
	volunteers(name, phone_number, address, animal_id, department_id)
VALUES
	('Anita Kostova', '0896365412',	'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223',	NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9,	7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5);
	
INSERT INTO
	animals(name, birthdate, owner_id, animal_type_id)
VALUES
	('Giraffe',	'2018-09-21', 21,	1),
	('Harpy Eagle',	'2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara',	'2021-06-30', 2, 4);

-- 2.3. Update

UPDATE
	animals
SET
	owner_id = (SELECT id FROM owners WHERE name = 'Kaloqn Stoqnov')
WHERE
	owner_id IS NULL;

-- 2.4. Delete

DELETE
FROM
	volunteers_departments
WHERE
	department_name = 'Education program assistant';

-- 3.5 Volunteers

SELECT
	name,
	phone_number,
	address,
	animal_id,
	department_id
FROM
	volunteers
ORDER BY
	name ASC,
	animal_id ASC,
	department_id ASC;

-- 3.6 Animals Data

SELECT
	a.name,
	at.animal_type,
	TO_CHAR(a.birthdate, 'DD.MM.YYYY') AS birthdate
FROM
	animals AS a
JOIN
	animal_types AS at
ON
	a.animal_type_id = at.id
ORDER BY
	a.name;

-- 3.7. Owners and Their Animals

SELECT
	o.name AS owner,
	COUNT(a.id) AS count_of_animals
FROM
	animals AS a
JOIN
	owners AS o
ON
	a.owner_id = o.id
GROUP BY
	o.name
ORDER BY
	count_of_animals DESC,
	o.name ASC
LIMIT 
	5;

-- 3.8. Owners, Animals and Cages

SELECT
	CONCAT_WS(' - ', o.name, a.name) AS "Owners - Animals",
	o.phone_number AS "Phone Number",
	ac.cage_id AS "Cage ID"
FROM
	animals AS a
JOIN
	owners AS o
ON 
	a.owner_id = o.id
JOIN
	animals_cages AS ac
ON
	a.id = ac.animal_id
WHERE 
-- 	a.animal_type_id = 1
	a.animal_type_id = (SELECT id FROM animal_types WHERE animal_type = 'Mammals')
ORDER BY
	o.name ASC,
	a.name DESC;

-- 3.9. Volunteers in Sofia

SELECT
	name AS volunteers,
	phone_number,
	REGEXP_REPLACE(address, '.*?(\d+)', '\1') AS address
FROM
	volunteers
WHERE
	department_id = (SELECT id FROM volunteers_departments WHERE department_name = 'Education program 

assistant')
AND
	address LIKE '%Sofia%'
ORDER BY
	name ASC;

-- Variant 2

SELECT
	name AS volunteers,
	phone_number,
	SUBSTRING(TRIM(REPLACE(address, 'Sofia', '')), 3) AS address
FROM
	volunteers
WHERE
	department_id = (SELECT id FROM volunteers_departments WHERE department_name = 'Education program 

assistant')
AND
	address LIKE '%Sofia%'
ORDER BY
	name ASC;

-- 3.10. Animals for Adoption

SELECT
	a.name AS animal,
	EXTRACT('year' FROM a.birthdate) AS birth_year,
	at.animal_type
FROM
	animals AS a
JOIN
	animal_types AS at
ON
	a.animal_type_id = at.id
WHERE
	at.animal_type <> 'Birds'
		AND
	a.owner_id IS NULL
		AND
	AGE('01/01/2022', a.birthdate) < '5 years'
ORDER BY
	a.name ASC;

-- 4.11. All Volunteers in a Department

CREATE OR REPLACE FUNCTION 
	fn_get_volunteers_count_from_department(searched_volunteers_department VARCHAR(30))
RETURNS INT
AS
$$
	BEGIN
		RETURN
			COUNT(*)
		FROM
			volunteers AS v
		JOIN
			volunteers_departments AS vd
		ON
			v.department_id = vd.id
		WHERE
			department_name = searched_volunteers_department;
	END;
$$
LANGUAGE plpgsql;

-- 4.12. Animals with Owner or Not

CREATE OR REPLACE PROCEDURE 
	sp_animals_with_owners_or_not(
		IN animal_name VARCHAR(30),
		OUT procedure_output VARCHAR(30)
)
AS
$$
	BEGIN
		SELECT
			o.name
		FROM
			animals AS a
		LEFT JOIN
			owners AS o
		ON
			a.owner_id = o.id
		WHERE
			a.name = animal_name
		INTO procedure_output;
		IF procedure_output IS NULL THEN
			procedure_output = 'For adoption';
	END IF;
	RETURN;
	END;
$$
LANGUAGE plpgsql;

CALL sp_animals_with_owners_or_not('Pumpkinseed Sunfish')
