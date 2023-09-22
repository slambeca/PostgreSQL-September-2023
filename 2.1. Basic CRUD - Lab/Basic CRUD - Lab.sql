-- 01. Select Employee Information

SELECT id, first_name|| ' ' || last_name as "Full Name", job_title as "Job Title" from employees;

-- 02. Select Employees by Filtering

SELECT id, first_name|| ' ' || last_name as "full_name", job_title, salary from employees
WHERE salary > 1000.00
ORDER BY id ASC;

-- 03. Select Employees by Multiple Filters

SELECT id, first_name, last_name, job_title, department_id, salary FROM employees
WHERE department_id = 4 AND salary >= 1000
ORDER BY id ASC;

-- 04. Insert Data into Employees Table

INSERT INTO employees
(first_name, last_name, job_title, department_id, salary)
VALUES
('Samantha', 'Young', 'Housekeeping', 4, 900),
('Roger', 'Palmer', 'Waiter', 3, 928.33);

SELECT * FROM employees;

-- 05. Update Salary and Select

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT * FROM employees WHERE job_title = 'Manager';

-- 06. Delete from Table

DELETE FROM employees
WHERE department_id IN (1, 2);

SELECT * FROM employees
ORDER BY id ASC; 

-- 07. Top Paid Employee View 

CREATE VIEW all_employees_new AS SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT * FROM all_employees_new;
