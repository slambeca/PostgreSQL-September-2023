DROP TABLE IF EXISTS addresses CASCADE;

CREATE TABLE addresses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(10) NOT NULL
);

DROP TABLE IF EXISTS clients CASCADE;

CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS drivers CASCADE;

CREATE TABLE drivers (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	age INT NOT NULL,
	rating NUMERIC(3, 2) DEFAULT 5.5,
	CONSTRAINT 
		ck_drivers_age 
	CHECK (age > 0)
);

DROP TABLE IF EXISTS cars CASCADE;

CREATE TABLE cars (
	id SERIAL PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
	model VARCHAR(20),
	year INT NOT NULL DEFAULT 0,
	mileage INT DEFAULT 0,
	condition CHAR(1) NOT NULL,
	category_id INT NOT NULL,
	CONSTRAINT
		ck_cars_year
	CHECK
		(year > 0),
	CONSTRAINT
		ck_cars_mileage
	CHECK
		(mileage > 0),
	CONSTRAINT 
		fk_cars_categories
	FOREIGN KEY 
		(category_id)
	REFERENCES
		categories(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

DROP TABLE IF EXISTS courses CASCADE;

CREATE TABLE courses (
	id SERIAL PRIMARY KEY,
	from_address_id INT NOT NULL,
	start TIMESTAMP NOT NULL,
	bill NUMERIC(10, 2) DEFAULT 10,
	car_id INT NOT NULL,
	client_id INT NOT NULL,
	CONSTRAINT
		fk_courses_addresses
	FOREIGN KEY
		(from_address_id)
	REFERENCES
		addresses(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT
		ck_courses_bill
	CHECK
		(bill > 0),
	CONSTRAINT
		fk_courses_cars
	FOREIGN KEY
		(car_id)
	REFERENCES
		cars(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT
		fk_courses_clients
	FOREIGN KEY
		(client_id)
	REFERENCES
		clients(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

DROP TABLE IF EXISTS cars_drivers CASCADE;

CREATE TABLE cars_drivers (
	car_id INT NOT NULL,
	driver_id INT NOT NULL,
	CONSTRAINT
		fk_cars_drivers_cars
	FOREIGN KEY
		(car_id)
	REFERENCES
		cars(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	CONSTRAINT
		fk_cars_drivers_drivers
	FOREIGN KEY
		(driver_id)
	REFERENCES
		drivers(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- 2.2. Insert

INSERT INTO
	clients(full_name, phone_number)
SELECT
	CONCAT_WS(' ', first_name, last_name),
	'(088) 9999' || id * 2
FROM
	drivers
WHERE
	"id" BETWEEN 10 AND 20;

-- 2.3. Update

UPDATE
	cars
SET
	condition = 'C'
WHERE
	(mileage > 800000 OR mileage IS NULL)
		AND
	year <= 2010
		AND
	make <> 'Mercedes-Benz';

-- 2.4. Delete

DELETE FROM
	clients
WHERE
	LENGTH(full_name) > 3
		AND
	"id" NOT IN (
		SELECT client_id FROM courses);

-- 3.5. Cars

SELECT
	make,
	model,
	condition
FROM
	cars;

-- 3.6. Drivers and Cars

SELECT
	d.first_name,
	d.last_name,
	c.make,
	c.model,
	c.mileage
FROM
	drivers AS d
JOIN
	cars_drivers AS cd
ON
	d.id = cd.driver_id
JOIN
	cars AS c
ON
	cd.car_id = c.id
WHERE
	c.mileage IS NOT NULL
ORDER BY
	mileage DESC,
	first_name ASC;

-- 3.7. Number of Courses for Each Car

SELECT
	c.id AS car_id,
	c.make,
	c.mileage,
	count(cou.id) AS count_of_courses,
	ROUND(AVG(cou.bill), 2) AS average_bill
FROM
	cars AS c
LEFT JOIN
	courses AS cou
ON
	c.id = cou.car_id
GROUP BY
	c.id
HAVING
	count(cou.id) <> 2
ORDER BY
	count_of_courses DESC,
	c.id ASC;

-- 3.8. Regular Clients

SELECT
	c.full_name,
	COUNT(cou.id) AS count_of_cars,
	SUM(cou.bill) AS total_sum
FROM
	clients AS c
JOIN
	courses AS cou
ON
	c.id = cou.client_id
WHERE
	full_name LIKE '_a%'
GROUP BY
	c.full_name
HAVING
	COUNT(cou.id) > 1
ORDER BY
	c.full_name;

-- 3.9. Full Information of Courses

SELECT
	ad.name AS address,
	CASE
		WHEN EXTRACT(HOUR FROM cou.start) BETWEEN 6 AND 20 THEN 'Day'
		ELSE 'Night'
	END AS day_time,
	cou.bill AS bill,
	cl.full_name,
	ca.make,
	ca.model,
	cat.name AS category_name
FROM
	courses AS cou
JOIN
	addresses AS ad
ON
	cou.from_address_id = ad.id
JOIN
	clients AS cl
ON
	cou.client_id = cl.id
JOIN
	cars AS ca
ON
	cou.car_id = ca.id
JOIN
	categories AS cat
ON
	cat.id = ca.category_id
ORDER BY
	cou.id;

-- 4.10. Find all Courses by Client’s Phone Number

CREATE OR REPLACE FUNCTION
	fn_courses_by_client(phone_num VARCHAR(20))
RETURNS INT AS
$$
BEGIN
RETURN
	count(*)
FROM
	courses AS co
JOIN
	clients AS cl
ON
	cl.id = co.client_id
WHERE
	cl.phone_number LIKE phone_num;
END;
$$
LANGUAGE plpgsql;

-- Variant 2

CREATE OR REPLACE FUNCTION 
	fn_courses_by_client(phone_num VARCHAR(20))
RETURNS INTEGER AS 
$$
DECLARE
    course_count INT;
BEGIN
    SELECT COUNT(*) INTO course_count
    FROM clients AS c
    JOIN courses AS co ON c.id = co.client_id
    WHERE c.phone_number = phone_num;
    RETURN course_count;
END;
$$
LANGUAGE plpgsql;

-- 4.11. Full Info for Address 
