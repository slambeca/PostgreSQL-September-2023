-- 01. COUNT of Records

SELECT
	COUNT(*) AS "Count"
FROM
	wizard_deposits;

-- 02. Total Deposit Amount 

SELECT
	SUM(deposit_amount) AS "Total Amount"
FROM
	wizard_deposits;

-- 03. AVG Magic Wand Size

SELECT
	ROUND(AVG(magic_wand_size), 3)
FROM
	wizard_deposits;

-- 04. MIN Deposit Charge 

SELECT
	MIN(deposit_charge) AS "Minimum Deposit Charge"
FROM
	wizard_deposits;

-- 05. MAX Age

SELECT
	MAX(age) as "Maximum Age"
FROM
	wizard_deposits;

-- 06. GROUP BY Deposit Interest 

SELECT
	deposit_group,
	SUM(deposit_interest) AS "Deposit Interest"
FROM
	wizard_deposits
GROUP BY
	deposit_group
ORDER BY
	"Deposit Interest" DESC;

-- 07. LIMIT the Magic Wand Creator

SELECT
	magic_wand_creator,
	MIN(magic_wand_size) AS "Minimum Wand Size"
FROM
	wizard_deposits
GROUP BY
	magic_wand_creator
ORDER BY 
	"Minimum Wand Size" ASC
LIMIT 5;

-- 08. Bank Profitability

SELECT
	deposit_group,
	is_deposit_expired,
	FLOOR(AVG(deposit_interest)) AS "Deposit Interest"
FROM
	wizard_deposits
WHERE 
	deposit_start_date > '1985-01-01'
GROUP BY
	deposit_group,
	is_deposit_expired
ORDER BY
	deposit_group DESC,
	is_deposit_expired ASC;

-- 09. Notes with Dumbledore

SELECT
	last_name,
	COUNT(notes) AS "Notes with Dumbledore"
FROM
	wizard_deposits
WHERE notes LIKE '%Dumbledore%'
GROUP BY
	last_name;

-- 10. Wizard View

CREATE VIEW view_wizard_deposits_with_expiration_date_before_1983_08_17
AS 
SELECT
	CONCAT(first_name, ' ', last_name) AS "Wizard Name",
	deposit_start_date AS "Start Date",
	deposit_expiration_date AS "Expiration Date",
	deposit_amount AS "Amount"
FROM
	wizard_deposits
GROUP BY
	"Wizard Name",
	"Start Date",
	"Expiration Date",
	"Amount"
HAVING 
	deposit_expiration_date <= '1983-08-17'
ORDER BY
	deposit_expiration_date ASC;

-- 11. Filter Max Deposit

SELECT
	magic_wand_creator,
	MAX(deposit_amount) AS "Max Deposit Amount"
FROM
	wizard_deposits
GROUP BY 
	magic_wand_creator
HAVING
	MAX(deposit_amount) NOT BETWEEN 20000 and 40000
ORDER BY
	"Max Deposit Amount" DESC
LIMIT 3;

-- Variant 2

SELECT
	magic_wand_creator,
	MAX(deposit_amount) AS "Max Deposit Amount"
FROM
	wizard_deposits
GROUP BY 
	magic_wand_creator
HAVING
	MAX(deposit_amount) < 20000
		AND
	MAX(deposit_amount) > 40000
ORDER BY
	"Max Deposit Amount" DESC
LIMIT 3;

-- 12. Age Group

SELECT
	CASE
		WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END AS "Age Group",
	COUNT(*)
FROM
	wizard_deposits
GROUP BY 
	"Age Group"
ORDER BY 
	"Age Group" ASC;

-- 13. SUM the Employees

SELECT
	COUNT(CASE WHEN department_id = 1 THEN 1 END) AS "Engineering",
	COUNT(CASE WHEN department_id = 2 THEN 1 END) AS "Tool Design",
	COUNT(CASE WHEN department_id = 3 THEN 1 END) AS "Sales",
	COUNT(CASE WHEN department_id = 4 THEN 1 END) AS "Marketing",
	COUNT(CASE WHEN department_id = 5 THEN 1 END) AS "Purchasing",
	COUNT(CASE WHEN department_id = 6 THEN 1 END) AS "Research and Development",
	COUNT(CASE WHEN department_id = 7 THEN 1 END) AS "Production"
FROM
	employees;

-- 14. Update Employees’ Data

UPDATE
	employees
SET
	salary = CASE
		WHEN hire_date < '2015-01-16' THEN salary + 2500
		WHEN hire_date < '2020-03-04' THEN salary + 1500
		ELSE salary
	END,
	job_title = CASE
		WHEN hire_date < '2015-01-16' THEN 'Senior ' || job_title
		WHEN hire_date < '2020-03-04' THEN 'Mid-' || job_title
		ELSE job_title
	END;

-- 15. Categorizes Salary
