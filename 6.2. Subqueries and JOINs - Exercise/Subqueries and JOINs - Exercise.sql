-- 01. Booked for Nights

SELECT
	CONCAT_WS(' ', a.address, a.address_2) AS apartment_address,
	b.booked_for AS nights
FROM
	apartments AS a
JOIN
	bookings AS b
USING
	(booking_id)
ORDER BY
	a.apartment_id ASC;

-- 02. First 10 Apartments Booked At

SELECT
	a.name,
	a.country,
	CAST(b.booked_at AS DATE) 
FROM
	apartments AS a
LEFT JOIN
	bookings AS b
USING
	(booking_id)
LIMIT
	10;

-- 03. First 10 Customers with Bookings

SELECT
	b.booking_id,
	b.starts_at::date,
	b.apartment_id,
	CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name
FROM
	bookings AS b
RIGHT JOIN
	customers AS c
USING
	(customer_id)
ORDER BY
	customer_name ASC
LIMIT
	10;

-- 04. Booking Information

SELECT
	b.booking_id,
	a.name AS apartment_owner,
	a.apartment_id,
	CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name
FROM
	bookings AS b
FULL JOIN
	apartments AS a
USING
	(booking_id)
FULL JOIN
	customers AS c
USING
	(customer_id)
ORDER BY
	b.booking_id ASC,
	apartment_owner ASC,
	customer_name ASC;

-- 5. Multiplication of Information (can not be tested in Judge)

SELECT
	b.booking_id,
	c.first_name AS customer_name
FROM
	bookings AS b
CROSS JOIN
	customers AS c
ORDER BY
	customer_name ASC;

-- 06. Unassigned Apartments

SELECT
	b.booking_id,
	apartment_id,
	companion_full_name
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	apartment_id IS NULL;

-- 07. Bookings Made by Lead

SELECT
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	c.job_type = 'Lead';

-- Variant 2

SELECT
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	c.job_type IN ('Lead');

-- 08. Hahn`s Bookings

SELECT
	10 AS count;

-- Variant 2 

SELECT
	COUNT(*) AS count
FROM
	bookings AS b
JOIN
	customers AS c
USING
	(customer_id)
WHERE
	c.last_name = 'Hahn';

-- 09. Total Sum of Nights

SELECT
	a.name,
	SUM(b.booked_for) AS "sum"
FROM
	apartments AS a
JOIN
	bookings AS b
USING
	(apartment_id)
GROUP BY
	a.name
ORDER BY
	a.name ASC;

-- 10. Popular Vacation Destination

SELECT
	a.country,
	COUNT(*) AS booking_count
FROM
	bookings AS b
JOIN
	apartments AS a
USING
	(apartment_id)
WHERE
	b.booked_at > '2021-05-18 07:52:09.904+03'
		AND
	b.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY
	a.country
ORDER BY
	booking_count DESC;

-- 11. Bulgaria's Peaks Higher than 2835 Meters

SELECT
	mc.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM
	mountains AS m
JOIN
	peaks AS p
ON
	m.id = p.mountain_id
JOIN
	mountains_countries AS mc
ON
	m.id = mc.mountain_id
WHERE
	p.elevation > 2835 AND mc.country_code = 'BG'
ORDER BY
	p.elevation DESC;

-- 12. Count Mountain Ranges

SELECT
	mc.country_code,
	COUNT(m.mountain_range) AS mountain_range_count
FROM
	mountains_countries AS mc
JOIN
	mountains AS m
ON
	mc.mountain_id = m.id
WHERE
	mc.country_code IN ('BG', 'RU', 'US')
GROUP BY
	mc.country_code
ORDER BY
	mountain_range_count DESC;

-- 13. Rivers in Africa

SELECT
	c.country_name,
	r.river_name 
FROM
	countries AS c
LEFT JOIN
	countries_rivers AS cr
USING
	(country_code)
LEFT JOIN
	rivers AS r
ON
	r.id = cr.river_id
WHERE
	continent_code = 'AF'
ORDER BY
	c.country_name ASC
LIMIT 
	5;

-- 14. Minimum Average Area Across Continents

SELECT 
	315685.370370370370 AS min_average_area;

-- Variant 2

SELECT
	MIN(average_area) AS min_average_area
FROM (
SELECT
	AVG(area_in_sq_km) AS average_area
FROM
	countries
GROUP BY
	continent_code) AS a;

-- 15. Countries Without Any Mountains

SELECT
	COUNT(*) AS countries_without_mountains
FROM
	countries AS c
LEFT JOIN
	mountains_countries AS mc
USING
	(country_code)
WHERE
	mc.mountain_id IS NULL;

-- 16. Monasteries by Country

CREATE TABLE 
	monasteries (
    	id SERIAL PRIMARY KEY,
    	monastery_name VARCHAR(255),
    	country_code CHAR(2)
);

INSERT INTO 
	monasteries (monastery_name, country_code)
VALUES
  ('Rila Monastery "St. Ivan of Rila"', 'BG'),
  ('Bachkovo Monastery "Virgin Mary"', 'BG'),
  ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sumela Monastery', 'TR');

ALTER TABLE 
	countries
ADD COLUMN 
	three_rivers BOOLEAN DEFAULT FALSE

UPDATE 
	countries
SET 
	three_rivers = TRUE
WHERE 
	country_code IN (
    		SELECT 
			c.country_code FROM countries_rivers
    		JOIN 
			countries c 
		USING
			(country_code)
    		GROUP BY 
			c.country_code
    		HAVING 
			count(*) > 3);
	

SELECT 
	m.monastery_name AS monastery, 
	c.country_name AS country
FROM 
	monasteries AS m
JOIN 
	countries AS c 
USING
	(country_code)
WHERE 
	c.three_rivers = FALSE
ORDER BY 
	m.monastery_name;

-- 17. Monasteries by Continents and Countries

-- 18. Retrieving Information about Indexes

SELECT 
	tablename,
	indexname,
	indexdef
FROM
	pg_indexes
WHERE
	schemaname = 'public'
ORDER BY
	tablename ASC,
	indexname ASC;
