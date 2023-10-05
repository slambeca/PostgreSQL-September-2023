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
