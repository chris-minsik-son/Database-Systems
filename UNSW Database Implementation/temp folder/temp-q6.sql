-- Q6
create or replace function 
	Q6(id integer,code text) returns integer
as $$
--... SQL statements, possibly using other views/functions defined by you ...

	select
--		s.code,
		ce.mark
--		p.id
	from subjects s
		join courses c on (s.id = c.subject)
		join course_enrolments ce on (c.id = ce.course)
		join students std on (ce.student = std.id)
		join People p on (std.id = p.id)
	where p.id = $1 and s.code = $2;

$$ language sql;