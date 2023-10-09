-- 1.1. Database Design

DROP TABLE IF EXISTS owners;

CREATE TABLE
	owners (
		id SERIAL PRIMARY KEY,
		name VARCHAR(50) NOT NULL,
		phone_number VARCHAR(15) NOT NULL,
		address VARCHAR(50)
);

DROP TABLE IF EXISTS animal_types;

CREATE TABLE
	animal_types (
		id SERIAL PRIMARY KEY,
		animal_type VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS cages;

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
	animal_types(id);

DROP TABLE IF EXISTS animals;

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
	owners(id),
ADD CONSTRAINT
	fk_animals_animal_types
FOREIGN KEY
	(animal_type_id)
REFERENCES
	animal_types(id);

DROP TABLE IF EXISTS volunteers_departments;

CREATE TABLE volunteers_departments (
	id SERIAL PRIMARY KEY,
	department_name VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS volunteers;

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
	animals(id),
ADD CONSTRAINT
	fk_volunteers_volunteers_departments
FOREIGN KEY
	(department_id)
REFERENCES
	volunteers_departments(id);

DROP TABLE IF EXISTS animals_cages;

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
	cages(id),
ADD CONSTRAINT
	fk_animals_cages_animals
FOREIGN KEY
	(animal_id)
REFERENCES
	animals(id);