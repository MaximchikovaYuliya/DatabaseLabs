use M_UNIVER;
go
--1
create view[Преподаватель]
	as select TEACHER[Код], TEACHER_NAME[Имя_преподавателя], GENDER[Пол], PULPIT[Код_кафедры]
	from TEACHER;
go

 select * from Преподаватель;

--2
go
create view[Количество_кафедр]
	as select f.FACULTY_NAME[Факультет], (select COUNT(*) from PULPIT p where p.FACULTY = f.FACULTY)[Количество_кафедр]
	from FACULTY f;
go

select * from Количество_кафедр;

--3
go
create view[Аудитории]
	as select AUDITORIUM[Код], AUDITORIUM_TYPE[Тип_аудитории]
	from AUDITORIUM
	where AUDITORIUM_TYPE like 'ЛК%';

go
select * from Аудитории;
insert Аудитории values('200-3а', 'ЛК');
delete Аудитории where Код = '200-3а';

--4
go
create view[Лекционные_аудитории]
	as select AUDITORIUM[Код], AUDITORIUM_TYPE[Тип_аудитории]
	from AUDITORIUM
	where AUDITORIUM_TYPE like 'ЛК%' with check option;

go
select * from Лекционные_аудитории;
insert Лекционные_аудитории values('100-3а', 'ЛК');
--insert Лекционные_аудитории values('200-3а', 'ЛБ-К');
delete Лекционные_аудитории where Код = '100-3а';

--5
go
create view[Дисциплины]
	as select TOP 150 SUBJECT[Код], SUBJECT_NAME[Наименование_дисциплины], PULPIT[Код_кафедры]
	from SUBJECT
	order by Наименование_дисциплины;

go
select * from Дисциплины;

--6
go
alter view[Дисциплины] with schemabinding  
	as select f.FACULTY_NAME[Факультет], (select COUNT(*) from dbo.PULPIT p where p.FACULTY = f.FACULTY)[Количество_кафедр]
	from dbo.FACULTY f;