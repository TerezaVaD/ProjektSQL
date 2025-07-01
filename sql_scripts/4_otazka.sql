--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH yearly_averages AS (
    SELECT
        year,
        ROUND(AVG(avg_price)::numeric, 2) AS avg_price,
        ROUND(AVG(average_salary)::numeric, 2) AS avg_salary
    FROM t_tereza_dostalikova_project_sql_primary_final
    GROUP BY year
),
growths AS (
    SELECT
        year,
        avg_price,
        avg_salary,
        LAG(avg_price) OVER (ORDER BY year) AS prev_price,
        LAG(avg_salary) OVER (ORDER BY year) AS prev_salary
    FROM yearly_averages
),
percent_growths AS (
    SELECT
        year,
        avg_price,
        avg_salary,
        ROUND(((avg_price - prev_price) / prev_price) * 100, 2) AS price_growth_percent,
        ROUND(((avg_salary - prev_salary) / prev_salary) * 100, 2) AS salary_growth_percent
    FROM growths
    WHERE prev_price IS NOT NULL AND prev_salary IS NOT NULL
),
differences AS (
    SELECT
        year,
        price_growth_percent,
        salary_growth_percent,
        price_growth_percent - salary_growth_percent AS difference
    FROM percent_growths
)
SELECT *
FROM differences
--WHERE difference > 10
ORDER BY difference DESC;
