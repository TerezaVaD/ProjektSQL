--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

WITH price_growth AS (
    SELECT
        product,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY product ORDER BY year) AS prev_price
    FROM t_tereza_dostalikova_project_sql_primary_final
),
percentage_growth AS (
    SELECT
        product,
        year,
        avg_price,
        prev_price,
        CASE 
            WHEN prev_price > 0 THEN ROUND(((avg_price - prev_price) / prev_price) * 100, 2)
            ELSE NULL
        END AS percent_growth
    FROM price_growth
    WHERE prev_price IS NOT NULL
),
average_growth_per_product AS (
    SELECT
        product,
        ROUND(AVG(percent_growth), 2) AS avg_percent_growth
    FROM percentage_growth
    GROUP BY product
)
SELECT *
FROM average_growth_per_product
ORDER BY avg_percent_growth ASC
--LIMIT 1;
