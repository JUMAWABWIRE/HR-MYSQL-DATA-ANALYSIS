-- 1. What is the gender breakdown of employees in the company?

select gender,count(*) As count
from hr
where age >= 18 and termdate is NULL
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY race
ORDER BY count DESC;

-- 3. What is the age distribution of employees in the company?
SELECT
	min(age) AS youngest,
	max(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate IS NULL;

SELECT
CASE
WHEN age >= 18 AND age <=24 THEN '18-24'
WHEN age >= 25 AND age <=34 THEN '25-34'
WHEN age >= 35 AND age <=44 THEN '35-44'
WHEN age >= 45 AND age <=54 THEN '45-54'
WHEN age >= 55 AND age <=64 THEN '55-64'
ELSE '65+'
END AS age_group,
count(*) as count
from hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group
ORDER BY age_group;

-- Age distribution by gender.
SELECT
CASE
WHEN age >= 18 AND age <=24 THEN '18-24'
WHEN age >= 25 AND age <=34 THEN '25-34'
WHEN age >= 35 AND age <=44 THEN '35-44'
WHEN age >= 45 AND age <=54 THEN '45-54'
WHEN age >= 55 AND age <=64 THEN '55-64'
ELSE '65+'
END AS age_group, gender,
count(*) as count
from hr
WHERE age >= 18 AND termdate IS NULL
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquarters versus remote locations?

select location, count(*) AS count
from hr
where age >= 18 AND termdate is null
group by location;

-- 5. What is the average length of employment for employees who have been terminated?
SELECT 
  ROUND(AVG(DATEDIFF(termdate, hire_date) / 365)) AS ave_length_employment
FROM hr
WHERE termdate <= CURDATE() 
  AND termdate IS NOT NULL 
  AND age >= 18;



-- 6. How does the gender distribution vary across departments and job titles?

select department, gender, count(*) as count
from hr
where age >= 18 AND termdate is null
group by department, gender
order by department;


-- 7. What is the distribution of job titles across the company?

select jobtitle, count(*) as count
from hr
where age >= 18 AND termdate is null
group by jobtitle
order by jobtitle desc;


-- 8. Which department has the highest turnover rate?
SELECT 
  department,
  total_count,
  terminated_count,
  ROUND(terminated_count / total_count, 4) AS termination_rate
FROM (
  SELECT 
    department,
    COUNT(*) AS total_count,
    SUM(CASE 
          WHEN termdate IS NOT NULL AND termdate <= CURDATE() 
          THEN 1 
          ELSE 0 
        END) AS terminated_count
  FROM hr
  WHERE age >= 18
  GROUP BY department
) AS subquery;



-- 9. What is the distribution of employees across locations by city and state?

select location_state, count(*) as count
from hr
where age >= 18 AND termdate is null
group by location_state
order by count desc;


-- 10. How has the company's employee count changed over time based on hire and term dates?
select
year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations)/hires*100, 2) as net_change_percent
from(
select year(hire_date) as year,
count(*) as hires,
sum(case when termdate is not null and termdate <= curdate()
 then 1 
 else 0 
 end) as terminations
from hr
where age >= 18
group by year(hire_date)
) as subquery
order by year asc;
-- 11. What is the tenure distribution for each department?
select department, round(avg(datediff(termdate, hire_date) /365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate is not null and age >= 18
group by department;