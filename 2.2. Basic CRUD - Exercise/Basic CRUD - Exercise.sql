-- 01. Select Cities 

SELECT * FROM cities

ORDER BY id ASC;

-- 02. Concatenate

SELECT CONCAT(name, ' ', state) AS "Cities Information",
area AS "Area (km2)"
FROM cities;

-- 03. Remove Duplicate Rows

SELECT DISTINCT name, 
area AS "Area (km2)"
FROM cities
ORDER BY NAME DESC;

-- 04. Limit Records

SELECT id AS "ID",
CONCAT(first_name, ' ', last_name) AS "Full Name",
job_title AS "Job Title"
FROM employees
ORDER BY first_name
LIMIT 50;  
