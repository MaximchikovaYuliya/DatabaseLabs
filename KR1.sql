use KR1;

--1
create table Table1
(
	t1 int,
	t2 int
);

create table Table2
(
	t21 int identity(1,1),
	t22 date,
	t23 int
);

insert into Table1(t1, t2) values (-10, 0), (7, 7), (54, -9);
insert into Table2(t22, t23) values (GETDATE(), (select SUM(t1) + SUM(t2) from Table1));

select * from Table1;
select * from Table2;
go

--2
use M_UNIVER;

select AVG(NOTE)[AVG_NOTE] from PROGRESS;
go

--3
use M_UNIVER;

select FACULTY_NAME from FACULTY
		where not exists (select * from PULPIT where FACULTY.FACULTY = PULPIT.FACULTY);

select FACULTY_NAME from FACULTY
		where exists (select * from PULPIT where FACULTY.FACULTY = PULPIT.FACULTY);
go

--4
use KR1;
go
create view[Example] as select * from Table1;
go
insert into Example values(4, 5);
delete Example where t1 = 4;

select * from Example;
go

--5
use KR1;

insert into Table1 values(cast('5' as int), 8);
