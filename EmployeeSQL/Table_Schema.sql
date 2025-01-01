-- DATA ENGINEERING:

-- Drop Tables
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS departments
;

-- Create Tables
CREATE TABLE departments(
dept_no VARCHAR PRIMARY KEY,
dept_name VARCHAR
);

CREATE TABLE titles(
title_id VARCHAR PRIMARY KEY,
title VARCHAR NOT NULL
);

CREATE TABLE employees(
emp_no INT PRIMARY KEY,
emp_title_id VARCHAR NOT NULL,
birth_date VARCHAR NOT NULL,
first_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
sex VARCHAR NOT NULL,
hire_date VARCHAR NOT NULL,
FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

-- Both dept_emp and dept_manager have two primary keys for a many-many relationship
CREATE TABLE dept_emp(
emp_no INT NOT NULL,
dept_no VARCHAR NOT NULL,
PRIMARY KEY (emp_no, dept_no),
FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager(
dept_no VARCHAR NOT NULL,
emp_no INT NOT NULL,
PRIMARY KEY (dept_no, emp_no),
FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE salaries(
emp_no INT PRIMARY KEY,
salary INT NOT NULL,
FOREIGN KEY(emp_no)REFERENCES employees(emp_no)
);

-- Check data import
SELECT * FROM departments;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;

-- DATA ANALYSIS: 

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
INNER JOIN salaries as s ON
s.emp_no = e.emp_no;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986';

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM dept_manager AS dm
JOIN departments AS d ON dm.dept_no = d.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT e.emp_no, e.first_name, e.last_name, de.dept_no, d.dept_name
FROM dept_emp AS de
JOIN departments AS d ON de.dept_no = d.dept_no
JOIN employees AS e ON de.emp_no = e.emp_no

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name='Hercules' AND last_name LIKE 'B%';

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
SELECT * FROM departments AS d;
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_no = 'd007';

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT * FROM departments;
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_no = 'd005' or d.dept_no = 'd007';

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "Frequency count"
FROM employees
GROUP BY last_name
ORDER BY "Frequency count" DESC;