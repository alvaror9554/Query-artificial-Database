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

-- 6th Question: Find the top 5 employee account representatives whose assigened customers generated the highest
-- total transaction revenue


SELECT e.name as representative_name,
       d.department_name,
       COUNT(distinct(c.ID)) as manager_customers_count,
       SUM(t.net_amount) as total_revenue_generated
       

FROM transactions t
INNER JOIN customers c ON t.customer_id = c.ID
INNER JOIN employees e ON c.representative_id = e.ID
INNER JOIN departments d ON e.department_id = d.ID
GROUP BY e.name, d.department_name
ORDER by SUM(t.net_amount) DESC
LIMIT 5;

--7th Question: List all salary grades (ID,ties_description and full title) along with the count of active employees,
-- terminated employees and total employees asigned to each grade.
 
-- If we use count but in the case we use else 0, it will count the zero
-- So we have to be carefull.
SELECT s.id as grade_id,
       s.description as grade_tier,
       s.long_text as grade_title,
       COUNT(CASE WHEN e.status = 'Active' then 1 END) as active_count,
       COUNT(CASE WHEN e.status = 'Terminated' then 1 END) as terminated_count,
       COUNT(e.status) as total_employees
FROM employees e
INNER JOIN salary_grades s ON e.salary_grade_id = s.ID
GROUP BY s.id,s.description,s.long_text;

--8th Question: 
--In order to get decimals we have to multiply by 100.0 as a number wwith decimals and not as integer
SELECT CASE 
           WHEN e.hire_date between '1980-01-01' and '1990-01-01' then '1980s'
            WHEN e.hire_date between '1990-01-01' and '2000-01-01' then '1990s'
             WHEN e.hire_date between '2000-01-01' and '2010-01-01' then '2000s'
              WHEN e.hire_date between '2010-01-01' and '2020-01-01' then '2010s'
              WHEN e.hire_date between '2020-01-01' and '2030-01-01' then  '2020s'
              END as hire_decade,
       COUNT(*) as total_hired,
       COUNT(CASE WHEN e.status = 'Active' then 1 END) as active_employers,
      ROUND( 100.0*SUM(CASE WHEN e.status = 'Active' then 1 ELSE 0 END)/COUNT(*) ,2 ) as retention_rate_pc

FROM employees e
GROUP BY hire_decade
HAVING hire_decade not null;

-- 9th Question:For Customer ID = 1 (NVIDIA), list their first 6 transactions ordered by transaction ID. Display
--transaction ID, service type, transaction type, sales type, transaction net amount, and the running
--cumulative total amount spent up to that transaction.

select t.id,
       t.service_type,
       t.transaction_type,
       t.sales_type,
       t.net_amount,
       sum(t.net_amount) OVER(ORDER BY ID) as running_total_ammount
from transactions t
where t.customer_id = '1'
LIMIT 6;

-- 10th Question:Divide all 100 enterprise customers into 4 spending quartiles (where Quartile 1 contains the top
--25% highest spenders) based on their total transaction volume. Display the top 5 highest-spending
--companies in Quartile 1.


with temp_total_spent_id as (select t.customer_id,
       c.company_name,
       sum(t.net_amount) total_spent,
       NTILE(4) OVER (ORDER BY SUM(t.net_amount) DESC) AS spending_quartile
from transactions t 
INNER JOIN customers c ON t.customer_id = c.ID
GROUP BY t.customer_id, c.company_name)
SELECT t.customer_id,
       t.company_name,
       t.total_spent,
       t.spending_quartile
FROM temp_total_spent_id t
WHERE t.spending_quartile = 1
LIMIT 5;




