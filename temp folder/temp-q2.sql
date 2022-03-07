-- Q2
create or replace view Q2(unswid, name, course_cnt)
as
--... SQL statements, possibly using other views/functions defined by you ...

	select
		p.unswid,
		p.name,
		count(staff) as course_cnt
	from course_staff cs
	join People p on (cs.staff = p.id)
	where role = '3004'
	group by p.unswid, p.name
	order by course_cnt desc
	limit 1

;