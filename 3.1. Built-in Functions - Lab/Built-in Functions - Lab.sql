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
