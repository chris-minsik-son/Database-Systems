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

-- List of students taking COMP3311 from 2016 to 2019
create or replace view students_comp3311_2016_2019
as
	select *
	from students_comp3311
	where year >= 2016 and year <= 2019;
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