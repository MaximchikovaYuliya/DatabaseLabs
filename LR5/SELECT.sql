use M_UNIVER;

select * from FACULTY;
select TEACHER, PULPIT from TEACHER;
select TEACHER_NAME from TEACHER where PULPIT='����';
select TEACHER_NAME from TEACHER where PULPIT='����' or PULPIT='������';
select TEACHER_NAME from TEACHER where PULPIT='����' and GENDER='�';
select TEACHER_NAME[��� �������������] from TEACHER where PULPIT='����' and GENDER!='�';
select distinct PULPIT from TEACHER;
select * from AUDITORIUM order by AUDITORIUM_CAPACITY;
select distinct top(2) * from AUDITORIUM order by AUDITORIUM_CAPACITY desc;
select distinct SUBJECT from PROGRESS where NOTE between 8 and 10;
select distinct SUBJECT from SUBJECT where PULPIT in ('�����', '������', '��');
select PROFESSION_NAME, QUALIFICATION from PROFESSION where QUALIFICATION Like '%�����%';
