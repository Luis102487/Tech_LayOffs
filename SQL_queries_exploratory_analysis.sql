-- Have many people have lost their jobs due to tech laid offs?
SELECT
  SUM(total_laid_off) AS total_laid_off
FROM
  luisalva.lay_offs.lay_offs_staging

  -- total countries

  -- total location.

  -- Company with most rounds of laid offs

-- Time period of the dataset
SELECT
  MIN(date) AS first_date,
  MAX(date) AS last_date
FROM
  luisalva.lay_offs.lay_offs_staging;

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





what companies laid off the most each year
Companies that went under.
How many millions were raised by companies that went under.
fund_raised_milliosn
