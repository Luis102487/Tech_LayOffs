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

stage
Companies that went under.
How many millions were raised by companies that went under.
fund_raised_milliosn
