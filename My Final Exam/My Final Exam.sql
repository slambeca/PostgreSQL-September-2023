-- 1.1. Database Design 

DROP TABLE IF EXISTS towns CASCADE;

CREATE TABLE towns (
	"id" SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

DROP TABLE IF EXISTS stadiums CASCADE;

CREATE TABLE stadiums (
	"id" SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	capacity INT NOT NULL CHECK (capacity > 0),
	town_id INT NOT NULL,
	CONSTRAINT
		fk_stadiums_towns
	FOREIGN KEY
		(town_id)
	REFERENCES
		towns(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

DROP TABLE IF EXISTS teams CASCADE;

CREATE TABLE teams (
	"id" SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	established DATE NOT NULL,
	fan_base INT NOT NULL DEFAULT 0 CHECK (fan_base >= 0),
	stadium_id INT NOT NULL,
	CONSTRAINT
		fk_teams_stadiums
	FOREIGN KEY
		(stadium_id)
	REFERENCES
		stadiums(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

DROP TABLE IF EXISTS coaches CASCADE;

CREATE TABLE coaches (
	"id" SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (salary >= 0),
	coach_level INT NOT NULL DEFAULT 0 CHECK (coach_level >= 0)
);

DROP TABLE IF EXISTS skills_data CASCADE;

CREATE TABLE skills_data (
	"id" SERIAL PRIMARY KEY,
	dribbling INT DEFAULT 0 CHECK (dribbling >= 0),
	pace INT DEFAULT 0 CHECK (pace >= 0),
	"passing" INT DEFAULT 0 CHECK ("passing" >= 0),
	shooting INT DEFAULT 0 CHECK (shooting >= 0),
	speed INT DEFAULT 0 CHECK (speed >= 0),
	strength INT DEFAULT 0 CHECK (strength >= 0)
);

DROP TABLE IF EXISTS players CASCADE;

CREATE TABLE players (
	"id" SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	age INT NOT NULL DEFAULT 0 CHECK (age >= 0),
	position CHAR(1) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (salary >= 0),
	hire_date TIMESTAMP,
	skills_data_id INT NOT NULL,
	team_id INT,
	CONSTRAINT
		fk_players_skills_data
	FOREIGN KEY
		(skills_data_id)
	REFERENCES
		skills_data(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT
		fk_players_teams
	FOREIGN KEY 
		(team_id)
	REFERENCES
		teams(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

DROP TABLE IF EXISTS players_coaches CASCADE;

CREATE TABLE players_coaches (
	player_id INT,
	coach_id INT,
	CONSTRAINT
		fk_players_coaches_players
	FOREIGN KEY
		(player_id)
	REFERENCES 
		players(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT
		fk_players_coaches_coaches
	FOREIGN KEY
		(coach_id)
	REFERENCES
		coaches(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- 2.2. Insert 

INSERT INTO 
	coaches (
		first_name, 
		last_name, 
		salary, 
		coach_level
)
SELECT
    pl.first_name,
    pl.last_name,
    pl.salary * 2,
    LENGTH(pl.first_name)
FROM 
	players AS pl
WHERE 
	pl.hire_date < '2013-12-13 07:18:46';

-- 2.3 Update

UPDATE 
	coaches
SET 
	salary = salary * coach_level
WHERE 
	first_name LIKE 'C%' 
		AND "id" IN (
    			    SELECT DISTINCT coach_id
    			    FROM players_coaches
);

-- 2.4. Delete

DELETE FROM
	players
WHERE
	hire_date < '2013-12-13 07:18:46';

-- 3.5. Players

SELECT
	CONCAT_WS(' ', first_name, last_name) AS full_name,
	age,
	hire_date
FROM
	players
WHERE
	first_name LIKE 'M%'
ORDER BY
	age DESC,
	full_name ASC;

-- 3.6. Offensive Players without Team

SELECT
	pl.id AS "id",
	CONCAT_WS(' ', pl.first_name, pl.last_name) AS full_name,
	pl.age,
	pl.position,
	pl.salary,
	sd.pace,
	sd.shooting
FROM
	players AS pl
JOIN
	skills_data AS sd
ON
	pl.skills_data_id = sd.id
WHERE
	pl.team_id IS NULL
		AND
	pl.position = 'A'
		AND
	(sd.pace + sd.shooting) > 130;

-- 3.7. Teams with Player Count and Fan Base

SELECT
	t.id AS team_id,
	t.name AS team_name,
	COUNT(p.id) AS player_count,
	t.fan_base AS fan_base
FROM
	teams AS t
LEFT JOIN
	players AS p
ON
	t.id = p.team_id
GROUP BY
	t.id
HAVING
	fan_base > 30000
ORDER BY
	player_count DESC,
	fan_base DESC;

-- 3.8. Coaches, Players Skills and Teams Overview

SELECT
	CONCAT_WS(' ', co.first_name, co.last_name) AS coach_full_name,
	CONCAT_WS(' ', pl.first_name, pl.last_name) AS player_full_name,
	t.name AS team_name,
	sd.passing,
	sd.shooting,
	sd.speed
FROM
	coaches AS co
JOIN
	players_coaches AS pc
ON
	co.id = pc.coach_id
JOIN
	players AS pl
ON
	pc.player_id = pl.id
JOIN
	teams AS t
ON
	pl.team_id = t.id
JOIN
	skills_data AS sd
ON
	pl.skills_data_id = sd.id
ORDER BY
	coach_full_name ASC,
	player_full_name DESC;

-- 4.9. Stadium Teams Information

CREATE OR REPLACE FUNCTION fn_stadium_team_name(
	stadium_name VARCHAR(30)
) RETURNS TABLE (team_name VARCHAR(30)) AS
$$
	BEGIN
	RETURN QUERY
		SELECT
			DISTINCT(t.name)
			FROM
				stadiums AS st
			JOIN
				teams AS t
			ON
				st.id = t.stadium_id
			WHERE
				st.name = stadium_name
			ORDER BY
				t.name ASC;
			END;
$$
LANGUAGE plpgsql;

-- 4.10. Player Team Finder

CREATE OR REPLACE PROCEDURE sp_players_team_name (
	IN player_name VARCHAR(50),
	OUT team_name VARCHAR(45)
	)
AS
$$
	BEGIN
		SELECT
			t.name INTO team_name
		FROM
			players AS pl
		LEFT JOIN
			teams AS t
		ON
			pl.team_id = t.id
		WHERE
			CONCAT_WS(' ', pl.first_name, pl.last_name) = player_name;
		IF team_name IS NULL THEN
			team_name = 'The player currently has no team';
		END IF;
	END;
$$
LANGUAGE plpgsql;