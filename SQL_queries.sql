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

----------------------------------------------------------------------------------------
-- 2. Fix Structural errors

-- Now we will look for any misspellings, incongruent naming conventions, improper capitalization for each data column.

-- It looks like the company column has white spaces at the beginning for some of the names. Let's trim those white space.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  company = TRIM(company);

---------------------------------------------------
-- If we look at industry columns we will find some null and empty values.
SELECT
  DISTINCT industry
FROM
  luisalva.lay_offs.layoff_staging
ORDER BY
  industry;

-- Let take a look at null and empty values. There are 4 companies with null or empty industry values.
-- These companies are: Carvana, Airbnb, Juul, Bally's Interactive.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  industry IS NULL
  OR industry = 'NULL';
------------------------------------------------------

-- Lets run a query to see if there are other records for Carvana so we can update it to the correct industry.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  company = 'Carvana';  

-- We found other records for Carvana and it belongs to the travel industry. Lets updated the empty record.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Transportation'
WHERE
  company = 'Carvana'; 
-------------------------------------------------------

-- Lets run a query to see if there are other records for Airbnb so we can update it to the correct industry.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  company = 'Airbnb';  

-- There is another record for Airbnb and it belongs to the Travel industry. Let's update it.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Travel'
WHERE
  company = 'Airbnb'; 
------------------------------------------------------------

-- Lets run a query to see if there are other records for Juul so we can update it to the correct industry.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  company = 'Juul'; 

-- There is another record for Juul and it belongs to the Consumer industry. Let's update it.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Consumer'
WHERE
  company = 'Juul'; 
----------------------------------------------------------

-- Lets run a query to see if there are other records for Bally's Interactive so we can update it to the correct industry.
SELECT
  *
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  company = "Bally's Interactive"; 

-- There is no other record for Bally's Interactive, therefore we can't see what industry it belongs to.
-- In this case, let's update to the Other industry type.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Other'
WHERE
  company = "Bally's Interactive";
----------------------------------------------------------------

-- The Crypto industry has different variations: Crypto, Crypto Currency, CryptoCurrency.
SELECT
  DISTINCT industry
FROM
  luisalva.lay_offs.layoff_staging
WHERE
  CONTAINS(industry, 'Crypto');

-- We need to standardize the Crypto entry. Let's name all Crypto.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  industry = 'Crypto'
WHERE
  industry IN ('Crypto Currency', 'CryptoCurrency');
----------------------------------------------------------------------

-- Now let's check the country column. There are two enries for United States ("United States" and "United States.")
SELECT
  DISTINCT country
FROM
  luisalva.lay_offs.layoff_staging
ORDER BY
  country;

-- There are two enries for United States ("United States" and "United States."). Let's update it.
UPDATE
  luisalva.lay_offs.layoff_staging
SET
  country = 'United States'
WHERE
  country = 'United States.'




