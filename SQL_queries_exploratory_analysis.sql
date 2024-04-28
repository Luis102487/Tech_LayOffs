-- Have many people have lost their jobs due to tech laid offs? Total laid offs
SELECT
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging;

-- Time period of lay offs
SELECT
  MIN(date) AS first_date,
  MAX(date) AS last_date
FROM
  luisalva.lay_offs.lay_offs_staging;

---------------------------------------------
-- Laid offs by company
SELECT
  company,
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  company
ORDER BY
  total_laid_off DESC;

-- Company with biggest lay off
SELECT
  company,
  SUM(total_laid_off)
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  company
ORDER BY
  SUM(total_laid_off) DESC
LIMIT 1;

-- Companies with most lay offs rounds
SELECT
  company,
  COUNT(date) AS lay_offs_rounds
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  company
ORDER BY
  lay_offs_rounds DESC;


-- Companies that laid off 100% of their employees with total of employees laid off
SELECT
  company,
  total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging
WHERE
  percentage_laid_off = 1
ORDER BY
  total_laid_off DESC;


-- How many millions were fund raised by companies that went under.
SELECT
  company,
  funds_raised_millions
FROM
  luisalva.lay_offs.lay_offs_staging
WHERE
  percetange_laid_off = 1
ORDER BY
  funds_raised_millions DESC;

------------------------------------------------
-- Laid offs by country
SELECT
  country,
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  country
ORDER BY
  total_laid_off DESC;

-- How many countries have face lay offs so far
SELECT
  COUNT(DISTINCT country) AS country_count
FROM
  luisalva.lay_offs.lay_offs_staging;

-- Top 3 countries with most lay offs locations
SELECT
  country,
  COUNT(DISTINCT location) AS location_count
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  country
ORDER BY
  location_count DESC
LIMIT
  3;

--------------------------------------------------------
-- Laid offs by industry
SELECT
  industry,
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  industry
ORDER BY
  total_laid_off DESC;

----------------------------------------------------------
-- Laid offs by year
SELECT
  EXTRACT(year
  FROM
    date) AS year,
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging
WHERE
  date IS NOT NULL
GROUP BY
  year
ORDER BY
  year;

-----------------------------------------------------------
-- Laid offs by stage
SELECT
  stage,
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging
GROUP BY
  stage
ORDER BY
  total_laid_off DESC;










WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;




-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
