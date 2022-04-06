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