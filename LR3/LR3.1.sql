USE master;
CREATE database MAXIMCHIKOVA_UNIVER;

USE MAXIMCHIKOVA_UNIVER;

CREATE TABLE STUDENT
(	NumberStudentBook int primary key,
	Surname nvarchar(15),
	GroupNumber tinyint
)

ALTER Table STUDENT ADD DateOfEntering date;

INSERT into STUDENT(NumberStudentBook, Surname, GroupNumber, DateOfEntering)
values	(5678907, 'Иванов', 1, '2017-07-25'),
		(3465867, 'Петрова', 2, '2018-07-27'),
		(2344675, 'Кривец', 1, '2016-07-23'),
		(5654654, 'Кутебо', 3, '2017-07-25'),
		(3456689, 'Макаренко', 2, '2018-07-27'),
		(8976234, 'Зайцева', 3, '2018-07-27'),
		(0897623, 'Лапатин', 1, '2017-07-25'),
		(6875749, 'Сидоренко', 2, '2016-07-23');

SELECT * From STUDENT;
SELECT Surname From STUDENT;
SELECT NumberStudentBook, Surname From STUDENT;
SELECT count(*) From STUDENT;

UPDATE STUDENT set GroupNumber=5;
DELETE From STUDENT Where NumberStudentBook=5678907;
SELECT * From STUDENT;

DROP table STUDENT;

USE MAXIMCHIKOVA_UNIVER;

CREATE table STUDENT
(	NumberOfStudentBook int primary key,
	Name nvarchar(15) not NULL
);

INSERT into STUDENT(NumberOfStudentBook, Name)
values	(5678907, 'Иванов'),
		(3465867, 'Петрова');
		--(2344675, null);

SELECT * From STUDENT;

--UPDATE STUDENT set Name=null;

DROP table STUDENT;

CREATE table STUDENT
(	NumberOfStudentBook int primary key,
	Name nvarchar(15) not NULL,
	Sex nchar(1) default 'м' check (Sex in ('м', 'ж'))
);

INSERT into STUDENT(NumberOfStudentBook, Name, Sex)
values	(5678907, 'Иванов', default);
		--(3465867, 'Петрова', 'с');

--UPDATE STUDENT set Sex='р';

DROP table STUDENT;

CREATE table RESULTS
(	ID int primary key identity(1, 1),
	StudentName nvarchar(15),
	BDResult int,
	OOPREsult int,
	AverageValue as (BDResult + OOPResult)/2
);

INSERT into RESULTS(StudentName, BDResult, OOPResult)
	values	('Петров', 9, 8);

SELECT * From RESULTS;