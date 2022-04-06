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