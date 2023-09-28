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

CREATE VIEW
AS 
	view_wizard_deposits_with_expiration_date_before_1983_08_17
SELECT
	concat(first_name, ' ', last_name) AS "Wizard Name",
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
	deposit_expiration_date <= '1983-08-07'
ORDER BY
	deposit_expiration_date ASC;
