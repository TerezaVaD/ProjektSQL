--Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, 
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

WITH cz_data AS (
    SELECT 
        s.year,
        s.gdp,
        AVG(p.average_salary) AS avg_salary,
        AVG(p.avg_price) AS avg_price
    FROM t_tereza_dostalikova_project_sql_secondary_final s
    JOIN t_tereza_dostalikova_project_sql_primary_final p 
        ON s.year = p.year
    WHERE s.country = 'Czech Republic'
    GROUP BY s.year, s.gdp
),
growths AS (
    SELECT 
        year,
        gdp,
        avg_salary,
        avg_price,
        LAG(gdp) OVER (ORDER BY year) AS prev_gdp,
        LAG(avg_salary) OVER (ORDER BY year) AS prev_salary,
        LAG(avg_price) OVER (ORDER BY year) AS prev_price,
        LEAD(avg_salary) OVER (ORDER BY year) AS next_salary,
        LEAD(avg_price) OVER (ORDER BY year) AS next_price
    FROM cz_data
),
percent_changes AS (
    SELECT 
        year,
        ROUND((((gdp - prev_gdp) / prev_gdp) * 100)::numeric, 2) AS gdp_growth_pct,
        ROUND((((avg_salary - prev_salary) / prev_salary) * 100)::numeric, 2) AS salary_growth_pct,
        ROUND((((avg_price - prev_price) / prev_price) * 100)::numeric, 2) AS price_growth_pct,
        CASE 
            WHEN next_salary IS NOT NULL THEN ROUND((((next_salary - avg_salary) / avg_salary) * 100)::numeric, 2)
            ELSE NULL
        END AS next_salary_growth_pct,
        CASE 
            WHEN next_price IS NOT NULL THEN ROUND((((next_price - avg_price) / avg_price) * 100)::numeric, 2)
            ELSE NULL
        END AS next_price_growth_pct
    FROM growths
    WHERE prev_gdp IS NOT NULL  
)
SELECT *
FROM percent_changes
ORDER BY year;
