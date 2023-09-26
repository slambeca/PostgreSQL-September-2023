-- 01. River Info 

CREATE VIEW 
	view_river_info 
AS
SELECT 
	CONCAT('The river', ' ', river_name, ' ', 'flows into the', ' ', outflow, ' ', 'and is', ' ', "length", ' 
', 'kilometers long.') AS "River Information"
FROM 
	rivers
ORDER BY
	river_name ASC;

-- 02. Concatenate Geography Data

CREATE OR REPLACE VIEW 
	view_continents_countries_currencies_details
AS
SELECT
	CONCAT(con.continent_name, ': ', con.continent_code) AS "Continent Details",
	CONCAT(cou.country_name, ' - ', cou.capital, ' - ', cou.area_in_sq_km, ' - ', 'km2') AS "Country 

Information",
	CONCAT(cur.description, ' ', '(', cur.currency_code, ')') AS "Currencies"
FROM 
	continents AS con, 
	countries AS cou, 
	currencies AS cur
WHERE
	con.continent_code = cou.continent_code AND cou.currency_code = cur.currency_code
ORDER BY
	"Country Information" ASC, "Currencies" ASC;

-- 03. Capital Code

ALTER TABLE
	countries
ADD COLUMN 
	capital_code CHAR(2);

UPDATE 
	countries
SET
	capital_code = SUBSTRING(capital, 1, 2);

-- 04. (Descr)iption

SELECT 
	SUBSTRING(description, 5) AS "substring" 
FROM 
	currencies;
	
-- Variant 2
SELECT
	RIGHT(description, -4) AS "substring"
FROM
	currencies;

-- 05. Substring River Length

SELECT
	SUBSTRING("River Information", '([0-9]{1,4})') AS river_length
FROM
	view_river_info;

-- Variant 2

SELECT 
	(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1] AS river_length
FROM 
	view_river_info;

-- 06. Replace A

SELECT
	REPLACE(mountain_range, 'a', '@') AS replace_a,
	REPLACE(mountaint_range, 'A', '$') AS replace_A
FROM
	mountains;

-- 07. Translate 

SELECT
	capital,
	TRANSLATE(capital, 'aaaceinou', 'aaaceinou') AS translated_name
FROM
	countries;

-- 08. LEADING

SELECT
	continent_name,
	TRIM(continent_name)
FROM
	continents;

-- Variant 2

SELECT
	continent_name,
	TRIM(LEADING FROM continent_name)
FROM
	continents;

-- 09. TRAILING

SELECT
	continent_name,
	TRIM(TRAILING FROM continent_name) AS trim
FROM
	continents;

-- 10. LTRIM & RTRIM

SELECT
	LTRIM(peak_name, 'M') AS "Left Trim",
	RTRIM(peak_name, 'm') AS "Right Trim"
FROM
	peaks;

-- 11. Character Length and Bits

SELECT
	CONCAT_WS(' ', mou.mountain_range, pea.peak_name) AS "Mountain Information",
	CHAR_LENGTH(CONCAT_WS(' ', mou.mountain_range, pea.peak_name)) AS "Characters Length",
	BIT_LENGTH(CONCAT_WS(' ', mou.mountain_range, pea.peak_name)) AS "Bits of a String"
FROM
	mountains AS mou, peaks AS pea
WHERE
	mou."id" = pea.mountain_id;

-- 12. Length of a Number

SELECT
	population,
	LENGTH(population::varchar) AS "length"
FROM
	countries;
	
-- Variant 2

SELECT
	population,
	LENGTH(CAST(population AS VARCHAR)) AS "length"
FROM
	countries;

-- 13. Positive and Negative LEFT 
