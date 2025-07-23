# LAYOFFS_STAGINGS_DATACLEANING
DATA CLEANING PROJECT
# LAYOFFS_STAGINGS_DATACLEANING

This repository contains SQL scripts for a data cleaning project focused on layoffs data.

## Project Description
This project aims to clean and prepare a dataset related to layoffs, ensuring data quality and consistency for further analysis.

## Data Source
[The data is sourced from an Excel file data layoffs]

## SQL Scripts

### 1. Initial Data Exploration
Here's a sample query to get an overview of the data:

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT company) AS unique_companies,
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM
    layoffs_data;

## SELECTING TABLE


Selecting the table with data to work on

```sql
SELECT*
FROM layoffs;

## CREATING TABLES IN SQL

creating a new table

```sql
CREATE table layoffs_staging
LIKE layoffs;


## SELECTING TABLE
selecting the table we have created

```sql
SELECT*
FROM layoffs_staging;

## INSERTING VALUES
inserting values into the new table from the initial table

```sql
INSERT layoffs_staging
SELECT*
FROM layoffs;

## CONFIRMING THE NUMBER OF ROWS
a query to indicate the rows that have been repeated

```sql
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

## SELECTING ROWS THAT ARE MORE THAN 1
creating duplicate ctes to output the rows that are duplicates

```sql
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging
)
SELECT*
FROM duplicate_cte
where row_num>1;


## CONFIRMING THE DATA
looking at the rows we found duplicate to ensure accuracy

```sql
SELECT*
FROM layoffs_staging
WHERE COMPANY='casper';


## CREATING ANOTHER TABLE TO HELP DEAL WITH DATA

```sql
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



## INSERTING DATA INTO THE NEW TABLE
```sql

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

## CONFIRMING ROWS THAT ARE NOW DUPLICATES
After inserting data now we delete the new duplicates

```sql

SELECT*
FROM layoffs_staging2
WHERE row_num> 1;

## DELETING
Deleting the duplicate rows to finalize the cleaning

```sql
DELETE
FROM layoffs_staging2
WHERE row_num>1;

--- STANDARDIZING DATA

#SELECTING DATA
selecting data from the table to work on

```sql
SELECT*
FROM layoffs_staging2;


## TRIMMING

```sql
SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

## UPDATING THE TABLE
After finding the error a query to update

```sql

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'CRYPTO%';


UPDATE layoffs_staging2
SET industry='crypto'
WHERE industry LIKE 'CRYPTO%';

## SELECTING DISTINCTS

```sql
SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
order by 1;


SELECT DISTINCT country
FROM layoffs_staging2
order by 1;


#UPDATING
After finding the error a query to correct it

```sql
SELECT DISTINCT country,TRIM(TRAILING '.' FROM COUNTRY )
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country =TRIM(trailing '.' FROM COUNTRY)
WHERE country LIKE 'UNITEDSTATES%';

## FINDING AN ERROR IN DATES
``` sql

SELECT `date`,
STR_TO_DATE(`date` , '%m/%d/%Y')
FROM layoffs_staging2;

## UPDATING THE ERROR
```sql

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date` , '%m/%d/%Y');


#DROPPING COLUMNS
After finding the error dropping the columns we don't need

```sql

ALTER TABLE layoffs_staging2
modify column `date` DATE;


SELECT*
FROM layoffs_staging2;

## WORKING ON NULL VALUES
Finding the the null values so that we can work on them

```sql
SELECT*
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

## UPDATING THE INDUSTRY
The industry part has some null values we have to update

```sql
UPDATE layoffs_staging2
SET industry=null
WHERE industry=' ';

SELECT*
FROM layoffs_staging2
WHERE industry IS NULL
OR industry='';


## FINDING NULL

```sql
SELECT*
FROM layoffs_staging2
WHERE total_laid_off is null
and percentage_laid_off is null;


delete
FROM layoffs_staging2
WHERE total_laid_off is null
and percentage_laid_off is null;


## ALTERING THE TABLE
Deleting the columns that are unnecessary to finalize

```sql

alter table layoffs_staging2
drop column row_num;












































































































