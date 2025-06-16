-- 1. Command
CREATE TABLE MY_EMPLOYEE(
    ID NUMBER(4) NOT NULL,
    LAST_NAME VARCHAR2(25),
    FIRST_NAME VARCHAR2(25),
    USERID VARCHAR2(8),
    SALARY NUMBER(9,2)
);

-- 2. Command
DESCRIBE MY_EMPLOYEE;

-- 3. Command
INSERT INTO MY_EMPLOYEE
VALUES (1,'Patel', 'Ralph', 'rpatel', 895);

-- 4. Command
INSERT INTO MY_EMPLOYEE (ID, LAST_NAME, FIRST_NAME, USERID, SALARY) 
VALUES (2, 'Dancs', 'Betty', 'bdancs', 860);

-- 5. Command
SELECT *
FROM MY_EMPLOYEE;

-- 6. Command
INSERT INTO MY_EMPLOYEE (SALARY, LAST_NAME, FIRST_NAME, USERID, ID) 
VALUES (1100, 'Biri', 'Ben', 'bbiri', 3);

INSERT INTO MY_EMPLOYEE (ID, LAST_NAME, FIRST_NAME, USERID, SALARY) 
VALUES (4, 'Newman', 'Chad', 'cnewman', 750);

-- 7. Procedure
-- EXECUTE the above script in VS Code Oracle SQL Developer

-- 8. Command
SELECT *
FROM MY_EMPLOYEE;

-- 9. Command
COMMIT;

-- 10. Command
UPDATE MY_EMPLOYEE
SET LAST_NAME = 'Drexler'
WHERE ID = 3;

-- 11. Command
UPDATE MY_EMPLOYEE
SET SALARY = 1000
WHERE SALARY < 900;

-- 12. Command
SELECT *
FROM MY_EMPLOYEE;

-- 13. Command
DELETE FROM MY_EMPLOYEE
WHERE ID = 3;

-- Alternative
DELETE FROM MY_EMPLOYEE 
WHERE FIRST_NAME = 'Betty' AND LAST_NAME = 'Dancs';

-- 14. Command
SELECT *
FROM MY_EMPLOYEE;

-- 15. Command
COMMIT;

-- 16. Command
INSERT ALL
    INTO MY_EMPLOYEE VALUES (4, 'Newman', 'Chad', 'cnewman', 750)
    INTO MY_EMPLOYEE VALUES (5, 'Ropeburn', 'Audrey', 'aropebur', 1550)
SELECT * FROM dual;

-- 17. Command
SELECT *
FROM MY_EMPLOYEE
ORDER BY ID;

-- 18. Command
SAVEPOINT all_inserted;

-- 19. Command
DELETE FROM MY_EMPLOYEE;

-- 20. Command
SELECT *
FROM MY_EMPLOYEE
ORDER BY ID;

-- 21. Command
ROLLBACK TO SAVEPOINT all_inserted;

-- 22. Command
SELECT *
FROM MY_EMPLOYEE
ORDER BY ID;

-- 23. Command
COMMIT;