-- 1. False
	SELECT last_name, job_id, salary as Sal
	FROM HR.EMPLOYEES;

-- 2. False
	-- No Table Named job_grades

-- 3. Corrected Code: 
	SELECT employee_id, last_name, SALARY *12 AS "ANNUAL SALARY"
	FROM HR.employees;

-- 4. Command: 
DESCRIBE HR.DEPARTMENTS;


-- Name            Null?    Type         
-- --------------- -------- ------------ 
-- DEPARTMENT_ID   NOT NULL NUMBER(4)    
-- DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
-- MANAGER_ID               NUMBER(6)    
-- LOCATION_ID              NUMBER(4)    

-- Command: 
SELECT * FROM HR.DEPARTMENTS;

-- 5. Command: 
SELECT EMPLOYEE_ID, LAST_NAME, JOB_ID, HIRE_DATE AS "STARTDATE"
FROM HR.EMPLOYEES;

-- 6. 





-- 7. Command:
SELECT DISTINCT JOB_ID
FROM HR.EMPLOYEES;

-- 8. Command:
SELECT EMPLOYEE_ID AS "Emp #", LAST_NAME AS "Employee", JOB_ID as "Job", HIRE_DATE AS "Hire Date"
FROM HR.EMPLOYEES;

-- 9. Command: 
SELECT LAST_NAME || ', ' || JOB_ID AS "Employee and Title"
FROM HR.EMPLOYEES;

-- 10. Command:
SELECT EMPLOYEE_ID || ',' || FIRST_NAME || ',' || LAST_NAME || ',' || EMAIL ||  ',' || PHONE_NUMBER || ',' || JOB_ID || ',' || HIRE_DATE || ',' || SALARY || ',,' || DEPARTMENT_ID AS "THE_OUTPUT" 
FROM HR.EMPLOYEES; 