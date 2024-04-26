-- Remove any row Duplicates

-- First let's check if there is any duplicates in the dataset.  
SELECT
  *
FROM (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off, `date` ) AS row_num
  FROM
    luisalva.lay_offs.lay_offs ) AS duplicates
WHERE
  row_num > 1;
