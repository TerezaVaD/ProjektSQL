# ProjektSQL
# SQL Project – Mzdy a ceny potravin v ČR a Evropě

Tento projekt analyzuje vývoj mezd a cen potravin v České republice a jejich vztah k HDP a dalším makroekonomickým ukazatelům. Dále porovnává vybraná data s ostatními evropskými státy, aby bylo možné hodnotit ekonomické trendy v širším kontextu.

## Výsledné tabulky

### `t_tereza_dostalikova_project_sql_primary_final`
- Sjednocená data o **mzdách v jednotlivých odvětvích** a **cenách základních potravin** v České republice.
- Obsahuje i výpočet toho, kolik jednotek určité potraviny si lze koupit za průměrnou mzdu (tzv. "purchasable amount").

### `t_tereza_dostalikova_project_sql_secondary_final`
- Data pro **další evropské státy**:  HDP, GINI koeficient a populace dalších evropských států.
- Slouží k mezinárodnímu srovnání a k doplňkové analýze vztahů mezi makroekonomickými ukazateli.

---

## Výzkumná otázka 1:
### Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

### Použitý SQL dotaz:
```sql
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
```

### Výstup (ukázka - prvních pět a posledních pět odvětví):
| Odvětví                                                        | Počáteční rok | Konečný rok | Průměrná mzda na začátku (Kč) | Průměrná mzda na konci (Kč) | Rozdíl (Kč) |
|----------------------------------------------------------------|---------------|-------------|-------------------------------|-----------------------------|-------------|
| Administrativní a podpůrné činnosti                            | 2006          | 2018        | 13 929,00                     | 20 559,50                   | 6 630,50    |
| Ostatní činnosti                                               | 2006          | 2018        | 15 719,38                     | 22 473,00                   | 6 753,62    |
| Ubytování, stravování a pohostinství                           | 2006          | 2018        | 11 390,00                     | 18 769,88                   | 7 379,88    |
| Činnosti v oblasti nemovitostí                                 | 2006          | 2018        | 18 396,38                     | 27 584,25                   | 9 187,87    |
| Zásobování vodou; činnosti související s odpady a sanacemi    | 2006          | 2018        | 18 490,13                     | 28 498,13                   | 10 008,00   |
| Doprava a skladování                                          | 2006          | 2018        | 19 125,25                     | 29 297,63                   | 10 172,38   |
| Stavebnictví                                                | 2006          | 2018        | 17 747,00                     | 27 994,13                   | 10 247,13   |
| Vzdělávání                                                 | 2006          | 2018        | 19 113,50                     | 29 745,00                   | 10 631,50   |
| Zemědělství, lesnictví, rybářství                             | 2006          | 2018        | 14 619,38                     | 25 291,00                   | 10 671,62   |
| Kulturní, zábavní a rekreační činnosti                        | 2006          | 2018        | 16 152,38                     | 27 580,25                   | 11 427,87   |

### Interpretace výsledků:
Všechna sledovaná odvětví vykazují mezi roky 2006 a 2018 nárůst průměrné mzdy.

**Nejnižší nárůst mezd: Administrativní a podpůrné činnosti (+6 631 Kč)**

**Nejvyšší nárůst mezd: Informační a komunikační činnosti (+20 734 Kč)**

To znamená, že ačkoli růst není rovnoměrný, nedochází k poklesu mezd ani v jedné z analyzovaných oblastí. Některé sektory (např. zdravotnictví, školství) rostly pomaleji, ale celkový trend je pozitivní.

---

## Výzkumná otázka 2:
**Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

### Použitý SQL dotaz:
```sql
SELECT 
    product,
    year,
    ROUND(AVG(avg_price)::NUMERIC, 2) AS avg_price,
    ROUND(AVG(average_salary)::NUMERIC, 2) AS avg_salary,
    ROUND(AVG(average_salary) / AVG(avg_price), 2) AS quantity_affordable
FROM t_tereza_dostalikova_project_sql_primary_final
WHERE year IN (2006, 2018) AND product IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
GROUP BY product, year
ORDER BY product, year;
```

### Výstup (ukázka):
| Produkt                     | Rok  | Průměrná cena (Kč) | Průměrná mzda (Kč) | Dostupné množství |
| --------------------------- | ---- | ------------------ | ------------------ | ----------------- |
| Chléb konzumní kmínový      | 2006 | 16.12              | 20 753.79          | 1 287.46          |
| Chléb konzumní kmínový      | 2018 | 24.24              | 32 535.86          | 1 342.24          |
| Mléko polotučné pasterované | 2006 | 14.44              | 20 753.79          | 1 437.24          |
| Mléko polotučné pasterované | 2018 | 19.82              | 32 535.86          | 1 641.57          |

### Interpretace výsledků:
Přestože se mezi roky 2006 a 2018 zvýšily ceny základních potravin (chléb o cca 50 %, mléko o cca 37 %), zároveň výrazně vzrostla i průměrná mzda (o cca 57 %).

To znamená, že:

**Kupní síla mírně vzrostla – za průměrnou mzdu si v roce 2018 může člověk dovolit více kilogramů chleba i litrů mléka než v roce 2006.**

**Chléb: dostupné množství vzrostlo z cca 1 287 kg na 1 342 kg (tedy o cca 4 % více)**

**Mléko: dostupné množství vzrostlo z cca 1 437 litrů na 1 642 litrů (tedy o cca 14 % více)**

Z toho vyplývá, že tempo růstu mezd udrželo krok s růstem cen těchto základních potravin, u mléka dokonce výrazněji.

---

## Výzkumná otázka 3:  
**Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

### Použitý SQL dotaz:
```sql
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
```

### Výstup (ukázka):
| Produkt                      | Průměrný meziroční růst (%) |
| ---------------------------- | --------------------------- |
| Cukr krystalový              | -0.09                       |
| Rajská jablka červená kulatá | -0.04                       |
| Banány žluté                 | 0.04                        |
| …                            | …                           |

### Interpretace výsledků:
**Nejpomaleji zdražují potraviny jako cukr krystalový nebo rajská jablka červená kulatá, kde se ceny meziročně téměř nemění nebo mírně klesají.**

Naopak některé kategorie potravin, například máslo nebo papriky, vykazují vyšší meziroční růst cen.

Z toho plyne, že ne všechny potraviny zdražují stejným tempem, a existují položky s relativně stabilní cenou.

Pro spotřebitele to znamená, že je možné najít v rozpočtu domácnosti položky, jejichž ceny jsou stabilnější a méně zatěžují rozpočet.

---

## Výzkumná otázka 4:
**Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

### Použitý SQL dotaz:
```sql
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
```

### Výstup (ukázka):
| Rok  | Nárůst cen potravin (%) | Nárůst mezd (%) | Rozdíl (%) |
| ---- | ----------------------- | --------------- | ---------- |
| 2013 | 5.10                    | -1.56           | 6.66       |
| 2012 | 6.72                    | 3.03            | 3.69       |
| 2017 | 9.63                    | 6.28            | 3.35       |
| 2011 | 3.35                    | 2.30            | 1.05       |
| 2010 | 1.95                    | 1.95            | 0.00       |
| 2007 | 6.74                    | 6.84            | -0.10      |
| 2008 | 6.19                    | 7.87            | -1.68      |
| 2014 | 0.74                    | 2.56            | -1.82      |
| 2015 | -0.54                   | 2.51            | -3.05      |
| 2016 | -1.21                   | 3.65            | -4.86      |
| 2018 | 2.16                    | 7.62            | -5.46      |
| 2009 | -6.41                   | 3.16            | -9.57      |


### Interpretace výsledků
**Ve sledovaném období neexistuje rok, ve kterém by byl meziroční nárůst cen potravin výrazně vyšší než nárůst mezd o více než 10 %.**

Největší rozdíl v nárůstu cen potravin oproti mzdám je cca 6,7 % v roce 2013, kdy ceny potravin rostly o 5,1 % a mzdy dokonce klesaly.

V žádném roce tedy nedošlo k dramatickému nárůstu cen potravin, který by zásadně převýšil růst mezd.

To naznačuje, že růst mezd v ČR držel krok s růstem cen potravin a výrazné disproporce v tomto období nebyly zaznamenány.

---

## Výzkumná otázka 5:  
**Má výška HDP vliv na změny ve mzdách a cenách potravin?**  
*Nebo-li: pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?*

### Použitý SQL dotaz:
```sql
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
```

## Vystup:
| Rok  | Růst HDP (%) | Růst mezd (%) | Růst cen potravin (%) | Růst mezd následující rok (%) | Růst cen potravin následující rok (%) |
| ---- | ------------ | ------------- | --------------------- | ----------------------------- | ------------------------------------- |
| 2007 | 5.57         | 6.84          | 6.76                  | 7.87                          | 6.19                                  |
| 2008 | 2.69         | 7.87          | 6.19                  | 3.16                          | -6.42                                 |
| 2009 | -4.66        | 3.16          | -6.42                 | 1.95                          | 1.95                                  |
| 2010 | 2.43         | 1.95          | 1.95                  | 2.30                          | 3.35                                  |
| 2011 | 1.76         | 2.30          | 3.35                  | 3.03                          | 6.73                                  |
| 2012 | -0.79        | 3.03          | 6.73                  | -1.56                         | 5.10                                  |
| 2013 | -0.05        | -1.56         | 5.10                  | 2.56                          | 0.74                                  |
| 2014 | 2.26         | 2.56          | 0.74                  | 2.51                          | -0.55                                 |
| 2015 | 5.39         | 2.51          | -0.55                 | 3.65                          | -1.19                                 |
| 2016 | 2.54         | 3.65          | -1.19                 | 6.28                          | 9.63                                  |
| 2017 | 5.17         | 6.28          | 9.63                  | 7.62                          | 2.17                                  |
| 2018 | 3.20         | 7.62          | 2.17                  | NULL                          | NULL                                  |


## Interpretace výsledků:
Výraznější růst HDP v daném roce obvykle doprovází i růst mezd a cen potravin ve stejném roce.

Následující rok po růstu HDP se mzdy a ceny potravin většinou také zvyšují, což může indikovat zpožděný efekt HDP na ekonomiku.

Například v roce 2007 vzrostlo HDP o 5,57 %, mzdy o 6,84 % a ceny potravin o 6,76 %. V následujícím roce mzdy rostly o 7,87 %, zatímco ceny potravin klesly o 6,42 %.

V některých letech však růst HDP nevedl ke stejnému růstu mezd či cen, což ukazuje na složitost ekonomických vztahů.

Celkově lze říct, že růst HDP má tendenci podporovat růst mezd a cen potravin, ale není to pravidlo platné pro každý rok.



