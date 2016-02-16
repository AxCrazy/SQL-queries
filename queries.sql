#City & Guilds Module 7540 Unit 389 SQL Programming Assignment_A_V2

#1
/*
List the last name, first name and employee number of all programmers who
were hired on or before 21 May 1991 sorted in ascending order of last name.
*/
SELECT Last_Name, First_Name, Employee_No #, Hire_Date
	FROM EMPLOYEES
	WHERE Job_ID = "IT_PROG" AND Hire_Date <= '1991-05-21'
    ORDER BY Last_Name ASC;
#2
/*
List the department number, last name and salary of all employees who were
hired between 16/09/87 and 12/05/96 sorted in ascending order of
 last name within department number.
*/
SELECT Department_No, Last_Name, Annual_Salary
	FROM employees
    WHERE Hire_Date BETWEEN '1987-09-16' AND '1996-12-05'
    ORDER BY Department_No ASC, Last_Name ASC;
#3
/*
List all the data for all jobs where the maximum salary is greater than 15000
sorted in descending order of the maximum salary.
*/
SELECT * FROM jobs WHERE Max_Salary > 15000
	ORDER BY Max_Salary DESC;

#4
/*
List the last name, first name, job id and commission of employees who earn
commission sorted in ascending order of first name within last name.
*/
SELECT Last_Name, First_Name, Job_ID, Commission_Percent FROM employees
	WHERE Commission_Percent IS NOT NULL
    ORDER BY Last_Name ASC, First_Name ASC;

#5
/*
Which jobs are found in the IT and Sales departments?
*/
SELECT DISTINCT Job_ID FROM employees
	WHERE Department_No IN (50, 60);

#Or to show the actual Job Title, rather than the Job_ID
SELECT DISTINCT jobs.Job_Title FROM employees
    INNER JOIN (jobs) ON (jobs.Job_ID = employees.Job_ID)
	WHERE Department_No IN (50, 60);

#6
/*
List the last name of all employees in departments 50 and 90 together with their
monthly salaries (rounded to 2 decimal places), sorted in ascending order of last name.
*/
SELECT Last_Name, ROUND(Annual_Salary/12, 2) AS 'Monthly_Salary' FROM employees
	WHERE Department_No IN (50, 90)
    ORDER BY Last_Name ASC;

#7
/*
Show the total salaries figure for one month displayed with no decimal places.
*/
SELECT ROUND(SUM(Annual_Salary)/12,0) AS 'Monthly_Salary' FROM employees;

#8
/*
Show the total number of employees.
*/
SELECT COUNT(DISTINCT(Employee_No)) FROM employees;
#Don't need distinct here since Employee_No is Unique, but including it for clarity

#9
/*
List the department number, department name and the number of
employees for each department that has more than 2 employees grouping by
department number and department name.
*/
SELECT departments.Department_No, departments.Department_Name, COUNT(*) AS 'NUM EMPLOYEES'
	FROM departments
	INNER JOIN(employees) ON (departments.Department_No = employees.Department_No)
    GROUP BY departments.Department_No, departments.Department_Name
    HAVING COUNT(*) > 2;

#10
/*
List the department number, department name and the number of
employees for the department that has the highest number of employees
using appropriate grouping.
*/
SELECT employees.Department_No, departments.Department_Name, COUNT(*)
FROM   employees
#WHERE  Department_No IS Not NULL
INNER JOIN (departments) ON (departments.Department_No = employees.Department_No)
GROUP  BY employees.Department_No
ORDER  BY COUNT(*) DESC
LIMIT 1;

#11
/*
List the department number and name for all departments where no
programmers work.
*/
#Now you try...

SELECT departments.Department_No, departments.Department_Name 
FROM departments
WHERE departments.Department_No NOT IN (
	SELECT employees.Department_No
    FROM employees
    WHERE employees.Job_ID LIKE '%PROG'
);
    
#12

/*
Add the following new job IT_ANAL, System Analyst, 10000, 15000
*/

INSERT INTO Jobs(Job_ID, Job_Title, Min_Salary, Max_Salary)
VALUES('IT_ANAL', 'System Analyst', 10000, 15000);
SELECT * FROM Jobs;

#13

/*
Update all the maximum salaries for jobs with an increase of 1000.
*/

UPDATE Jobs
SET Max_Salary= Max_Salary+1000;
SELECT * FROM Jobs;

#14

/*
List all the data for jobs sorted in ascending order of job id.
*/

SELECT * FROM Jobs
ORDER BY Job_ID ASC;

#15

/*
15 a) The job history for employee number 102 is no longer required.
Delete this record.
b) List all the data for job history sorted in ascending order of
employee number.
*/

#a
DELETE FROM job_history
WHERE Employee_No = 102;
SELECT * from job_history;

#b
SELECT * from job_history
ORDER BY Employee_No ASC;

#16

/*
Produce a list of employees showing percentage raises, employee numbers and old and new salaries. 
Employees in departments 20 and 10 are given a 5% rise, employees in departments 50, 80, 90 and 110 are given a 10% rise and employees in other departments are not given a rise.
*/

SELECT ROUND(((Annual_Salary*1.05/Annual_Salary) -1)*100, 0) AS Percent_Raise, Employee_No, Annual_Salary AS Old_Salary, Annual_Salary*1.05 AS New_Salary
From employees
WHERE employees.Department_No IN (10,20)
UNION
SELECT ROUND(((Annual_Salary*1.1)/Annual_Salary -1)*100, 0) AS Percent_Raise, Employee_No, Annual_Salary AS Old_Salary, Annual_Salary*1.1 AS New_Salary
From employees
WHERE employees.Department_No IN (50,80,90,110)
UNION
SELECT ROUND(((Annual_Salary*1)/Annual_Salary -1)*100, 0) AS Percent_Raise, Employee_No, Annual_Salary AS Old_Salary, Annual_Salary*1 AS New_Salary
From employees
WHERE employees.Department_No NOT IN (50,80,90,110, 10, 20);



#17
/*
Create a new view for manager’s details only using all the fields from the
employee table. Apply a CHECK constraint.
*/

DROP VIEW IF EXISTS ManagersDetails;
CREATE OR REPLACE VIEW ManagersDetails AS
SELECT * FROM employees
WHERE Job_ID IN (SELECT Job_Id FROM jobs WHERE Job_Id LIKE '%MGR' )
#WHERE Job_ID LIKE '%MGR';
WITH CHECK OPTION; #Parsed but not supported by MySQL
SELECT * FROM ManagersDetails;

#18
/*
Show all the fields and all the managers using the view for managers sorted
in ascending order of employee number.
*/

SELECT * FROM ManagersDetails
ORDER BY Employee_No ASC;

#19
/*
Grant the authority to all other users to access the view for managers for
SELECT statements only.
*/

DROP USER IF EXISTS 'alan'@'localhost';
CREATE USER 'alan'@'localhost' IDENTIFIED BY 'passmysql';
GRANT SELECT ON ManagersDetails TO 'alan'@'localhost';

#20
/*
Create an index named LOC_POSTAL_CODE on the Postal Code in the
locations table.
Provide a printout showing that the index has been created.
*/

DROP INDEX LOC_POSTAL_CODE ON locations;
CREATE INDEX LOC_POSTAL_CODE On locations(Postal_Code);
SHOW INDEX FROM locations WHERE KEY_NAME = 'LOC_POSTAL_CODE';
