--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
    product,
    year,
    ROUND(AVG(avg_price)::NUMERIC, 2) AS avg_price,
    ROUND(AVG(average_salary)::NUMERIC, 2) AS avg_salary,
    ROUND(AVG(average_salary) / AVG(avg_price), 2) AS quantity_affordable
FROM t_tereza_dostalikova_project_sql_primary_final
WHERE year IN (2006, 2018) and product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY product, year
ORDER BY product, year;
