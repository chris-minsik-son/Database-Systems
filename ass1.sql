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

create or replace view Q5a(term, min_fail_rate)
as
--... SQL statements, possibly using other views/functions defined by you ...

	select
		t.name,
--		f.fail_count,
--		t.total_count,
		round(f.fail_count::numeric / t.total_count, 4) as fail_rate
	from measure_table_1_total t
	join measure_table_1_fail f on (t.name = f.name)
	order by fail_rate
	limit 1;
;


-- The following 2 functions are for COMP3311 2016 to 2019
-- Use the mymy2 database
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
);

-- Q5b
create or replace view Q5b(term, min_fail_rate)
as
--... SQL statements, possibly using other views/functions defined by you ...

	select
		t.name,
--		f.fail_count,
--		t.total_count,
		round(f.fail_count::numeric / t.total_count, 4) as fail_rate
	from measure_table_2_total t
	join measure_table_2_fail f on (t.name = f.name)
	order by fail_rate
	limit 1;
;

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


create or replace view termtranscipt_table_1 as (
	select
		p.unswid,
		ce.course,
		ce.mark,
		ce.grade,
		CAST (termName(t.id) AS char(4)),
		s.uoc
	from course_enrolments ce
	join courses c on (ce.course = c.id)
	join students st on (ce.student = st.id)
	join people p on (st.id = p.id)
	join terms t on (c.term = t.id)
	join subjects s on (c.subject = s.id)
);


-- Q8
create type TermTranscriptRecord as (
        term  		char(4), -- term code (e.g. 98s1)
        termwam  	integer, -- numeric term WAM acheived
        termuocpassed   integer  -- units of credit passed this term
);

create or replace function
	Q8(zid integer) returns setof TermTranscriptRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...

declare
	tuple record;
	final TermTranscriptRecord;

	previous_term char(4) := '';
	
	_termwam integer := 0;
	mu_sum integer := 0;
	overall_mu integer := 0;

	_termuocpassed integer := 0;
	uoc_sum integer := 0;
	overall_uoc integer := 0;
begin
	-- Loop through each row in the table
	for tuple in
		select *
		from termtranscipt_table_1
		where unswid = $1
		order by termname asc
	loop
		-- If student id is invalid
		-- if (not found) then
		--  	exit;
		-- end if;
		
		-- For the first case since previous_term is NULL
		if (previous_term = '') then
			previous_term := tuple.termname;
		end if;
		
		-- Update term wam
		if(tuple.termname = previous_term and tuple.mark is not null) then
			mu_sum := mu_sum + tuple.mark * tuple.uoc;
			overall_mu := overall_mu + tuple.mark * tuple.uoc;
			
			uoc_sum := uoc_sum + tuple.uoc;
			
			-- Update termuocpassed
			if(tuple.grade = 'SY' or 
				tuple.grade = 'PT' or
				tuple.grade = 'PC' or
				tuple.grade = 'PS' or
				tuple.grade = 'CR' or
				tuple.grade = 'DN' or
				tuple.grade = 'HD' or
				tuple.grade = 'A' or
				tuple.grade = 'B' or
				tuple.grade = 'C' or
				tuple.grade = 'XE' or
				tuple.grade = 'T' or
				tuple.grade = 'PE' or
				tuple.grade = 'RC' or
				tuple.grade = 'RS'
			) then
				_termuocpassed := _termuocpassed + tuple.uoc;
				overall_uoc := overall_uoc + tuple.uoc;
			end if;

		-- If course mark is NULL then continue to next iteration
		elsif(tuple.termname = previous_term and tuple.mark is null) then
			
			-- Update termuocpassed
			if(tuple.grade = 'SY' or 
				tuple.grade = 'PT' or
				tuple.grade = 'PC' or
				tuple.grade = 'PS' or
				tuple.grade = 'CR' or
				tuple.grade = 'DN' or
				tuple.grade = 'HD' or
				tuple.grade = 'A' or
				tuple.grade = 'B' or
				tuple.grade = 'C' or
				tuple.grade = 'XE' or
				tuple.grade = 'T' or
				tuple.grade = 'PE' or
				tuple.grade = 'RC' or
				tuple.grade = 'RS'
			) then
				_termuocpassed := _termuocpassed + tuple.uoc;
				overall_uoc := overall_uoc + tuple.uoc;
			end if;

			continue;

		-- If we have a new term, store data and continue
		else
			final.term = previous_term;
			final.termwam = ROUND(mu_sum::NUMERIC / uoc_sum::NUMERIC);
			final.termuocpassed = _termuocpassed;
			return next final;

			-- Re-initialise variables
			previous_term = tuple.termname;
			mu_sum = 0;
			uoc_sum = 0;
			_termuocpassed = 0;

			-- Repeat update on termwam and termuocpassed
			if(tuple.termname = previous_term) then
				mu_sum := mu_sum + tuple.mark * tuple.uoc;
				overall_mu := overall_mu + tuple.mark * tuple.uoc;
			
				uoc_sum := uoc_sum + tuple.uoc;

				-- Update termuocpassed
				if(tuple.grade = 'SY' or 
					tuple.grade = 'PT' or
					tuple.grade = 'PC' or
					tuple.grade = 'PS' or
					tuple.grade = 'CR' or
					tuple.grade = 'DN' or
					tuple.grade = 'HD' or
					tuple.grade = 'A' or
					tuple.grade = 'B' or
					tuple.grade = 'C' or
					tuple.grade = 'XE' or
					tuple.grade = 'T' or
					tuple.grade = 'PE' or
					tuple.grade = 'RC' or
					tuple.grade = 'RS'
				) then
					_termuocpassed := _termuocpassed + tuple.uoc;
					overall_uoc := overall_uoc + tuple.uoc;
				end if;

			elsif(tuple.mark is NULL) then
				-- Update termuocpassed
				if(tuple.grade = 'SY' or 
					tuple.grade = 'PT' or
					tuple.grade = 'PC' or
					tuple.grade = 'PS' or
					tuple.grade = 'CR' or
					tuple.grade = 'DN' or
					tuple.grade = 'HD' or
					tuple.grade = 'A' or
					tuple.grade = 'B' or
					tuple.grade = 'C' or
					tuple.grade = 'XE' or
					tuple.grade = 'T' or
					tuple.grade = 'PE' or
					tuple.grade = 'RC' or
					tuple.grade = 'RS'
				) then
					_termuocpassed := _termuocpassed + tuple.uoc;
					overall_uoc := overall_uoc + tuple.uoc;
				end if;

				continue;

			end if;

		end if;

	end loop;
		
		-- Last row of table being updated
		final.term = previous_term;
		final.termwam = ROUND(mu_sum::NUMERIC / uoc_sum::NUMERIC);
		final.termuocpassed = _termuocpassed;
		return next final;

		-- Add final row for OVAL
		final.term = 'OVAL';
		final.termwam = ROUND(overall_mu::NUMERIC / overall_uoc::NUMERIC);
		final.termuocpassed = overall_uoc;
		return next final;
end

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

