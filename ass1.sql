-- COMP3311 22T1 Assignment 1

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


-- Q3
-- List of international students
create or replace view intlstudents(id)
as
	select
		id
	from students
	where stype = 'intl'
;

-- All students with course and subject id
create or replace view course_with_subject (student, course, mark, subject)
as
	select
		ce.student,
		ce.course,
		ce.mark,
		c.subject
	from course_enrolments ce
	join courses c on (ce.course = c.id);
;

-- All international students with all course and subject id and mark > 85
create or replace view intl_info
as
	select
		student,
		course,
		mark,
		subject
	from intlstudents intl
	join course_with_subject cws on (intl.id = cws.student)
	where mark > 85
;

-- Courses offered by the School of Law
create or replace view law_courses (id, code)
as
	select
		id,
		code
	from subjects
	where offeredby = 165;
;

-- All international students who took a Law course
create or replace view intl_law_info
as
	select *
	from law_courses
	join intl_info on (law_courses.id = intl_info.subject)
;

create or replace view Q3(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...

	select
		p.unswid,
		p.name
	from intl_law_info intl
	join People p on (intl.student = p.id);

;

-- Q4
create or replace view Q4(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...
;


-- Q5a
create or replace view Q5a(term, min_fail_rate)
as
--... SQL statements, possibly using other views/functions defined by you ...
;


-- Q5b
create or replace view Q5b(term, min_fail_rate)
as
--... SQL statements, possibly using other views/functions defined by you ...
;


-- Q6
create or replace function 
	Q6(id integer,code text) returns integer
as $$
--... SQL statements, possibly using other views/functions defined by you ...
$$ language sql;


-- Q7
create or replace function 
	Q7(year integer, session text) returns table (code text)
as $$
--... SQL statements, possibly using other views/functions defined by you ...
$$ language sql;


-- Q8
create or replace function
	Q8(zid integer) returns setof TermTranscriptRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
$$ language plpgsql;


-- Q9
create or replace function 
	Q9(gid integer) returns setof AcObjRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
$$ language plpgsql;


-- Q10
create or replace function
	Q10(code text) returns setof text
as $$
--... SQL statements, possibly using other views/functions defined by you ...
$$ language plpgsql;

