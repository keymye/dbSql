--JOIN 8
SELECT r.region_id, region_name, country_name
FROM countries c JOIN regions r ON (c.region_id = 1 AND c.region_id = r.region_id);

--JOIN 9
SELECT r.region_id, region_name, country_name, city
FROM  regions r JOIN  countries c ON (c.region_id = 1 AND c.region_id = r.region_id)
JOIN locations l ON (c.country_id = l.country_id);

--JOIN 10
SELECT r.region_id, region_name, country_name, city, department_name
FROM  regions r JOIN  countries c ON (c.region_id = 1 AND c.region_id = r.region_id)
JOIN locations l ON (c.country_id = l.country_id) JOIN departments d ON (l.location_id = d.location_id);

--JOIN 11
SELECT r.region_id, region_name, country_name, city, department_name, concat(first_name, last_name)name
FROM  regions r JOIN  countries c ON (c.region_id = 1 AND c.region_id = r.region_id)
JOIN locations l ON (c.country_id = l.country_id) JOIN departments d ON (l.location_id = d.location_id)
JOIN employees e ON (d.department_id = e.department_id);

--JOIN12
SELECT employee_id, concat(first_name, last_name)name, e.job_id, job_title
FROM jobs j JOIN employees e ON(j.job_id = e.job_id);

--JOIN13
SELECT e.manager_id mng_id, concat(m.first_name,m.last_name) mgr_name, e.employee_id,  concat(e.first_name,e.last_name) name,
e.job_id, job_title
FROM employees e, employees m, jobs
WHERE m.employee_id = e.manager_id AND jobs.job_id = e.job_id;
--매니저아이디,이름


select * from jobs;
select * from employees order by manager_id;
select * from employees order by employee_id;



