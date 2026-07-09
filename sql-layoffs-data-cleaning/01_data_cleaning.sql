/*
============================================================
                SQL LAYOFFS DATA CLEANING
============================================================

Project : SQL Layoffs Data Cleaning
Database: MySQL
Author  : Aleyna

Description:
Bu SQL betiği işten çıkarma (layoffs) veri setini temizlemek için aşağıdaki işlemleri gerçekleştirir:

1. Geçici (staging) tablo oluşturma
2. Yinelenen kayıtların kaldırılması
3. Tutarsız verilerin standartlaştırılması
4. NULL ve boş değerlerin düzenlenmesi
5. Veri türlerinin dönüştürülmesi
6. Gereksiz sütunların kaldırılması

============================================================
*/


USE work_layoffs;


SELECT *
FROM layoffs;


DROP TABLE IF EXISTS layoffs_staging;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_staging;


SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


DROP TABLE IF EXISTS layoffs_staging2;

CREATE TABLE layoffs_staging2 (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT DEFAULT NULL,
percentage_laid_off TEXT,
`date` TEXT,
stage TEXT,
country TEXT,
funds_raised_millions INT DEFAULT NULL,
row_num INT
);

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
)
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

UPDATE layoffs_staging2
SET company = TRIM(company);


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2
SET country = TRIM(country);

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;