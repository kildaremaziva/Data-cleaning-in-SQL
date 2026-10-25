-- DATA CLEANING 

select *
from layoffs
;
-- steps taken to clean the dat 
-- 1 remove any duplicates 
-- 2 standardize  the data 
-- 3look at null and blank values 
-- 4 remove any colums and rows that are uncessary 

create table layoffs_staging
like layoffs;

insert layoffs_staging 
select * 
from layoffs;

select * ,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging 
;

with duplicate_cte as
(
select * ,
row_number() over(
partition by company, location, 
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millionslayoffs_staging) as row_num
from layoffs_staging 
)
select*
from duplicate_cte
where row_num > 1 ;

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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * 
from layoffs_staging2 ;

insert into layoffs_staging2
select * ,
row_number() over(
partition by company, location, 
 industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_staging; 

delete
from layoffs_staging2
where row_num > 1;

select*
from layoffs_staging2
where row_num > 1;

-- standardizing data 

select*
from layoffs_staging2;

select distinct(trim(company))
from layoffs_staging2
;

select distinct (industry) 
from layoffs_staging2
order by 1 ;


select distinct (industry)
from layoffs_staging2
order by 1
; 

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%'
;

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1
;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%'
;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2
;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');
;

select *
from layoffs_staging2;

alter table layoffs_staging2
modify column `date` date;

select *
from layoffs_staging2
where company = 'Airbnb'
;

-- lookinf at null and blank values 

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null
or industry = ''
;

update layoffs_staging2
set industry = null
where industry = '';

select t1.industry, t2.industry
from layoffs_staging2 as t1
join layoffs_staging2 as t2 
	on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null    
;

update layoffs_staging2 as t1
join layoffs_staging2 as t2 
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null ;

select *
from layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

delete
from layoffs_staging2;

select *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;











