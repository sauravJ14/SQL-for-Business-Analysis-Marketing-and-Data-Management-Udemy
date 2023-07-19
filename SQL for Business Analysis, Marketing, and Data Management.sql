use employees;


SELECT 
    first_name, last_name
FROM
    employees;
SELECT 
    dept_no
FROM
    departments;
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis';
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' AND gender = 'F';
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie'
        OR first_name = 'Aruna';
SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');	
SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis' OR 'Elvis');
SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN (' John' , 'Mark', 'Jacob');


SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE 'mark%';
SELECT 
    *
FROM
    employees
WHERE
    hire_date LIKE '%2000%';
SELECT 
    *
FROM
    employees
WHERE
    emp_no LIKE '1000_';

-- Extract all individuals from the ‘employees’ table whose first name contains “Jack”.
SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE '%jack%';
-- e you have done that, extract another list containing the names of employees that do not contain “Jack”
select * from employees where first_name not like "%jack%";

-- Select all the information from the “salaries” table regarding contracts from 66,000 to cdollars per year.
select * from salaries where salary between '66000' and '70000';

-- Retrieve a list with all individuals whose employee number is not between ‘10004’ and ‘10012’.
select * from employees where emp_no not between '10004' and '10012';

-- Select the names of all departments with numbers between ‘d003’ and ‘d006’.
select 	dept_name from departments where dept_no between 'd003' and 'd006';

-- Select the names of all departments whose department number value is not null.
select dept_name from departments where dept_no is not null;

-- Retrieve a list with data about all female employees who were hired in the year 2000 or after.
select * from employees where hire_date>'2000-01-01' and gender='F';
-- Hint: If you solve the task correctly, SQL should return 7 rows.

-- Extract a list with all employees’ salaries higher than $150,000 per annum.
select * from salaries where salary>'150,000';

-- Obtain a list with all different “hire dates” from the “employees” table.
select distinct hire_date from employees;
-- How many annual contracts with a value higher than or equal to $100,000 have been registered in the salaries table?
select count(*) from salaries where salary>'100,000';
-- How many managers do we have in the “employees” database? Use the star symbol (*) in your code to solve this exercise.
select count(*) from dept_emp;
-- Select all data from the “employees” table, ordering it by “hire date” in descending order.
select * from employees order by hire_date;
-- Write a query that obtains two columns. The first column must contain annual salaries higher than 80,000 dollars. The second column, renamed to “emps_with_same_salary”, must show the number of employees contracted to that salary. Lastly, sort the output by the first column
-- select * from salaries;
SELECT 
    salary, COUNT(emp_no) AS emps_with_same_salary
FROM
    salaries
WHERE
    salary > 80000
GROUP BY salary
ORDER BY salary;
-- Select all employees whose average salary is higher than $120,000 per annum.
SELECT emp_no, AVG(salary) FROM salaries GROUP BY emp_no HAVING AVG(salary) > 120000 order by emp_no;
select * from departments;
SELECT IFNULL(dept_no, 'N/A') as dept_no, IFNULL(dept_name,'Department name not provided') FROM departments ORDER BY dept_no ASC;
-- (emp_no – integer of 11, not null; dept_no – CHAR of 4, null; manager_no – integer of 11, not null). 

drop table if exists emp_manager;CREATE TABLE emp_manager (
    7emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

select * from salaries;

CREATE OR REPLACE VIEW sdf AS
    SELECT 
       round(AVG(salary),2)
    FROM
        salaries s
            JOIN
        dept_manager m ON s.emp_no = m.emp_no;


DELIMITER $$
create procedure select_employee()
begin 
select*from departments;
end$$
select_employee
delimiter ;

call select_employee;

-- Create a procedure that will provide the average salary of all employees.

DELIMITER !!
create procedure avgg_salary(in p_emp_no int)
begin 
select salary from salaries s
JOIN emp_manager e on emp_managers.emp_no=e.emp_no;
end!!
delimiter ;

call avg_salary;

-- Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.

DELIMITER $$

CREATE PROCEDURE emp_infopo(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
SELECT
 e.emp_no INTO p_emp_no FROM  employees e WHERE e.first_name = p_first_name AND e.last_name = p_last_name;
END$$

DELIMITER ;



select * from employees limit 10;

-- Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.Finally, select the obtained output.

 set @v_emp_no=0;
 call employees.emp_infopo('Aruna','Journel',@v_emp_no);
 select @v_emp_no;


select * from departments;
select * from dept_emp;


-- Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary from the newest contract of that employee.
delimiter ##
create function f_emp_info (p_first_name varchar (255),p_last_name varchar(255))RETURNS decimal (10,2)
DETERMINISTIC NO SQL READS SQL DATA
begin	
declare v_max_from_date date;
declare v_salary decimal (10,2);
select MAX(from_date)
into v_max_from_date from employees e join salaries s on e.emp_no=s.emp_no where e.first_name=p_first_name and e.last_name=p_last_name;
select s.salary into v_salary from employees e join salaries s on e.emp_no=s.emp_no where e.first_name=p_first_name and e.last_name=p_last_name;
 return v_salary;
    RETURN v_salary;
end ##
delimiter ;

select f_emp_info('Aruna', 'Journel');
DROP FUNCTION IF EXISTS f_emp_info;


DELIMITER $$
create trigger check_date
before insert on employees
for each row
begin 
if new.hire_date>date_format(sysdate(),'%Y-%m-%d') THEN 
set new.hire_date=date_format(sysdate(), '%Y-%m-%d');
END IF;
end $$  
delimiter ;

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  
INSERT employees VALUES ('9999400', '1970-01-31', 'sayracc', 'Johnson', 'M', '2024-01-01');  

SELECT  

    *  

FROM  
employees
ORDER BY emp_no DESC;
-- Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum. Then, create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement.

select * from salaries where salary>89000;

create index i_salary on salaries(salary);

select e.emp_no, e.first_name, e.last_name,
case when dm.emp_no is not null then 'Manager'
else 'employee' end AS is_manager from employees e left join dept_manager dm on dm.emp_no=e.emp_no
where e.emp_no>10990;

-- Extract a dataset containing the following information about the managers: employee number, first name, and last name.
--  Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, and 
-- another one saying whether this salary raise was higher than $30,000 or 

select * from dept_emp limit 100; 

select e.first_name,e.last_name,
case when max(de.to_date)>sysdate() then 'is current emploted' else 'not employ' end as current_employee from employees e join dept_emp de on de.emp_no=e.emp_no group by de.emp_no limit 100;

select first_name,last_name,
case
when datediff(CURDATE(),hire_date)>365 then 'Junior Employee'
when datediff(CURDATE(),hire_date) between  365 and 1825 then 'Mid-level Employee'
when datediff(CURDATE(),hire_date)<1825 then 'Senior Employee'
end as employment_tenure
from employees;

-- Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department).

select emp_no,dept_no,row_number() over(order by emp_no) as row_num from dept_manager;

-- Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table.
--  Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).

select first_name,emp_no,row_number() over(partition by first_name) as sequential_number  from employees;

-- Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.
-- Use window functions to add the following two columns to the final output:
-- a column containing the row number of each row from the obtained dataset, starting from 1.
-- a column containing the sequential row numbers associated to the rows for each manager, where their highest salary has been given a number equal to the number of rows in the given partition, and their lowest - the number 1.
-- Finally, while presenting the output, make sure that the data has been ordered by the values in the first of the row number columns, and then by the salary values for each partition in ascending order.


SELECT

dm.emp_no,

    salary,

    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,

    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   

FROM

dept_manager dm

    JOIN 

    salaries s ON dm.emp_no = s.emp_no;
    
-- Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their first names and ordering each partition by their employee number in ascending order.


select *,row_number() over w as r FROM employees window w as (partition by  first_name order by emp_no asc);

-- Find out the lowest salary value each employee has ever signed a contract for. 
-- To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.

select a.emp_no, min(a.salary) as lowest from (select emp_no,salary, row_number() over w as row_num from salaries window w as (partition by emp_no order by salary)) a group by emp_no;

-- Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.Order and display the obtained salary values from highest to lowest.

select emp_no,salary, row_number() over w as row_num from salaries where emp_no=10560 window w as (partition by emp_no order by salary desc);

-- Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.

select dm.emp_no,count(salary) as signed_contract from dept_manager dm join	salaries s on dm.emp_no=s.emp_no group by emp_no order by emp_no;

-- Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for.
--  Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are allowed.
select emp_no, salary, rank() over(partition by emp_no order by salary) from salaries where emp_no=10560;

select emp_no,salary , dense_rank() over(partition by emp_no order by salary) from salaries where emp_no=10560;
-- Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive. 
-- Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.

select e.emp_no,s.salary,rank() over w as sal from salaries s join employees e on e.emp_no=s.emp_no
where e.emp_no between 10500 and 10600 window  w as (partition by e.emp_no order by s.salary desc) ;

select e.emp_no,s.salary,dense_rank() over w as sal ,(year(s.from_date) - year(e.hire_date)>=5) AS years_from_start  from salaries s join employees e on e.emp_no=s.emp_no 
AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5 where e.emp_no between 10500 and 10600 window  w as (partition by e.emp_no ORDER BY s.salary DESC) ;

select e.emp_no,DENSE_RANK() OVER w as employee_salary_ranking,s.salary,e.hire_date,s.from_date,(YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start FROM employees e JOIN salaries s ON s.emp_no = e.emp_no 
AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5 WHERE e.emp_no BETWEEN 10500 AND 10600 WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);


-- the salary values (in ascending order) of the contracts signed by all employees numbered between 10500 and 10600 inclusive
-- a column showing the previous salary from the given ordered list
-- a column showing the subsequent salary from the given ordered list
-- a column displaying the difference between the current salary of a certain employee and their previous salary
-- a column displaying the difference between the next salary of a certain employee and their current salary
-- Limit the output to salary values higher than $80,000 only.
-- Also, to obtain a meaningful result, partition the data by employee number.

select e.emp_no,salary,
lag(s.salary)over w as previvious_salary,
lead(s.salary) over w as subsequent_salary,
salary - lag(s.salary) over w as diffrencre,
lead(s.salary) over w - salary as diffrencre_to_new_salary 
from salaries s join employees e on s.emp_no=e.emp_no where e.emp_no between 10500 and 10600 and salary>80000 window w as (order by emp_no) ;

select e.emp_no,s.salary,
LAG(salary) OVER w AS previous_salary,
LAG(salary, 2) OVER w AS 1_before_previous_salary,
LEAD(salary) OVER w AS next_salary,
LEAD(salary, 2) OVER w AS 1_after_next_salary
from employees e join salaries s on s.emp_no=e.emp_no  window w as (order by emp_no) limit 1000;

select s.emp_no,s.salary,s.from_date,s.to_date from salaries s join (SELECT emp_no, MIN(from_date) AS from_date FROM salaries GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no WHERE s.from_date = s1.from_date;

-- Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a query to find out how many male employees 
-- have never signed a contract with a salary value higher than or equal to the all-time company salary average.

with cte as (select avg(salary)as avg_salary from salaries)
select sum(case when s.salary<c.avg_salary then 1 else 0 end) AS no_salaries_below_avg,

COUNT(s.salary) AS no_of_salary_contracts

FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;

-- Use two common table expressions and a SUM() function in the SELECT statement of a query to obtain the number of male employees whose highest salaries have been below the all-time average.


-- Use two common table expressions and a COUNT() function in the SELECT statement of a query to obtain the number of male employees whose highest salaries have been below the all-time average.

with cte1 as (select avg(salary) from salaries),
cte2 as (select max(s.salary) as max_salary from salaries s join employees e on s.emp_no=e.emp_no where e.gender="M" group by s.emp_no)
select count(case when cte2<cte1 then 1 else 0 end) from cte2;
