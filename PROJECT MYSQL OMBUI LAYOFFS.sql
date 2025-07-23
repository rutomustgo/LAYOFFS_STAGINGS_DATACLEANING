SELECT*
FROM layoffs;

CREATE table layoffs_staging
LIKE layoffs;

SELECT*
FROM layoffs_staging;

INSERT layoffs_staging
SELECT*
FROM layoffs; 

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

SELECT*
FROM layoffs_staging
WHERE COMPANY='casper';



WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
where row_num>1;





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


SELECT*
FROM layoffs_staging2
WHERE row_num>1;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num>1;

-- STANDARDIZING DATA


SELECT*
FROM layoffs_staging2;



SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);


SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'CRYPTO%';


UPDATE layoffs_staging2
SET industry='crypto'
WHERE industry LIKE 'CRYPTO%';


SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT DISTINCT location
FROM layoffs_staging2
order by 1;


SELECT DISTINCT country
FROM layoffs_staging2
order by 1;

SELECT DISTINCT country,TRIM(TRAILING '.' FROM COUNTRY )
FROM layoffs_staging2
order by 1;

UPDATE layoffs_staging2
SET country =TRIM(trailing '.' FROM COUNTRY)
WHERE country LIKE 'UNITEDSTATES%';

SELECT `date`,
STR_TO_DATE(`date` , '%m/%d/%Y')
FROM layoffs_staging2;

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date` , '%m/%d/%Y');

ALTER TABLE layoffs_staging2
modify column `date` DATE;


SELECT*
FROM layoffs_staging2;


-- working on null values


SELECT*
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry=null
WHERE industry=' ';

SELECT*
FROM layoffs_staging2
WHERE industry IS NULL
OR industry='';

SELECT*
FROM layoffs_staging2
WHERE company='airbnb';


SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
WHERE(t1.industry IS NULL OR t1.industry ='')
AND t2.industry is not null;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
SET t1.industry=t2.industry
WHERE t1.industry IS NULL 
AND t2.industry is not null;


SELECT*
FROM layoffs_staging2
WHERE total_laid_off is null
and percentage_laid_off is null;


delete
FROM layoffs_staging2
WHERE total_laid_off is null
and percentage_laid_off is null;

select*
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;












