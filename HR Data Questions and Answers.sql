-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?

-- 2. What is the race/ethnicity breakdown of employees in the company?

-- 3. What is the age distribution of employees in the company?


-- 4. How many employees work at headquarters versus remote locations?


-- 5. What is the average length of employment for employees who have been terminated?
SELECT
  ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_length_employment
FROM hr
WHERE
  termdate <= CURDATE()
  AND termdate IS NOT NULL
  AND termdate <> '2000-01-01'
  AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?
select department,gender,COUNT(*) AS count
FROM hr
group by department,gender
order by department;

-- 7. What is the distribution of job titles across the company?
select jobtitle,count(*) AS count
FROM hr
where age >= 18 and termdate = '1900-01-01'
group by jobtitle
order by jobtitle desc;

-- 8. Which department has the highest turnover rate?
select department,
	total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
	SELECT department,
    count(*) AS total_count,
    SUM(CASE WHEN termdate <>'1900-01-01' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
    from hr
    where age>= 18
    group by department
    )AS subquery
    order by termination_rate desc;
   
-- 9. What is the distribution of employees across locations by city and state?
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate IS NOT NULL
GROUP BY location_state
ORDER BY count DESC;

-- 10. How has the company's employee count changed over time based on hire and term dates?
select
	year,
	hires,
	terminations,
    hires-terminations AS net_change,
    round((hires-terminations)/hires*100,2) AS net_change_percent
from(
select year(hire_date) AS year,
count(*) AS hires,
SUM(CASE WHEN termdate <> '1900-01-01' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
from hr
where age>= 18
group by year(hire_date)
) AS subquery
ORDER BY year ASC;
-- 11. What is the tenure distribution for each department?
select department,round(avg(datediff(termdate,hire_date)/365),0) AS avg_tenure
from hr
where termdate <= curdate() AND termdate <> '1900-01-01' AND age>=18
group by department;