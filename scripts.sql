select 
	e.last_name,
	e.email,
	d.department_name
from
	data_sci.employees e
join
	data_sci.company_departments d
on
	e.department_id = d.id
	
where
	e.salary > 120000


/*Reformat Characters*/

ltrim (removes left blank spaces)
rtrim(removes right blank spaces)
upper(transform all character to upper case)
lower(transform all character to lower case)
initcap(First character in upper case)
concat(char1, char2, etc)
concat_ws(separator, char1, char2, etc)


/* Extract strings*/
select substring('abcdefg', 1,3) as test
result is abc

string extraction and create boolean expression

select
	job_title, (job_title like '%assistant%') as is_assistant
from 
	data_sci.employees


/* Filter with Regular expressions*/
--this is to select all job titles starting with vp and web

select distinct
	job_title
from
	data_sci.employees
where
	job_title similar to '(vp%|web%)'

/*Reformat Numbers*/
select ceil(avg(salary))
from data_sci.employees

use also trunc and round


/*SOUNDEX*/
--First install the extension
create extension fuzzystrmatch

soundex(char)


/*Filtering and aggregations*/
select
	department_name,count(*)
from
	data_sci.employees e
join 
	data_sci.company_departments cd
on
	e.department_id = cd.id
group by 
	cd.department_name
order by
	count(*) desc


--use HAVING to filter agg functions
select
	department_name,count(*)
from
	data_sci.employees e
join 
	data_sci.company_departments cd
on
	e.department_id = cd.id
group by 
	cd.department_name
having
	count(*) > 50
order by
	cd.department_name

/*Subqueries*/
-- This subquery calculates the avg department id for each row of data

select
	e1.last_name,
	e1.salary,
	e1.department_id,
	(select 
	 	round(avg(e2.salary),2)
	 from 
	 	data_sci.employees e2 
	 where 
	 	e1.department_id = e2.department_id) 
from
	data_sci.employees e1

--subquery in FROM clause must have alias

--subquery in WHERE clause must have a boolean expression

/*ROLLUP to create subtotals*/
select cr.country_name, cr.region_name, count(e.*)
from data_sci.employees e
join
data_sci.company_regions cr
on e.region_id = cr.id
group by
rollup(cr.country_name,cr.region_name)
order by 
cr.country_name,cr.region_name


/*CUBE Operator*/
produces multiple subtotals for each dimension
select 
	cr.country_name,
	cr.region_name,
	cd.department_name,
	count(e.*)
from 
	data_sci.employees e
join
	data_sci.company_regions cr
on
	e.region_id = cr.id
join 
	data_sci.company_departments cd
on
	e.department_id = cd.id
group by
	cube(cr.country_name,
		cr.region_name,
		cd.department_name
		)
order by
	cr.country_name,
	cr.region_name,
	cd.department_name


/*Window Functions*/
select
	department_id,
	last_name,
	salary,
	first_value(salary) over (partition by department_id order by salary asc)
from
data_sci.employees


nth_value, ntile

rank()
leadselect
	department_id,
	last_name,
	salary,
	first_value(salary) over (partition by department_id order by salary asc)
from
data_sci.employees