-- 01. Find Book Titles 

SELECT 
	title 
FROM 
	books
WHERE 
	title LIKE 'The%';

-- Variant 2 with SUBSTRING
SELECT 
	title 
FROM 
	books
WHERE 
	SUBSTRING(title, 1, 3) = 'The'
ORDER BY
	id ASC;
