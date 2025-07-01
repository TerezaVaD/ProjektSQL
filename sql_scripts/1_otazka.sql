--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT
  tdp.industry,
  MIN(tdp.year) AS start_year,
  MAX(tdp.year) AS end_year,
  MIN(tdp.average_salary) AS start_salary,
  MAX(tdp.average_salary) AS end_salary,
  MAX(tdp.average_salary) - MIN(tdp.average_salary) AS diff
FROM t_tereza_dostalikova_project_sql_primary_final tdp
GROUP BY tdp.industry
ORDER BY diff;
