/*
============================================================
          SQL LAYOFFS EXPLORATORY DATA ANALYSIS
============================================================

Project : SQL Layoffs Data Cleaning & Analysis
Database: MySQL
Author  : Aleyna

Bu SQL betiği, temizlenmiş işten çıkarma (layoffs) veri seti üzerinde keşifsel veri analizi (Exploratory Data Analysis - EDA) gerçekleştirmek amacıyla hazırlanmıştır.

Bu dosyada aşağıdaki analizler yer almaktadır:

1. Veri setinin genel görünümünün incelenmesi
2. En yüksek işten çıkarma sayılarının belirlenmesi
3. %100 işten çıkarma yapan şirketlerin incelenmesi
4. Şirketlere göre toplam işten çıkarma sayıları
5. Sektörlere göre toplam işten çıkarma sayıları
6. Ülkelere göre toplam işten çıkarma sayıları
7. Yıllara göre toplam işten çıkarma sayıları
8. Aylık işten çıkarma trendinin incelenmesi
9. Şirketlerin gelişim aşamalarına (Stage) göre işten çıkarma analizleri

============================================================
*/


SELECT *
FROM layoffs_staging2;


SELECT MAX(total_laid_off) AS max_total_laid_off,
       MAX(percentage_laid_off) AS max_percentage_laid_off
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;


SELECT company,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC;


SELECT industry,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;


SELECT country,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC;


SELECT YEAR(`date`) AS year,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year;


SELECT DATE_FORMAT(`date`, '%Y-%m') AS month,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY month
ORDER BY month;


SELECT stage,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;