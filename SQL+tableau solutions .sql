use employees_mod;

-- Find the average salary of the male and female employees in each department. 
SELECT 
    AVG(s.salary), d.dept_no, e.gender
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_manager d ON s.emp_no = d.emp_no
GROUP BY d.dept_no , e.gender;

-- Find the lowest department number encountered in the 'dept_emp' table. Then, find the highest department number. 

select min(dept_no) as Lowest,max(dept_no) as Highest from t_dept_emp;

-- Obtain a table containing the following three fields for all individuals whose employee number is not greater than 10040: 
-- employee number
-- the lowest department number among the departments where the employee has worked in (Hint: use a subquery to retrieve this value from the 'dept_emp' table)
-- assign '110022' as 'manager' to all individuals whose employee number is lower than or equal to 10020,and '110039' to those whose number is between 10021 and 10040 inclusive. 

SELECT
    emp_no,
    (SELECT
            MIN(dept_no)
        FROM
            t_dept_emp de
        WHERE
            e.emp_no = de.emp_no) dept_no,
    CASE
        WHEN emp_no <= 10020 THEN '110022'
        ELSE '110039'
    END AS manager
FROM
    t_employees e
WHERE
    emp_no <= 10040;
    
    
-- Retrieve a list of all employees that have been hired in 2000. 

select * from t_employees where year(hire_date)=2000;

-- Retrieve a list of all employees from the ‘titles’ table who are engineers. 

select * from t_departments where dept_name like ('%engineer%');
select * from t_departments where dept_name like ('%senior engineer%');

-- Create a procedure that asks you to insert an employee number and that will obtain an output containing the same number, as well as the number and name of the last department the employee has worked in. 

DROP PROCEDURE IF EXISTS last_dept;

DELIMITER $$
CREATE PROCEDURE last_dept (in p_emp_no integer)
BEGIN
SELECT
    e.emp_no, d.dept_no, d.dept_name
FROM
    t_employees e
        JOIN
    t_dept_emp de ON e.emp_no = de.emp_no
        JOIN
    t_departments d ON de.dept_no = d.dept_no
WHERE
    e.emp_no = p_emp_no
        AND de.from_date = (SELECT
            MAX(from_date)
        FROM
            dept_emp
        WHERE
            emp_no = p_emp_no);
END$$
DELIMITER ;

call last_dept(10010);

-- How many contracts have been registered in the ‘salaries’ table with duration of more than one year and of value higher than or equal to $100,000? 

select count(*) from t_salaries  where salary>=100000 and  datediff(to_date,from_date)>365;

-- Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set the hire date to equal the current date. Format the output appropriately (YY-mm-dd). 
delimiter ##
create trigger check_hdate
before insert on t_employees 
for each row 
begin 
declare today date;
select date_format(sysdate(), '%Y-%m-%d') INTO today;
if new.hire_date>today then 
set new.hire_date=today;
end if;
end##
delimiter ;