-- Remove any row duplicates

-- First let's check if there is any duplicates in the dataset. 
-- To do this want to create a staging table where we can work and clean the data.
-- We also add a row_num column in this new table to help us identify row duplicates.
CREATE TABLE
  luisalva.lay_offs.layoff_staging AS (
  SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions ) AS row_num
  FROM
    luisalva.lay_offs.lay_offs)

-- Query to identify row duplicates.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  row_num > 1;

-- After running the query we can see that there is 5 row duplicates. We need to delete this records from the dataset.
DELETE
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  row_num > 1;

