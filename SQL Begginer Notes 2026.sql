# SELECT STATEMENTS
SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT first_name,
last_name,
gender,
age,
age + 10
FROM parks_and_recreation.employee_demographics;


SELECT distinct gender
FROM parks_and_recreation.employee_demographics;




# WHERE CLAUSE
SELECT *
FROM employee_salary
WHERE first_name = 'Leslie'
;

SELECT *
FROM employee_salary
WHERE salary <= 50000
;


SELECT *
FROM employee_demographics
WHERE gender != 'Female'
;


SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
AND gender = 'Male'
;

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR gender = 'Male'
;

SELECT *
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR NOT gender = 'Male'
;

SELECT *
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age = 44)
OR age > 55
;

# LIKE STATEMENTS: % and _
SELECT *
FROM employee_demographics
WHERE first_name LIKE '%a'
;

SELECT *
FROM employee_demographics
WHERE first_name LIKE 'a__%'
;


SELECT DISTINCT first_name, gender
FROM employee_demographics;



#GROUP BY /// ORDER BY

SELECT gender
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT *
FROM employee_demographics
ORDER BY gender, age
;


SELECT *
FROM employee_demographics
ORDER BY 5, 4 DESC
;


# HAVING STATEMENTS

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40
;


SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;



# LIMIT
SELECT *
FROM employee_demographics
ORDER BY age
LIMIT 3, 1;

# ALIASING

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;


###############################################################

#INNER JOIN

SELECT *
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;

SELECT dem.employee_id, age, occupation
FROM employee_demographics AS dem
INNER JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;


#OUTER JOING: LEFT JOIN // RIGHT JOIN

SELECT *
FROM employee_demographics AS dem
LEFT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;


SELECT *
FROM employee_demographics AS dem
RIGHT JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
    ;



# SELF JOIN

SELECT *
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;

SELECT emp1.employee_id AS secret_santa_id,
emp1.first_name AS santa_name,
emp1.last_name AS santa_last_name,
emp2.employee_id AS victim_id,
emp2.first_name AS victim_name,
emp2.last_name AS victim_last_name
FROM employee_salary AS emp1
JOIN employee_salary AS emp2
	ON emp1.employee_id + 1 = emp2.employee_id
;


SELECT *
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
JOIN parks_departments AS PD
	ON sal.dept_id = PD.department_id
;

#UNION
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;


SELECT first_name, last_name, 'Old' AS Label
FROM employee_demographics
WHERE age > 50;

SELECT *
FROM employee_demographics;


SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'
UNION
SELECT first_name, last_name, 'Money Makers' AS Label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name
;




#CASE STATEMENTS

SELECT first_name,
last_name,
age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Bracket
FROM employee_demographics
;

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary * 1.05
    WHEN salary > 50000 THEN salary * 1.07
END AS New_Salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary
;


#SUBQUERIES
SELECT *
FROM parks_departments;

SELECT *
FROM employee_demographics
WHERE employee_id in
				(SELECT employee_id
                FROM employee_salary
                WHERE dept_id = 1)
;



SELECT AVG(salary)
FROM employee_salary;


#WINDOW FUNCTIONS - similar to group by but it does not combine similar rows into one, keeps each row as individual but
# put them grouped together

#Group by example
SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;


#Window Function Example

SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;



SELECT dem.first_name, dem.last_name, gender, SUM(salary) OVER(PARTITION BY gender) AS Sum
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;



SELECT dem.first_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;



SELECT dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;


#Dense Rank
SELECT dem.employee_id, dem.first_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
;

# CTEs
SELECT gender, AVG(salary), MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;


SELECT gender, AVG(salary), MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
;


### CTE Example

WITH CTE_Example AS
(
SELECT gender, AVG(salary) AS avg_sal, MAX(salary) AS max_sal, MIN(salary) AS min_sal, COUNT(salary) AS count_sal
FROM employee_demographics AS dem
JOIN employee_salary AS sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;

### TEMP TABLES ###

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;





















