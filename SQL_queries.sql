-- 1. Remove row duplicates

-- Let's check if there is any duplicates in the dataset. 
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
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions ) AS row_num
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

-- 2. Fix Structural errors
-- Now we will look for any misspellings, incongruent naming conventions, improper capitalization for each data column.

-- It looks like the company column has white spaces at the beginning for some of the names. Let's trim those white space.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  company = TRIM(company);

-- If we look at industry columns we will find some null and empty values.
-- Also you will that Crypto has different variations. 
SELECT
  DISTINCT industry
FROM
  luisalva.lay_offs.layoff_staging
ORDER BY
  industry;

-- Let take a look at null and empty values. There are 4 companies with null or empty industry values.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  industry IS NULL
  OR industry = 'NULL';

-- Lets run a query to see row with the same company name so we can update it with the correct company name.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
company = 'Carvana';  

-- We found other records for Carvana and it looks like it belongs to the travel industry. Lets updated the empty record.
 UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Transportation'
WHERE
  company = 'Carvana'; 
  


  

-- We need to standardize the Crypto entry. Let's name all Crypto.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Crypto'
WHERE
  industry IN ('Crypto Currency', 'CryptoCurrency');







