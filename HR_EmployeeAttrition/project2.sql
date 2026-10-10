create database Emp_Attrition;
use Emp_Attrition;
select * from hrclean;
alter table hrclean drop column myunknowncolumn;
select count(*) from hrclean;

-- 1. Display the first 10 rows from the table.
select * from hrclean limit 10;

-- 2. Find the total number of employees in the company.
select distinct(EmployeeCount) from hrclean;
select count(*) as Total_employee_count from hrclean;

-- 3. List all unique departments.
select distinct(department) as Unique_Dept from hrclean;

-- 4. Show how many employees have left the company and how many are still working.
select 
	sum(case when Attrition = 'Yes' then 1 end) as Working,
    sum(case when Attrition = 'No' then 1 end) as Leaved
    from hrclean;
    
-- 5. Retrieve the list of employees who work overtime.
select * from hrclean where OverTime = 'Yes';

-- 6. Find the average monthly income of all employees.
select round(avg(MonthlyIncome),2) as Avg_Income from hrclean;

-- 7. Identify employees whose number of companies worked is missing (NULL).
select EmployeeNumber,Gender,Department from hrclean where NumCompaniesWorked =NULL;

-- 8. Find the employee(s) with the maximum monthly income.
SELECT 
    employeenumber,
    department, 
    monthlyincome AS max_salary
FROM hrclean
WHERE monthlyincome = (
    SELECT MAX(monthlyincome) 
    FROM hrclean
);
-- department wise
SELECT 
    employeenumber,
    department, 
    monthlyincome AS max_salary
FROM hrclean h1
WHERE monthlyincome = (
    SELECT MAX(monthlyincome)
    FROM hrclean h2
    WHERE h2.department = h1.department
);


-- 9. Count the number of employees by gender.
select count(*) as Emp_Count, Gender from hrclean group by gender;

-- 10. List all employees who have just joined (YearsAtCompany = 0).
select * from hrclean where YearsAtCompany =0;

-- 11. Calculate the attrition rate (%) by department.
select
	department,
	round(sum(case when attrition='Yes' then 1 else 0 end)/count(*)*100,2) as Attrition_Rate
    from hrclean
    group by department;

-- 12. List the top 10 employees with the highest total working years.
select * from hrclean order by totalworkingyears desc limit 10;

-- 13. Group employees into tenure categories (<1yr, 1–3yr, 4–6yr, 7+yr) and count employees in each.
SELECT 
    CASE 
        WHEN yearsatcompany < 1 THEN '<1yr'
        WHEN yearsatcompany BETWEEN 1 AND 3 THEN '1–3yr'
        WHEN yearsatcompany BETWEEN 4 AND 6 THEN '4–6yr'
        ELSE '7+yr'
    END AS tenure_category,
    COUNT(*) AS employee_count
FROM hrclean
GROUP BY 
    CASE 
        WHEN yearsatcompany < 1 THEN '<1yr'
        WHEN yearsatcompany BETWEEN 1 AND 3 THEN '1–3yr'
        WHEN yearsatcompany BETWEEN 4 AND 6 THEN '4–6yr'
        ELSE '7+yr'
    END
ORDER BY 
    MIN(yearsatcompany);
    
    
-- 14. Find the average monthly income by job level and attrition status.
select distinct(joblevel) from hrclean;
SELECT 
    attrition,
    joblevel,
    ROUND(AVG(monthlyincome), 2) AS avg_income
FROM hrclean
GROUP BY 
    attrition,
    joblevel
ORDER BY 
    attrition,
    joblevel;

-- 15. Identify the top 5 job roles with the highest number of employees who left.
select jobrole, count(*) as emp_count from hrclean group by jobrole order by emp_count desc limit 5;

-- 16. List employees who left the company within their first year.
select employeeNumber, YearsAtCompany from hrclean where YearsAtCompany<=1;

-- 17. Calculate each employee’s approximate new monthly compensation after applying their salary hike percentage.
SELECT 
    employeenumber,
    monthlyincome AS current_monthly_income,
    percentsalaryhike,
    ROUND(monthlyincome * (1 + percentsalaryhike / 100.0), 2) AS new_monthly_income,
    ROUND(monthlyincome * (percentsalaryhike / 100.0), 2) AS hike_amount
FROM hrclean;

-- 18. Count employees grouped by overtime status and attrition.
select attrition,overtime,count(*) as emp_count from hrclean group by overtime,attrition;

-- 19. Display the top 10 employees who attended the most training sessions last year.
select employeenumber, TrainingTimesLastYear  from hrclean order by TrainingTimesLastYear desc limit 10;

-- 20. Rank employees by total working years (most experienced = rank 1).
select employeenumber,totalworkingyears, dense_rank() over( order by totalworkingyears desc) as experience_rank from hrclean;

-- 21. For each department, find employees whose monthly income is in the top 25% of that department.

SELECT department,
       employeenumber,
       monthlyincome,
       dense_rank() over(partition by department order by MonthlyIncome desc)
FROM (
    SELECT department,
           employeenumber,
           monthlyincome,
           NTILE(4) OVER (
               PARTITION BY department
               ORDER BY monthlyincome DESC
           ) AS quartile
    FROM hrclean
) AS t
WHERE quartile = 1;
    

-- 22. Divide employees into 10 income deciles and find attrition rate for each decile.
SELECT 
    sub.income_decile,
    MIN(sub.MonthlyIncome) AS min_monthly_income,
    MAX(sub.MonthlyIncome) AS max_monthly_income,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN sub.Attrition = 'Yes' THEN 1 ELSE 0 END) AS leavers,
    ROUND(100.0 * SUM(CASE WHEN sub.Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM (
    SELECT 
        EmployeeNumber,
        MonthlyIncome,
        Attrition,
        NTILE(10) OVER (ORDER BY MonthlyIncome ASC) AS income_decile
    FROM HRClean
) sub
GROUP BY sub.income_decile
ORDER BY sub.income_decile ASC;

-- 23. Create a simple risk score based on tenure, performance, overtime, and work-life balance — and list the top 50 high-risk employees.
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    YearsAtCompany,
    PerformanceRating,
    OverTime,
    WorkLifeBalance,
    MonthlyIncome,
    (
        -- OverTime Risk (3 pts)
        (CASE WHEN OverTime = 'Yes' THEN 3 ELSE 0 END) +

        -- Work-Life Balance Risk (Up to 3 pts)
        (CASE 
            WHEN WorkLifeBalance = 1 THEN 3
            WHEN WorkLifeBalance = 2 THEN 2
            WHEN WorkLifeBalance = 3 THEN 1
            ELSE 0 
         END) +

        -- Short Tenure Risk (Up to 2 pts)
        (CASE 
            WHEN YearsAtCompany <= 2 THEN 2
            WHEN YearsAtCompany <= 5 THEN 1
            ELSE 0 
         END) +

        -- High Performer Flight Risk (2 pts for top rating)
        (CASE 
            WHEN PerformanceRating = 4 THEN 2
            ELSE 1 
         END)
    ) AS risk_score
FROM HRClean
WHERE Attrition = 'No'
ORDER BY 
    risk_score DESC,
    YearsAtCompany ASC,
    MonthlyIncome ASC
LIMIT 50;

-- 24. Create a summary view showing, for each department and job level: total employees, number of leavers, attrition rate, and average monthly income.
CREATE VIEW summary AS
SELECT 
    Department,
    JobLevel,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS number_of_leavers,
    ROUND(100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM HRClean
GROUP BY 
    Department, 
    JobLevel;
SELECT *  FROM summary ORDER BY Department ASC, JobLevel ASC;
    