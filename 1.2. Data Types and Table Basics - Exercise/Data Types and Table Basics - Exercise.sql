00. Create a Database

CREATE DATABASE minions_db;


01. Create a Table

CREATE TABLE IF NOT EXISTS minions
	(
		id SERIAL PRIMARY KEY,
		"name" VARCHAR(30),
		age INTEGER
	);

02. Rename the Table

ALTER TABLE minions
RENAME TO minions_info;

03. Alter the Table

ALTER TABLE minions_info
ADD COLUMN code CHAR(4),
ADD COLUMN task TEXT,
ADD COLUMN salary DECIMAL(8, 3);

04. Rename Column

ALTER TABLE minions_info
RENAME COLUMN salary TO banana;

05. Add New Columns

ALTER TABLE minions_info
ADD COLUMN email VARCHAR(20),
ADD COLUMN equipped BOOLEAN NOT NULL;

06. Create ENUM Type

CREATE TYPE type_mood AS ENUM 
	(
	'happy',
	'relaxed',
	'stressed',
	'sad'
);

ALTER TABLE minions_info
ADD COLUMN mood type_mood;

07. Set Default

ALTER TABLE minions_info
ALTER COLUMN age SET DEFAULT 0,
ALTER COLUMN "name" SET DEFAULT '',
ALTER COLUMN code SET DEFAULT '';
