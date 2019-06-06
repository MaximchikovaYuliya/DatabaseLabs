use M_UNIVER;
go
--1
create procedure PSUBJECT
as
begin
	declare @k int = (select count(*) from SUBJECT);
	select SUBJECT[Код], SUBJECT_NAME[Дисциплина], PULPIT[Кафедра] from SUBJECT;
	return @k;
end;

declare @c int = 0;
exec @c = PSUBJECT;
print 'кол-во предметов = ' + cast(@c as varchar(3));
go

--2
ALTER procedure PSUBJECT @p varchar(20) = NULL, @c int output
as
begin
	declare @k int = (select count(*) from SUBJECT);
	print 'параметры: @p = ' +@p + ', @c = ' + cast(@c as varchar(3));
	select SUBJECT[Код], SUBJECT_NAME[Дисциплина], PULPIT[Кафедра] from SUBJECT
			where PULPIT = @p;
	set @c = @@ROWCOUNT;
	return @k;
end;

declare @m int = 0, @r int = 0;
exec @m = PSUBJECT @p='ИСиТ', @c = @r output;
print 'кол-во предметов всего: ' + cast(@m as varchar(3));
print 'кол-во предметов, на кафедре ИСиТ: ' + cast(@r as varchar(3));
go

--3
alter procedure PSUBJECT @p varchar(20)
as begin
	declare @k int = (select count(*) from SUBJECT);
	select SUBJECT[Код], SUBJECT_NAME[Дисциплина], PULPIT[Кафедра] from SUBJECT
			where PULPIT = @p;
end;

create table #SUBJECT
(
	SUBJECT char(10) primary key,
	SUBJECT_NAME varchar(100),
	PULPIT char(20)
)

insert #SUBJECT exec PSUBJECT @p = 'ИСиТ';
select* from #SUBJECT;
go

--4
create procedure PAUDITORIUM_INSERT @a char(20), @n varchar(50),
									@c int = 0, @t char(10)
as declare @rc int =1;
begin try
	insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
			values (@a, @t, @c, @n);
	return @rc;
end try
begin catch
	print 'error number: ' + cast(error_number() as varchar(6));
	print 'error message: ' + error_message();
	print 'error severity: ' + cast(error_severity() as varchar(6));
	print 'error state: ' + cast(error_state() as varchar(8));
	print 'error line: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null
		print 'procedure name: ' + error_procedure();
	return -1;
end catch;

declare @rd int;
exec @rd = PAUDITORIUM_INSERT @a='fff', @n='frefref', @c=250, @t = 'лкl';
print 'error number: ' + cast(@rd as varchar(3));
go

--5
create procedure SUBJECT_REPORT @p char(10)
as
declare @rc int = 0;
begin try
	declare @sub char(20), @t char(300)='';
	declare Sub CURSOR for
	select SUBJECT_NAME from SUBJECT where PULPIT=@p;
	if not exists (select SUBJECT_NAME from SUBJECT where PULPIT=@p)
		raiserror('error', 11,1);
	else
		open Sub;
		fetch Sub into @sub;
		print 'Subjects: ';
		while @@FETCH_STATUS = 0
		begin
			set @t = RTRIM(@sub) +',' + @t;
			set @rc = @rc + 1;
			fetch Sub into @sub;
		end;
		print @t;
		close Sub;
		return @rc;
end try
begin catch
	print 'error in parameters'
	if ERROR_PROCEDURE() is not null
		print 'procedure name: ' + error_procedure();
	return @rc;
end catch;

declare @rd int;
exec @rd = SUBJECT_REPORT @p = 'ИСиТ';
print 'subject count = ' + cast(@rd as varchar(3));
go

--6
create procedure PAUDITORIUM_INSERTX @a char(20), @n varchar(50),
									@c int = 0, @t char(10), @tn varchar(50)
as
declare @rc int = 1;
begin try
	set transaction isolation level SERIALIZABLE;
	begin tran
	insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
			values (@a, @t, @c, @n);
	exec @rc=PAUDITORIUM_INSERT @a, @t, @c,@n;
	commit tran;
	return @rc;
end try
begin catch
	print 'error number: ' + cast(error_number() as varchar(6));
	print 'error message: ' + error_message();
	print 'error severity: ' + cast(error_severity() as varchar(6));
	print 'error state: ' + cast(error_state() as varchar(8));
	print 'error line: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null
		print 'procedure name: ' + error_procedure();
		if @@TRANCOUNT>0 rollback tran;
	return -1;
end catch;