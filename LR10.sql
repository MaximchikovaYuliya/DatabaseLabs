--1
use M_UNIVER
declare @c char = 'c',
		@v varchar = 'v',
		@d datetime,
		@t time,
		@i int,
		@s smallint,
		@ti tinyint,
		@n numeric(12,5);

set @d = GETDATE(); set @i = (select count(*) from STUDENT);

select @ti = 10, @s = 50;

select @c c, @v v, @d d, @t t;
print @i; print @s; print @ti; print @n;
go

--2
declare @y1 numeric(8,3) = (select CAST(SUM(AUDITORIUM_CAPACITY) as numeric(8,3)) from AUDITORIUM),
		@y2 numeric(8,3),
		@y3 numeric(8,3),
		@y4 numeric(8,3);

if @y1 > 200
begin
	select	@y2 = (select CAST(COUNT(*) as numeric(8,3)) from AUDITORIUM),
			@y3 = (select CAST(AVG(AUDITORIUM_CAPACITY) as numeric(8,3)) from AUDITORIUM);

	set @y4 = (select CAST(COUNT(*) as numeric(8,3)) from AUDITORIUM where AUDITORIUM_CAPACITY < @y3);

	select @y1 y1, @y2 y2, @y3 y3, @y4 y4, @y4/@y2*100 '%';
end
else
	print 'Общая вместимость меньше 200 и равна ' + CAST((@y1) as varchar(5));
go

--3
print 'число обработанных строк :'+ CAST(@@ROWCOUNT as varchar(20)); 
print 'версия SQL Server: ' + CAST(@@VERSION as varchar(150));
print 'системный идентификатор процесса, назначенный сервером текущему подключению: ' + CAST(@@SPID as varchar(20)); 
print 'код последней ошибки: ' + CAST(@@ERROR as varchar(20)); 
print 'имя сервера: ' + CAST(@@SERVERNAME as varchar(50)); 
print 'уровень вложенности транзакции: ' + CAST(@@TRANCOUNT as varchar(20)); 
print 'проверка результата считывания строк результирующего набора: ' + CAST(@@FETCH_STATUS as varchar(20)); 
print 'уровень вложенности текущей процедуры: ' + CAST(@@NESTLEVEL as varchar(20));
go

--4
declare @t int = 5, @x float = 3, @z float;
if (@t > @x)
	set @z = SIN(@t)*SIN(@t);
else if (@t < @x)
	set @z = 4*(@t + @x);
else
	set @z = 1 - POWER(EXP(1), @x - 2)
print 'z = ' + CAST(@z as varchar(10));
go

-------

declare @name varchar(50) = 'Макейчик Татьяна Леонидовна',
		@fist_name nvarchar(50), 
		@midle_name nvarchar(50), 
		@last_name nvarchar(50), 
		@position_one int, 
		@position_two int; 

set @position_one = CHARINDEX(' ', @name); 
set @position_two = LEN(@name) - CHARINDEX(' ', REVERSE(@name)); 
set @fist_name = SUBSTRING(@name, 0, @position_one) 
set @midle_name = SUBSTRING(@name, @position_one + 1, 1); 
set @last_name = SUBSTRING(@name, @position_two + 2, 1); 

print @fist_name + ' ' + @midle_name + '.' + @last_name + '.'; 
go

-----

declare @month int = DATEPART(month,SYSDATETIME()) + 1; 
select NAME, BDAY, DATEPART(year,SYSDATETIME()) - DATEPART(year,BDAY)[AGE] 
	from STUDENT WHERE DATEPART(month, BDAY) = @month;
go

----

declare @group int = 4; 
select s.NAME,	CASE DATEPART(dw,p.PDATE) 
					WHEN 1 THEN 'Monday' 
					WHEN 2 THEN 'Tuesday' 
					WHEN 3 THEN 'Wednesday' 
					WHEN 4 THEN 'Thursday' 
					WHEN 5 THEN 'Friday' 
					WHEN 6 THEN 'Saturday' 
					WHEN 7 THEN 'Sunday' 
				END [DAY_OF_WEEK] 
FROM STUDENT s JOIN PROGRESS p ON s.IDSTUDENT = p.IDSTUDENT 
	WHERE s.IDGROUP = @group AND p.[SUBJECT] = 'СУБД'; 
go

--5
declare @x int = (select count(*) from AUDITORIUM);
if(@x > 5)
begin
	print 'Количество аудиторий больше 5';
	print 'Количество = ' + CAST(@x as varchar(5));
end;
else
begin
	print 'Количество аудиторий меньше 5';
	print 'Количество = ' + CAST(@x as varchar(5));
end;
go

--6
select case
	when NOTE between 9 and 10 then '9-10'
	when NOTE between 7 and 8 then '7-8'
	when NOTE between 4 and 6 then '4-6'
	end NOTE, count(*)[COUNT]
from dbo.PROGRESS
group by case 
	when NOTE between 9 and 10 then '9-10'
	when NOTE between 7 and 8 then '7-8'
	when NOTE between 4 and 6 then '4-6'
	end
go

--7
create table #EXAMPLE
(
	ID int primary key,
	NAME varchar(10),
	AGE int
);
declare @i int = 0;
while @i < 10
	begin
	insert #EXAMPLE(ID, NAME, AGE)
		values(FLOOR(30000 * RAND()), 'Анна', 19);
	set @i = @i + 1;
	end;
go

--8
declare @x int = 1;
print @x + 1;
print @x + 2;
return
print @x + 3;
go

--9
begin try
	update dbo.STUDENT set IDSTUDENT = '999'
			where IDSTUDENT = '1000'
end try
begin catch
	print ERROR_NUMBER()
	print ERROR_MESSAGE()
	print ERROR_LINE()
	print ERROR_PROCEDURE()
	print ERROR_SEVERITY()
	print ERROR_STATE()
end catch
