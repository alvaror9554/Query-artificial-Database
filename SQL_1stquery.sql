-- SQLite

--1st Question: Retrieving active employers and their  average salaries grouped by their pay tyepe
SELECT p.description  as pay_type,
       round(count(e.salary)) as active_employee_count,
       round(avg(e.salary)) as avg_salary
FROM employees e
LEFT JOIN pay_types p ON e.pay_type_id = p.ID
WHERE e.status = 'Active' -- In SQLite, double quotes are used for identifiers, single quotes for string literals
GROUP BY p.description
ORDER BY avg_salary DESC;

-- 2nd Question: Find all company departments that have at least 125 active employees 
-- For each deparment, output the department name, the number of active employees, the lowest salary, and the highest salary

SELECT d.department_name,
       count(e.salary) as active_employee_count,
       min(e.salary) as min_salary,
       max(e.salary) as max_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.ID
WHERE e.status = 'Active'
GROUP BY d.department_name
HAVING count(e.salary) >125
ORDER BY active_employee_count DESC;

-- 3rd Question: CTE's. Identify active employees whose salary exceeds the average salary of their respective department
-- Return the employee name, department name, employee salary, and the department average salary (Rounded 2 decimals)
-- Order by employee Salary in descending order and limit up to 5

-- First compute department average salaries
WITH avg_department_salary AS (
select d.ID,
       round(avg(e.salary),2) as avg_department_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.ID
GROUP BY d.ID
)
SELECT e.name as employee_name,
       d.department_name,
       e.salary,
       a.avg_department_salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.ID
LEFT JOIn avg_department_salary a ON e.department_id = a.ID 
WHERE e.salary > a.avg_department_salary
AND e.status = 'Active'
ORDER BY e.salary DESC   
LIMIT 5;

-- 4th Question: For each department, Find the top 2 highest pais employees.
with temporary_rank_salary as(
SELECT d.department_name,
       e.name as employee_name,
       e.salary,
       DENSE_RANK() OVER (PARTITION BY d.department_name ORDER BY e.salary DESC) as salary_rank
FROM employees e
LEFT JOIN departments d ON e.department_id = d.ID
WHERE e.status = 'Active')
SELECT t.department_name,
       t.employee_name,
       t.salary,
       t.salary_rank
FROM temporary_rank_salary t
WHERE t.salary_rank <= 2
LIMIT 10;

-- 5th Question: For each service_type in transactions, calculate the total revenue generated through 'Online' sales,
-- 'Phone' sales and the combined overall revenue

WITH temp_revenue_sales as (SELECT t.service_type,
       SUM(CASE WHEN t.sales_type = 'Online' then t.net_amount ELSE 0 END  ) as online_revenue,
       SUM(CASE WHEN t.sales_type = 'Phone' then t.net_amount ELSE 0 END  ) as phone_revenue,
       SUM(CASE WHEN t.sales_type in ('Online','Phone') then t.net_amount ELSE 0 END  ) as total_revenue
FROM transactions t
--WHERE t.transaction_type = 'Sale'
group by t.service_type)
SELECT ts.*
FROM temp_revenue_sales ts
ORDER BY ts.total_revenue DESC;







