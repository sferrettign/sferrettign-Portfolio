/*
SELECT *
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'



        --- Identify which factors most affect data science salaries
				--- Se me ocurrio separarlo por estudios, industria y tamaño de empresa.
				--- (ya que en la pregunta de mas abajo piden por states y cities.  
        ---Determine which states and cities offer the highest paying data science jobs
		 
        --- Predict what a data science job posting will pay based on the job description



Select TOP 25 job_title, industry, sector,avg_salary, python_yn, r_yn, spark, aws, excel
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
ORDER BY avg_salary DESC



--- Aqui se demostro que de los 25 mejores pagados 17 SI y 8 NO / saben Python.
--- 

SELECT Python_yn,
       AVG(avg_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY Python_yn

--- 115,84 es el promedio de sueldo de gente que NO sabe Python.
--- 118,06 es el promedio de sueldo de gente que SI sabe Python.  Python > No Python

--- Ahora veremos si la industria afecta.

SELECT TOP 5 Industry, AVG(avg_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY Industry
ORDER BY average_salary DESC

SELECT Industry,  AVG(avg_Salary) AS AverageSalary,
       COUNT(*) AS NumJobs
FROM salary
GROUP BY Industry
ORDER BY AverageSalary DESC

SELECT Industry, AVG(avg_salary) AS AverageSalary,
    COUNT(*) AS NumJobs,
    (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM salary WHERE Job_Title LIKE '%Data Scientist%')) AS Percentage
FROM salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY Industry
ORDER BY NumJobs DESC

--- Aqui se puede ver que el top 5 de industrias con mejor pago son:
--- 1.- Other Retail Stores = 163,5 
--- 2.- Financial Analytics & Research = 145, 125
--- 3.- Enterprise Software & Network Solutions = 144,86
--- 4.- Financial Transaction Processing = 139,5
--- 5.- Health, Beauty, & Fitness = 131,5

--- Ahora Ciudades y Estados. Primero debemos separara las ciudades del estado pq vienen EX: (Alburquerque, NM)

SELECT TOP 5 Size, AVG(avg_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY Size
ORDER BY average_salary DESC

SELECT TOP 5 Size, AVG(max_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY Size
ORDER BY average_salary DESC

SELECT Size, AVG(avg_salary) AS AverageSalary,
    COUNT(*) AS NumJobs,
    (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM salary WHERE Job_Title LIKE '%Data Scientist%')) AS PercentageOfTotal
FROM salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY Size
ORDER BY NumJobs DESC

SELECT Size,  AVG(avg_Salary) AS AverageSalary,
       COUNT(*) AS NumJobs
FROM salary
GROUP BY Size
ORDER BY AverageSalary DESC

--- Se puede ver que las empresas mas pequeñas son las que mas pagan. Esto debe ser a que al tener 
--- Menos empleados se necesitan menos data sciencetists y estos tienen mayores responsabildiades.


--- 1.- Unknown = 140,16 
--- 2.- 51 to 200 = 127,38
--- 3.- 1 to 50 = 125,10
--- 4.- 10000+ = 124,20
--- 5.- 5001 to 10000 = 118,3

--- incluso lo confirmamos utilizando una Query que utiliza el MAX salary.

--- 1.- Unknown = 155 
--- 2.- 51 to 200 = 155
--- 3.- 1 to 50 = 153
--- 4.- 10000+ = 153
--- 5.- 5001 to 10000 = 146

SELECT
PARSENAME(REPLACE(Location, ',', '.'), 2)
FROM portfolioproject.dbo.salary
SELECT
PARSENAME(REPLACE(Location, ',', '.'), 1)
FROM portfolioproject.dbo.salary
 
Alter Table portfolioproject.dbo.salary
Add City Nvarchar(255)
Alter Table portfolioproject.dbo.salary
Add State Nvarchar(255)

Update portfolioproject.dbo.salary
SET City = PARSENAME(REPLACE(Location, ',', '.'), 2)
Update portfolioproject.dbo.salary
SET State = PARSENAME(REPLACE(Location, ',', '.'), 1)

ALTER TABLE portfolioproject.dbo.salary
DROP COLUMN State

SELECT *
FROM portfolioproject.dbo.salary


SELECT TOP 5 City, AVG(avg_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY City
ORDER BY average_salary DESC

SELECT TOP 5 City, Sum(avg_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY City
ORDER BY average_salary DESC

SELECT City,  AVG(avg_Salary) AS AverageSalary,
       COUNT(*) AS NumJobs
FROM salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY City
ORDER BY AverageSalary DESC


SELECT City, AVG(avg_salary) AS AverageSalary,
    COUNT(*) AS NumJobs,
    (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM salary WHERE Job_Title LIKE '%Data Scientist%')) AS PercentageOfTotal
FROM salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY City
ORDER BY NumJobs DESC


SELECT Count(*)
FROM salary
WHERE Job_title LIKE '%Data Scientist%'

SELECT City, COUNT(*) AS NumJobs
FROM salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY City

SELECT SUM(NumJobs) AS TotalJobs
FROM (
    SELECT City, COUNT(*) AS NumJobs
    FROM salary
    WHERE Job_title LIKE '%Data Scientist%'
    GROUP BY City
) AS Subquery;

--- Top 5 Cities 
--- 1.- Bellevue = 184.5
--- 2.- 167
--- 3.- 164
--- 4.- 156.375
--- 5.- 155

SELECT TOP 5 State, AVG(avg_salary) AS average_salary
FROM portfolioproject.dbo.salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY State
ORDER BY average_salary DESC

SELECT State, AVG(avg_salary) AS AverageSalary,
    COUNT(*) AS NumJobs,
    (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM salary WHERE Job_Title LIKE '%Data Scientist%')) AS PercentageOfTotal
FROM salary
WHERE Job_title LIKE '%Data Scientist%'
GROUP BY State
ORDER BY NumJobs DESC

--- 1.- DC 149 
--- 2.- CA 142.5
--- 3.- UT 140.5
--- 4.- 127.666
--- 5.- 117.233
