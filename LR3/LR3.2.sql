USE M_MyBase;

INSERT into ВидКредита(Название, Срок, Ставка)
values	('Для учебы', 24, 11.3),
		('Для бизнеса', 12, 9.8);

SELECT count(*) From Клиент; 
SELECT * From ВидКредита;

USE MAXIMCHIKOVA_UNIVER;

CREATE table STUDENTS
(	NumberOfStudentBook int primary key,
	FullName nvarchar(30) not NULL,
	Birthday date not NULL,
	Sex nchar(1) default 'м' check (Sex in ('м', 'ж')),
	DateOfEntering date not NULL,
);

INSERT into STUDENTS(NumberOfStudentBook, FullName, Birthday, Sex, DateOfEntering)
values	(5678907, 'Иванов Иван Николаевич', '2000-09-21', 'м', '2018-07-23'),
		(5677765, 'Романов Николай Николаевич', '2001-03-19', 'м', '2018-07-21'),
		(7634575, 'Кияева Ангелина Анатольевна', '1998-06-21', 'ж', '2018-07-26'),
		(3465867, 'Петрова Нина Викторовна', '1999-03-17', 'ж', '2017-08-11');

SELECT * From STUDENTS;
SELECT * From STUDENTS Where Sex='ж' AND YEAR(DateOfEntering) - YEAR(Birthday) > 18;