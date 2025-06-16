/*
    Write a query to display the department ID and the average salary for 
    each department, but only show departments where the average salary
    is greater than $8,000. Order the results by average salary in descending order.
*/
SELECT DEPARTMENT_ID, AVG(SALARY)
FROM HR.EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 8000
ORDER BY AVG(SALARY) DESC;


/*
    Write a query to display the last name, job title, department name, and city for all
    employees who work in locations with a country_id of 'US'. Use appropriate joins.
*/

SELECT LAST_NAME, JOB_ID, DEPARTMENT_NAME, CITY
FROM HR.LOCATIONS JOIN HR.DEPARTMENTS
USING (LOCATION_ID)
JOIN HR.EMPLOYEES USING (DEPARTMENT_ID)
WHERE COUNTRY_ID = 'US';


/*
    Write a query using a subquery to find the names and hire dates of all employees
    who were hired after the employee with last name 'Davies', and who
    work in a department that has at least one employee with a last name
    containing the letter 'u'.
*/

SELECT LAST_NAME, HIRE_DATE
FROM HR.EMPLOYEES
WHERE HIRE_DATE > (
    SELECT HIRE_DATE
    FROM HR.EMPLOYEES
    WHERE LAST_NAME = 'Davies'
) AND DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID
    FROM HR.EMPLOYEES
    WHERE LOWER(LAST_NAME) LIKE '%u%'
);

SELECT JOB_ID, ROUND(AVG(SALARY),2)
FROM HR.EMPLOYEES
HAVING ROUND(AVG(SALARY),2) > 5000
GROUP BY (JOB_ID);

SELECT FIRST_NAME, LAST_NAME
FROM HR.EMPLOYEES JOIN HR.DEPARTMENTS
USING (DEPARTMENT_ID)
WHERE DEPARTMENT_NAME = 'IT';


SELECT e.EMPLOYEE_ID, e.LAST_NAME, e.SALARY, e.DEPARTMENT_ID
FROM HR.EMPLOYEES e
WHERE e.SALARY > (
    SELECT AVG(SALARY) 
    FROM HR.EMPLOYEES 
    WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
)
ORDER BY e.DEPARTMENT_ID, e.SALARY DESC;

SELECT d.DEPARTMENT_NAME, COUNT(e.EMPLOYEE_ID) AS "EMP#"
FROM HR.DEPARTMENTS d LEFT JOIN HR.EMPLOYEES e
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME;


SELECT last_name, job_id, salary
FROM hr.employees
ORDER BY SALARY DESC
FETCH FIRST 5 ROWS ONLY;

SELECT d.DEPARTMENT_NAME, COUNT(e.EMPLOYEE_ID) AS Hired
FROM HR.DEPARTMENTS d JOIN HR.EMPLOYEES e 
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE TO_CHAR(e.HIRE_DATE, 'YYYY') = '2012'
GROUP BY d.DEPARTMENT_NAME
ORDER BY Hired DESC
FETCH FIRST 3 ROWS ONLY;


-- Write a query to display the job ID and the average salary for each job where the average salary ranks in the top 3 among all jobs.

SELECT JOB_ID, AVG(SALARY)
FROM EMPLOYEES
GROUP BY JOB_ID
ORDER BY AVG(SALARY) DESC
FETCH FIRST 3 ROW ONLY;


-- Write a query to display the last name, salary, and job ID for all employees who have the same job as employee 'Abel'.

SELECT LAST_NAME, SALARY, JOB_ID
FROM EMPLOYEES 
WHERE JOB_ID = (
    SELECT JOB_ID
    FROM EMPLOYEES
    WHERE LAST_NAME = 'Abel'
) AND LAST_NAME <> 'Abel';


-- Write a query to display the department name and the lowest salary in each department. Only include departments where the lowest salary is greater than $5,000.

SELECT d.DEPARTMENT_NAME, MIN(e.SALARY) Mini
FROM EMPLOYEES e JOIN DEPARTMENTS d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY (d.DEPARTMENT_NAME)
HAVING Mini > 5000
ORDER BY Mini;

-- Write a query to display the employee's last name and hire date for all employees who were hired before their managers, along with their manager's last name and hire date.

SELECT e.LAST_NAME, e.HIRE_DATE, m.LAST_NAME, m.HIRE_DATE
FROM HR.EMPLOYEES e JOIN HR.EMPLOYEES m
ON e.MANAGER_ID = m.EMPLOYEE_ID
WHERE e.HIRE_DATE < m.HIRE_DATE;


-- Write a query to count the number of employees in each department who earn more than $8,000. Display the department name and the count.

SELECT d.DEPARTMENT_NAME, COUNT(e.EMPLOYEE_ID)
FROM EMPLOYEES e JOIN DEPARTMENTS d 
USING (DEPARTMENT_ID)
WHERE e.SALARY > 8000
GROUP BY d.DEPARTMENT_NAME;

-- Write a query to display the job ID and the average salary for all jobs with an average salary between $6,000 and $10,000.
SELECT JOB_ID, AVG(SALARY)
FROM HR.EMPLOYEES
HAVING AVG(SALARY) BETWEEN 6000 AND 10000
GROUP BY JOB_ID
ORDER BY AVG(SALARY);


-- **** Write a query to display each department's name, manager's last name, and the number of employees in that department.


SELECT d.DEPARTMENT_NAME, 
       m.LAST_NAME AS MANAGER, 
       COUNT(e.EMPLOYEE_ID) AS EMPLOYEE_COUNT
FROM HR.DEPARTMENTS d
LEFT JOIN HR.EMPLOYEES m ON d.MANAGER_ID = m.EMPLOYEE_ID
LEFT JOIN HR.EMPLOYEES e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME, m.LAST_NAME
ORDER BY EMPLOYEE_COUNT DESC;


-- Write a query to find employees who earn more than any employee in department 30. Display their last name, department ID, and salary.
SELECT LAST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE SALARY > ALL(
    SELECT SALARY
    FROM HR.EMPLOYEES 
    WHERE DEPARTMENT_ID = 30
);



-- Write a query to display the department name, location ID, and number of employees for all departments. Sort the results by the number of employees in descending order.

SELECT d.DEPARTMENT_NAME, d.LOCATION_ID, COUNT(e.EMPLOYEE_ID)
FROM HR.DEPARTMENTS d JOIN HR.EMPLOYEES e
ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME, d.LOCATION_ID
ORDER BY COUNT(e.EMPLOYEE_ID) DESC;


-- Write a query to display the department name, manager's last name, city, and country for all departments.

SELECT d.DEPARTMENT_NAME, e.LAST_NAME, l.CITY, c.COUNTRY_NAME
FROM HR.DEPARTMENTS d LEFT JOIN HR.EMPLOYEES e 
ON  d.MANAGER_ID = e.EMPLOYEE_ID
JOIN HR.LOCATIONS l 
ON d.LOCATION_ID = l.LOCATION_ID
JOIN HR.COUNTRIES c 
ON l.COUNTRY_ID = c.COUNTRY_ID
ORDER BY d.DEPARTMENT_NAME;



-- Write a query to display the average, minimum, and maximum salaries for each job title

SELECT j.JOB_TITLE, AVG(e.SALARY), MAX(e.SALARY), MIN(e.SALARY)
FROM HR.JOBS j JOIN HR.EMPLOYEES e
ON j.JOB_ID = e.JOB_ID
GROUP BY j.JOB_TITLE;