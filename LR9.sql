use M_UNIVER;
go
--1
create view[�������������]
	as select TEACHER[���], TEACHER_NAME[���_�������������], GENDER[���], PULPIT[���_�������]
	from TEACHER;
go

 select * from �������������;

--2
go
create view[����������_������]
	as select f.FACULTY_NAME[���������], (select COUNT(*) from PULPIT p where p.FACULTY = f.FACULTY)[����������_������]
	from FACULTY f;
go

select * from ����������_������;

--3
go
create view[���������]
	as select AUDITORIUM[���], AUDITORIUM_TYPE[���_���������]
	from AUDITORIUM
	where AUDITORIUM_TYPE like '��%';

go
select * from ���������;
insert ��������� values('200-3�', '��');
delete ��������� where ��� = '200-3�';

--4
go
create view[����������_���������]
	as select AUDITORIUM[���], AUDITORIUM_TYPE[���_���������]
	from AUDITORIUM
	where AUDITORIUM_TYPE like '��%' with check option;

go
select * from ����������_���������;
insert ����������_��������� values('100-3�', '��');
--insert ����������_��������� values('200-3�', '��-�');
delete ����������_��������� where ��� = '100-3�';

--5
go
create view[����������]
	as select TOP 150 SUBJECT[���], SUBJECT_NAME[������������_����������], PULPIT[���_�������]
	from SUBJECT
	order by ������������_����������;

go
select * from ����������;

--6
go
alter view[����������] with schemabinding  
	as select f.FACULTY_NAME[���������], (select COUNT(*) from dbo.PULPIT p where p.FACULTY = f.FACULTY)[����������_������]
	from dbo.FACULTY f;