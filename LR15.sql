use M_UNIVER;
go

--1
create function COUNT_STUDENTS(@faculty varchar(20)) returns int
as begin declare @rc int = 0;
set @rc = (select COUNT(NAME) from STUDENT st join GROUPS gr
				on st.IDGROUP = gr.IDGROUP join FACULTY f
					on gr.FACULTY = f.FACULTY
						where f.FACULTY = @faculty);
return @rc;
end;
go

declare @c int = dbo.COUNT_STUDENTS('ÈÄèÏ');
print 'Count of students on faculty ÈÄèÏ: ' + cast(@c as varchar(4));
go

alter function dbo.COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null)
	returns int
	as begin declare @rc int = 0;
	set @rc = (select COUNT(NAME) from STUDENT st join GROUPS gr
				on st.IDGROUP = gr.IDGROUP join PROFESSION pr
					on gr.PROFESSION = pr.PROFESSION join FACULTY f
						on gr.FACULTY = f.FACULTY
							where f.FACULTY = @faculty and pr.QUALIFICATION like @prof);
	return @rc;
	end;
go

select f.FACULTY, QUALIFICATION, dbo.COUNT_STUDENTS(f.FACULTY, QUALIFICATION) from FACULTY f, PROFESSION;

go

--2
create function FSUBJECTS(@p varchar(20)) returns char(300)
as begin 
	declare @sub char(5);
	declare @s varchar(300) = 'Äèñöèïëèíû: ';
	declare SUB_CURSOR cursor local
		for select SUBJECT from SUBJECT where PULPIT = @p;
	open SUB_CURSOR;
    fetch  SUB_CURSOR into @sub;   	 
    while @@fetch_status = 0                                     
    begin 
        set @s = @s + ', ' + rtrim(@sub);         
        FETCH  SUB_CURSOR into @sub; 
    end;    
	return @s;
end; 
go 

select PULPIT, dbo.FSUBJECTS(PULPIT) from PULPIT;
go

--3
create function FFACPUL(@f varchar(10), @p varchar(20)) returns table
as return 
	select f.FACULTY, p.PULPIT from FACULTY f
		left outer join PULPIT p
			on f.FACULTY = p.FACULTY
				where f.FACULTY = ISNULL(@f, f.FACULTY)
				and p.PULPIT = ISNULL(@p, p.PULPIT);
go

select * from dbo.FFACPUL(NULL,NULL);
select * from dbo.FFACPUL('ÈÄèÏ',NULL);
select * from dbo.FFACPUL(NULL,'ËÌèËÇ');
select * from dbo.FFACPUL('ÈÄèÏ','ËÌèËÇ');
go

--4
create function FCTEACHER(@p varchar(20)) returns int
as begin 
	declare @rc int = (select COUNT(*) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
	return @rc;
end;
go

select PULPIT, dbo.FCTEACHER(PULPIT) from PULPIT [COUNT OF TEACHERS];
select dbo.FCTEACHER(NULL) [ALL TEACHERS];
go

--5
create function FACULTY_REPORT_PULPIT(@f varchar(5)) returns int
as begin 
	declare @rc int = (select count(*) from PULPIT where FACULTY = @f);
	return @rc;
end;
go

create function FACULTY_REPORT_GROUP(@f varchar(5)) returns int
as begin 
	declare @rc int = (select count(*) from GROUPS where FACULTY = @f);
	return @rc;
end;
go

create function FACULTY_REPORT_STUDENT(@f varchar(5)) returns int
as begin 
	declare @rc int = (select count(*) from STUDENT st join GROUPS gr
							on st.IDGROUP = gr.IDGROUP where gr.FACULTY = @f);
	return @rc;
end;
go
