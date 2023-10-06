-- 01. Count Employees by Town

CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name VARCHAR)
RETURNS INT AS

$$
	BEGIN
	RETURN (SELECT
	COUNT(*) AS count
FROM
	employees AS e
JOIN
	addresses AS a
USING
	(address_id)
JOIN
	towns AS t
USING
	(town_id)
WHERE
	t.name = town_name);
	END;
$$

LANGUAGE plpgsql;

-- 02. Employees Promotion

CREATE OR REPLACE PROCEDURE sp_increase_salaries(department_name VARCHAR)
LANGUAGE plpgsql
AS 
$$
BEGIN
    UPDATE 
		employees AS e
    SET 
		salary = salary * 1.05
    FROM 
		departments AS d
    WHERE 
			e.department_id = d.department_id
        AND 
			d.name = department_name;
END;
$$;

CALL sp_increase_salaries('Finance')
