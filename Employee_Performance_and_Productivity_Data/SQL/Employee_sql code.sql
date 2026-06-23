CREATE DATABASE IF NOT EXISTS employee;
USE employee;

#Employees per each department
SELECT Department,
	   count(employee_ID) as Emp_per_department
FROM employee_performance
GROUP BY Department;

#Average performance score by department
SELECT Department,
	   avg(Performance_Score) as Avg_performance_score
FROM employee_performance
GROUP BY Department;

#Departments have the highest and lowest productivity
SELECT Department,
       AVG(Performance_Score) AS Avg_Productivity
FROM employee_performance
GROUP BY Department
ORDER BY Avg_Productivity DESC
LIMIT 1;

-- Lowest
SELECT Department,
       AVG(Performance_Score) AS Avg_Productivity
FROM employee_performance
GROUP BY Department
ORDER BY Avg_Productivity ASC
LIMIT 1;

#Average salary by department
SELECT Department,
	   round(avg(Monthly_Salary),2) as Avg_salary
FROM employee_performance
GROUP BY Department
ORDER BY Avg_salary DESC;

#Job roles have the highest average performance score
SELECT Job_Title,
	   round(avg(Performance_Score),2) as Avg_performance_score
FROM employee_performance
GROUP BY Job_Title
ORDER BY Avg_performance_score DESC;

#Top 10 employees based on performance score
SELECT Employee_ID,
       Department,
       Performance_Score
FROM employee_performance
ORDER BY Performance_Score DESC
LIMIT 10;

#Which employees have performance scores below company average
SELECT Employee_ID,
       Performance_Score
FROM employee_performance
WHERE Performance_Score < (
    SELECT AVG(Performance_Score)
    FROM employee_performance
);

#Does training hours impact performance
SELECT Training_Hours,
       ROUND(AVG(Performance_Score),2) AS Avg_Performance
FROM employee_performance
GROUP BY Training_Hours
ORDER BY Training_Hours;

#Do employees working overtime perform better
SELECT
    CASE
        WHEN Overtime_Hours = 0 THEN 'No Overtime'
        WHEN Overtime_Hours <= 10 THEN '1-10 Hours'
        WHEN Overtime_Hours <= 20 THEN '11-20 Hours'
        ELSE '20+ Hours'
    END AS Overtime_Group,
    ROUND(AVG(Performance_Score),2) AS Avg_Performance
FROM employee_performance
GROUP BY Overtime_Group;

#Which departments generate the most overtime hours
SELECT Department,
       sum(Overtime_Hours) as total_overtime_hours
FROM employee_performance
GROUP BY Department
ORDER BY total_overtime_hours DESC;

#Which departments have the highest salary expenditure
SELECT Department,
       SUM(Monthly_Salary) AS Total_Salary_Expenditure
FROM employee_performance
GROUP BY Department
ORDER BY Total_Salary_Expenditure DESC;

#What percentage of employees receive high performance ratings
SELECT
    COUNT(CASE WHEN Performance_Score >= 4 THEN 1 END) AS High_Performers,
    COUNT(*) AS Total_Employees,
    ROUND(
        COUNT(CASE WHEN Performance_Score >= 4 THEN 1 END) * 100.0 / COUNT(*),
        2
    ) AS High_Performance_Percentage
FROM employee_performance;


#Which departments have high overtime but low performance
SELECT Department,
       SUM(Overtime_Hours) AS Total_Overtime,
       ROUND(AVG(Performance_Score),2) AS Avg_Performance
FROM employee_performance
GROUP BY Department
ORDER BY Total_Overtime DESC,
         Avg_Performance ASC;
         
#Identify employees with high salary but below-average performance.
SELECT Employee_ID,
       Monthly_Salary,
       Performance_Score
FROM employee_performance
WHERE Performance_Score < (
    SELECT AVG(Performance_Score)
    FROM employee_performance
)
ORDER BY Monthly_Salary DESC;

#Which departments have the highest resignation rate
SELECT Department,
       COUNT(*) AS Total_Employees,
       COUNT(CASE WHEN Resigned = 'TRUE' THEN 1 END) AS Resigned_Employees
FROM employee_performance
GROUP BY Department;

#Is employee satisfaction related to resignation
SELECT Resigned,
       COUNT(*) AS Employees,
       ROUND(AVG(Employee_Satisfaction_Score),2) AS Avg_Satisfaction
FROM employee_performance
GROUP BY Resigned;

#Find employees at risk:Conditions:Low Satisfaction ,High Overtime,Low Performance
SELECT Employee_ID,
       Department,
       Employee_Satisfaction_Score,
       Overtime_Hours,
       Performance_Score
FROM employee_performance
WHERE Employee_Satisfaction_Score < (
          SELECT AVG(Employee_Satisfaction_Score)
          FROM employee_performance
      )
  AND Overtime_Hours > (
          SELECT AVG(Overtime_Hours)
          FROM employee_performance
      )
  AND Performance_Score < (
          SELECT AVG(Performance_Score)
          FROM employee_performance
      );

#Which manager/team needs immediate intervention
SELECT Department,
       ROUND(AVG(Performance_Score),2) AS Avg_Performance,
       ROUND(AVG(Employee_Satisfaction_Score),2) AS Avg_Satisfaction,
       ROUND(AVG(Overtime_Hours),2) AS Avg_Overtime
FROM employee_performance
GROUP BY Department
ORDER BY Avg_Performance ASC,
         Avg_Satisfaction ASC,
         Avg_Overtime DESC;