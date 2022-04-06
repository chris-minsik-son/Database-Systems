-- Q7
create or replace function 
	Q7(year integer, session text) returns table (code text)
as $$
--... SQL statements, possibly using other views/functions defined by you ...

	select
		s.code
	--	c.term,
	--	t.year,
	--	t.session
	from subjects s
		join courses c on (s.id = c.subject)
		join terms t on (c.term = t.id)
	where s.code ~ 'COMP' and s.career = 'PG' and t.year = $1 and t.session = $2;

$$ language sql;