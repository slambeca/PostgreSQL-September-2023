
00. Create Tables in hotel.db

CREATE TABLE departments (

	id serial PRIMARY KEY,
	
	name VARCHAR(50)

);



INSERT INTO departments(name)

VALUES

('Front Office'), ('Support'), ('Kitchen'), ('Other');



CREATE TABLE employees (

	id serial PRIMARY KEY,

	first_name VARCHAR(50) NOT NULL,

	last_name VARCHAR(50) NOT NULL,

	job_title VARCHAR(50) NOT NULL,

	department_id INT NOT NULL,

	salary double precision NOT NULL
	

);



INSERT INTO employees (first_name, last_name, job_title, department_id, salary) 

VALUES
	
	('John', 'Smith', 'Manager',1, 900.00),
	
	('John', 'Johnson', 'Customer Service',2, 880.00),
	
	('Smith', 'Johnson', 'Porter', 4, 1100.00),
	
	('Peter', 'Petrov', 'Front Desk Clerk', 1, 1100.00),
	
	('Peter', 'Ivanov', 'Sales', 2, 1500.23),
	
	('Ivan' ,'Petrov', 'Waiter', 3, 990.00),
	
	('Jack', 'Jackson', 'Executive Chef', 3, 1800.00),
	
	('Pedro', 'Petrov', 'Front Desk Supervisor', 1, 2100.00),
	
	('Nikolay', 'Ivanov', 'Housekeeping', 4, 1600.00);
	

	


CREATE TABLE rooms (

	id serial PRIMARY KEY,
	
	"type" VARCHAR(30)

);



INSERT INTO rooms("type") VALUES('apartment'), ('single room');



CREATE TABLE clients (

	id serial PRIMARY KEY,
	
	first_name VARCHAR(50),
	
	last_name VARCHAR(50),
	
	room_id INT NOT NULL

);


INSERT INTO clients(first_name, last_name, room_id) 

VALUES

	('Pesho','Petrov', 1),
	
('Gosho','Georgiev', 2),
	
('Mariya','Marieva', 28), 
	
('Katya','Katerinova', 12), 
	
('Nikolay','Nikolaev', 29), 
	
('Kate',NULL, 21),
	
('Steven',NULL, 15),
	
('Christo',NULL, 17);



CREATE TABLE projects (
	
	id serial PRIMARY KEY,
	
	name VARCHAR(50),
		start_date DATE
);



CREATE TABLE towns (

	id serial PRIMARY KEY,
	
	name VARCHAR(50)	

);




01. Select Employee Information

SELECT id, first_name|| ' ' || last_name as "Full Name", job_title as "Job Title" from employees;

02. Select Employees by Filtering

SELECT id, first_name|| ' ' || last_name as "full_name", job_title, salary from employees
WHERE salary > 1000.00
ORDER BY id ASC;

03. Select Employees by Multiple Filters

SELECT id, first_name, last_name, job_title, department_id, salary FROM employees
WHERE department_id = 4 AND salary >= 1000
ORDER BY id ASC;

04. Insert Data into Employees Table

INSERT INTO employees
(first_name, last_name, job_title, department_id, salary)
VALUES
('Samantha', 'Young', 'Housekeeping', 4, 900),
('Roger', 'Palmer', 'Waiter', 3, 928.33);

SELECT * FROM employees;

05. Update Salary and Select

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT * FROM employees WHERE job_title = 'Manager';

06. Delete from Table

DELETE FROM employees
WHERE department_id IN (1, 2);

SELECT * FROM employees
ORDER BY id ASC; 

07. Top Paid Employee View 

CREATE VIEW all_employees_new AS SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT * FROM all_employees_new;