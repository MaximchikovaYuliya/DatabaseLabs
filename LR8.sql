use M_UNIVER;

--1
select	max(AUDITORIUM_CAPACITY)[MAXCAPACITY],
		min(AUDITORIUM_CAPACITY)[MINCAPACITY],
		sum(AUDITORIUM_CAPACITY)[MAINCAPACITY],
		avg(AUDITORIUM_CAPACITY)[AVGCAPACITY],
		COUNT(*)[COUNT]
from AUDITORIUM;
--2
select	AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
		max(AUDITORIUM_CAPACITY)[MAXCAPACITY],
		min(AUDITORIUM_CAPACITY)[MINCAPACITY],
		sum(AUDITORIUM_CAPACITY)[MAINCAPACITY],
		avg(AUDITORIUM_CAPACITY)[AVGCAPACITY],
		COUNT(*)[COUNT] 
from AUDITORIUM inner join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	group by AUDITORIUM_TYPENAME;
--3
select * from 
		(select case
			when NOTE = 10 then '10'
			when NOTE between 8 and 9 then '8-9'
			when NOTE between 6 and 7 then '6-7'
			when NOTE between 4 and 5 then '4-5'
			end[NOTERANGE], COUNT(*)[COUNT] 
		from PROGRESS group by case
							when NOTE = 10 then '10'
							when NOTE between 8 and 9 then '8-9'
							when NOTE between 6 and 7 then '6-7'
							when NOTE between 4 and 5 then '4-5'
							end) as t order by case[NOTERANGE]
										when '10' then 1
										when '8-9' then 2
										when '6-7' then 3
										when '4-5' then 4
										end;
--4
select f.FACULTY, g.PROFESSION, g.YEAR_FIRST, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from FACULTY f inner join GROUPS g
		on f.FACULTY = g.FACULTY inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST order by AVGNOTE desc;
--5
select f.FACULTY, g.PROFESSION, g.YEAR_FIRST, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from FACULTY f inner join GROUPS g
		on f.FACULTY = g.FACULTY inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where p.SUBJECT in ('ясад', 'нюХо')
		group by f.FACULTY, g.PROFESSION, g.YEAR_FIRST order by AVGNOTE desc;
--6
select f.FACULTY, g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from FACULTY f inner join GROUPS g
		on f.FACULTY = g.FACULTY inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where f.FACULTY = 'рнб'
		group by rollup(f.FACULTY, g.PROFESSION, p.SUBJECT);
--7
select f.FACULTY, g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from FACULTY f inner join GROUPS g
		on f.FACULTY = g.FACULTY inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where f.FACULTY = 'рнб'
		group by cube(f.FACULTY, g.PROFESSION, p.SUBJECT);
--8
select g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from GROUPS g inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where g.FACULTY = 'рнб'
		group by g.PROFESSION, p.SUBJECT
		union
select g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from GROUPS g inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where g.FACULTY = 'урхр'
		group by g.PROFESSION, p.SUBJECT;
--9
select g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from GROUPS g inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where g.FACULTY = 'рнб'
		group by g.PROFESSION, p.SUBJECT
		intersect
select g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from GROUPS g inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where g.FACULTY = 'урхр'
		group by g.PROFESSION, p.SUBJECT;
--10
select g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from GROUPS g inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where g.FACULTY = 'рнб'
		group by g.PROFESSION, p.SUBJECT
		except
select g.PROFESSION, p.SUBJECT, ROUND(AVG(CAST(p.NOTE as float(4))), 2)[AVGNOTE] from GROUPS g inner join STUDENT s
		on g.IDGROUP = s.IDGROUP inner join PROGRESS p
		on s.IDSTUDENT = p.IDSTUDENT
		where g.FACULTY = 'урхр'
		group by g.PROFESSION, p.SUBJECT;
--11
select SUBJECT, NOTE, (select COUNT(*) from PROGRESS p2 where p2.SUBJECT = p1.SUBJECT and p2.NOTE = p1.NOTE)[COUNT]
		from PROGRESS p1
		group by SUBJECT, NOTE
		having NOTE in (8, 9);