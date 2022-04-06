-- Q1
create or replace view Q1(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...

    select
		p.unswid,
		p.name
	from program_enrolments pe
	join People p on (pe.student = p.id)
	group by p.unswid, p.name
	having count(distinct program) > 4
	order by p.unswid asc

;