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
