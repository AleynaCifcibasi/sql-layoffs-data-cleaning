/*
============================================================
                ADVANCED SQL QUERIES
============================================================

Project : SQL Layoffs Data Cleaning & Analysis
Database: MySQL
Author  : Aleyna

Description:
Bu dosya aşağıdaki gelişmiş SQL konularını içermektedir:

- Common Table Expressions (CTE)
- Window Functions
- Rolling Total
- DENSE_RANK()
- Veri analizi sorguları

============================================================
*/


WITH Rolling_Total AS
(
    SELECT
        DATE_FORMAT(`date`, '%Y-%m') AS month,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY month
)

SELECT
    month,
    total_laid_off,
    SUM(total_laid_off) OVER (ORDER BY month) AS rolling_total
FROM Rolling_Total;


WITH Company_Year AS
(
    SELECT
        company,
        YEAR(`date`) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY company, YEAR(`date`)
)

SELECT *
FROM Company_Year
ORDER BY year, total_laid_off DESC;


WITH Company_Year AS
(
    SELECT
        company,
        YEAR(`date`) AS year,
        SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    WHERE `date` IS NOT NULL
    GROUP BY company, YEAR(`date`)
),

Company_Year_Rank AS
(
    SELECT *,
           DENSE_RANK() OVER
           (
               PARTITION BY year
               ORDER BY total_laid_off DESC
           ) AS ranking
    FROM Company_Year
)

SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5
ORDER BY year, ranking;


SELECT
    company,
    total_laid_off,
    percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


SELECT
    company,
    SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;