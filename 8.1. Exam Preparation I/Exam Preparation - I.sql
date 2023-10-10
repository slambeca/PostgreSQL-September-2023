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
