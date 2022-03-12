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
	order by p.unswid asc;

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
	limit 1;

;


-- Q3
-- List of international students
create or replace view intlstudents(id)
as
	select
		id
	from students
	where stype = 'intl';
;

-- All students with course and subject id
-- VIEW below has course_enrolments(student, course, mark) and Courses(subject)
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
	where mark > 85;
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
	join intl_info on (law_courses.id = intl_info.subject);
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
-- List of local students
create or replace view localstudents(id)
as
	select
		id
	from students
	where stype = 'local';
;

-- VIEW course_with_subject made previously
-- VIEW below has course_enrolments(student, course, mark) and Courses(subject)

-- All local students with course, mark, subject, etc
create or replace view local_info
as
	select
		student,
		course,
		mark,
		subject
	from localstudents localstd
	join course_with_subject cws on (localstd.id = cws.student);
;

-- Find the subject codes for COMP9020 and COMP9331
-- select id,code,name from subjects order by code;
/*
  id  |   code   |             name             
------+----------+------------------------------
 4876 | COMP9020 | Foundations of Comp. Science
------+----------+--------------------------------
 4899 | COMP9331 | Computer Networks&Applications
*/

-- VIEW course_with_subject has course_enrolments(student, course, mark) and Courses(subject)
-- Note that Courses(subject) references Subjects(id)
-- course_enrolments(course) references Courses(id)

-- All local students taking COMP9020 and COMP9311
create or replace view local_comp_info
as
	select *
	from local_info
	where subject = 4876 or subject = 4899;
;

-- Including the term column to the local_comp_info view
create or replace view course_subj_term
as
	select
		lci.student,
		lci.course,
		lci.subject,
		c.term
	from local_comp_info lci
	join courses c on (lci.course = c.id);
;

-- Compare duplicate tables and set conditions to retrieve a student taking two courses in a given term
create or replace view local_comp_table
as
	select
		t1.student,
		t1.subject,
		t1.term
	from
		course_subj_term t1,
		course_subj_term t2
	where t1.student = t2.student and t1.subject <> t2.subject and t1.term = t2.term
	order by student asc;
;

create or replace view Q4(unswid, name)
as
--... SQL statements, possibly using other views/functions defined by you ...

	select
		distinct(p.unswid),
		p.name
	from local_comp_table lc
	join People p on (lc.student = p.id);

;


-- Q5a
/*
  id  |   code   |       name       
------+----------+------------------
 1884 | COMP3311 | Database Systems
*/

-- Updated course_with_subject view with term column
create or replace view course_with_subject_final
as
	select
		ce.student,
		ce.course,
		ce.mark,
		c.subject,
		c.term
	from course_enrolments ce
	join courses c on (ce.course = c.id);
;

-- List of all students taking COMP3311 with non-null mark values
create or replace view students_comp3311
as
	select
		cwst.student,
		cwst.course,
		cwst.mark,
		cwst.subject,
		cwst.term,
		t.id,
		t.year,
		t.name
	from course_with_subject_final cwst
	join terms t on (cwst.term = t.id)
	where subject = 1884 and mark IS NOT NULL;
;

-- List of students taking COMP3311 from 2009 to 2012
create or replace view students_comp3311_2009_2012
as
	select *
	from students_comp3311
	where year >= 2009 and year <= 2012;
;

-- List of students taking COMP3311 from 2016 to 2019
create or replace view students_comp3311_2016_2019
as
	select *
	from students_comp3311
	where year >= 2016 and year <= 2019;
;

-- The following 2 functions are for COMP3311 2009 to 2012
create or replace view measure_table_1_fail as (
	select
		name,
		count(*) as fail_count
	from students_comp3311_2009_2012
	where mark < 50
	group by name
);

create or replace view measure_table_1_total as (
	select
		name,
		count(*) as total_count
	from students_comp3311_2009_2012
	group by name
)

-- FIX ERROR, Solution only has 2010 and column name is unchangeable
create or replace view Q5a(term, min_fail_rate)
as
--... SQL statements, possibly using other views/functions defined by you ...

	select
		t.name,
--		f.fail_count,
--		t.total_count,
		round(f.fail_count::numeric / t.total_count, 4) as fail_rate
	from measure_table_1_total t
	join measure_table_1_fail f on (t.name = f.name);
;


-- The following 2 functions are for COMP3311 2016 to 2019
-- VIEWS have not been created yet: need to use for mymy2 database
create or replace view measure_table_2_fail as (
	select
		name,
		count(*) as fail_count
	from students_comp3311_2016_2019
	where mark < 50
	group by name
);

create or replace view measure_table_2_total as (
	select
		name,
		count(*) as total_count
	from students_comp3311_2016_2019
	group by name
)

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

