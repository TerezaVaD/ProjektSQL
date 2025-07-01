CREATE TABLE t_tereza_dostalikova_project_SQL_primary_final AS
WITH payroll AS (
    SELECT 
        p.payroll_year AS year,
        pib.name AS industry,
        ROUND(AVG(p.value)::numeric, 2) AS average_salary
    FROM czechia_payroll p
    JOIN czechia_payroll_value_type vt ON p.value_type_code = vt.code
    JOIN czechia_payroll_industry_branch pib ON p.industry_branch_code = pib.code
    WHERE vt.code = '5958' -- průměrná hrubá mzda na přepočtené zaměstnance
    GROUP BY p.payroll_year, pib.name
),
prices AS (
    SELECT
        EXTRACT(YEAR FROM cp.date_from) AS year,
        cpc.name AS product,
        ROUND(AVG(cp.value)::numeric, 2) AS avg_price
    FROM czechia_price cp
    JOIN czechia_price_category cpc ON cp.category_code = cpc.code
    GROUP BY year, cpc.name
),
joined AS (
    SELECT 
        pr.year,
        pr.industry,
        pr.average_salary,
        prd.product,
        prd.avg_price,
        ROUND(pr.average_salary::numeric / prd.avg_price::numeric, 2) AS purchasable_amount
    FROM payroll pr
    JOIN prices prd ON pr.year = prd.year
)
SELECT * FROM joined;


