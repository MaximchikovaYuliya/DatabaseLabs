USE M_MyBase;

INSERT into ����������(��������, ����, ������)
values	('��� �����', 24, 11.3),
		('��� �������', 12, 9.8);

SELECT count(*) From ������; 
SELECT * From ����������;

USE MAXIMCHIKOVA_UNIVER;

CREATE table STUDENTS
(	NumberOfStudentBook int primary key,
	FullName nvarchar(30) not NULL,
	Birthday date not NULL,
	Sex nchar(1) default '�' check (Sex in ('�', '�')),
	DateOfEntering date not NULL,
);

INSERT into STUDENTS(NumberOfStudentBook, FullName, Birthday, Sex, DateOfEntering)
values	(5678907, '������ ���� ����������', '2000-09-21', '�', '2018-07-23'),
		(5677765, '������� ������� ����������', '2001-03-19', '�', '2018-07-21'),
		(7634575, '������ �������� �����������', '1998-06-21', '�', '2018-07-26'),
		(3465867, '������� ���� ����������', '1999-03-17', '�', '2017-08-11');

SELECT * From STUDENTS;
SELECT * From STUDENTS Where Sex='�' AND YEAR(DateOfEntering) - YEAR(Birthday) > 18;