-- 01. Select Cities 

SELECT 
	* 
FROM 
	cities

ORDER BY
	 id ASC;

-- 02. Concatenate

SELECT 
	CONCAT(name, ' ', state) AS "Cities Information",
	area AS "Area (km2)"
FROM 
	cities;

-- 03. Remove Duplicate Rows

SELECT 
	DISTINCT name, 
	area AS "Area (km2)"
FROM 
	cities
ORDER BY 
	name DESC;

-- 04. Limit Records

SELECT 
	id AS "ID",
	CONCAT(first_name, ' ', last_name) AS "Full Name",
	job_title AS "Job Title"
FROM 
	employees
ORDER BY 
	first_name
LIMIT 
	50;

-- 05. Skip Rows

SELECT
	id,
	CONCAT_WS(' ', first_name, middle_name, last_name) AS "Full Name",
	hire_date as "Hire Date"
FROM
	employees
ORDER BY
	hire_date ASC
OFFSET
	9; -- offset starts from 0

-- 06. Find the Addresses

SELECT 
	id,
	CONCAT_WS(' ', number, street) AS "Address",
	city_id
FROM
	addresses
WHERE
	id >= 20; 

-- 07. Positive Even Number 

	CONCAT_WS(' ', number, street) AS "Address",
	city_id
FROM
	addresses
WHERE 
	city_id % 2 = 0 AND city_id > 0
ORDER BY
	city_id ASC;

-- 08. Projects within a Date Range 

SELECT 
	name,
	start_date,
	end_date
FROM
	projects
WHERE
	start_date >= '2016-06-01 07:00:00'::date
		AND 
	end_date < '2023-06-04 00:00:00'::date
ORDER BY
	start_date ASC;

-- 09. Multiple Conditions

SELECT
	number,
	street
FROM
	addresses
WHERE 
	id BETWEEN 50 AND 100 
		OR 
	number < 1000; 
