-- 01. Find Book Titles 

SELECT 
	title 
FROM 
	books
WHERE 
	SUBSTRING(title, 1, 3) = 'The'
ORDER BY
	id ASC;

# Variant 2 with LIKE

SELECT 
	title 
FROM 
	books
WHERE 
	title LIKE 'The%';

-- 02. Replace Titles 

SELECT
	REPLACE(title, 'The', '***')
FROM
	books
WHERE title LIKE 'The%'
ORDER BY
	id ASC;

-- 03. Triangles on Bookshelves

SELECT
	id,
	side * height / 2 AS area
FROM
	triangles
ORDER BY 
	id ASC;

-- 04. Format Costs

SELECT
	title,
	ROUND(cost, 3)
FROM
	books
ORDER BY
	id ASC;

-- 05. Year of Birth

SELECT 
	first_name,
	last_name,
	EXTRACT('year' FROM born)
FROM 
	authors;

-- 06. Format Date of Birth

SELECT
	last_name as "Last Name",
	TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM
	authors;

-- 07. Harry Potter Books

SELECT
	title
FROM
	books
WHERE
	title LIKE 'Harry Potter%';
