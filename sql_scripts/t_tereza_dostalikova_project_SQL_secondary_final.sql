CREATE TABLE t_tereza_dostalikova_project_sql_secondary_final AS
SELECT 
    e.year,
    c.country,
    e.gdp,
    e.gini,
    e.population
FROM economies e
JOIN countries c ON e.country = c.country
WHERE 
    c.continent = 'Europe'
    AND e.year IN (
        SELECT DISTINCT year
        FROM t_tereza_dostalikova_project_sql_primary_final
    )
    AND e.gdp IS NOT NULL
    AND e.gini IS NOT NULL
    AND e.population IS NOT NULL;
