use M_UNIVER;

--1
go
declare @sub char(20), @t char(300) = '';
declare ISITsub cursor for select SUBJECT from SUBJECT where PULPIT = '����';
	open ISITsub;
	fetch ISITsub into @sub;
	print '���������� �� ������� ����: ';
	while @@FETCH_STATUS = 0
		begin
			set @t = RTRIM(@sub) + ',' + @t;
			fetch ISITsub into @sub;
		end;
		print @t;
	close ISITsub;

--2
go
declare Teachers cursor global --local
	for select TEACHER_NAME, PULPIT from TEACHER;
declare @t char(100), @p char(20);
	open Teachers;
	fetch Teachers into @t, @p;
	print '1. ' + @t + ' ' + @p;
go
declare @t char(100), @p char(20);
	fetch Teachers into @t, @p;
	print '2. ' + @t + ' ' + @p;
	close Teachers;
	deallocate Teachers;

--3
go
declare Notes cursor local dynamic --static
	for select SUBJECT, NOTE from PROGRESS;
declare @s char(10), @n int;
	open Notes;
	print '���������� �����: ' + cast(@@cursor_rows as varchar(5));
	insert PROGRESS(SUBJECT, IDSTUDENT, PDATE, NOTE)
		values('����', 1006, GETDATE(), 9);
	fetch Notes into @s, @n;
	while @@FETCH_STATUS = 0
	begin 
		print @s + ' ' + cast(@n as varchar(1));
		fetch Notes into @s, @n;
	end;
	close Notes;

--4
go
DECLARE  @tc int, @rn char(50);  
DECLARE ScrollExmpl cursor local dynamic SCROLL                               
	for SELECT row_number() over (order by AUDITORIUM_NAME) N,
	                           AUDITORIUM_NAME FROM dbo.AUDITORIUM;
	OPEN ScrollExmpl;
	FETCH  ScrollExmpl into  @tc, @rn;                 
	print '��������� ������        : ' + cast(@tc as varchar(3)) + ' ' + rtrim(@rn);      
	FETCH  LAST from  ScrollExmpl into @tc, @rn;       
	print '��������� ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);      
	FETCH  FIRST from  ScrollExmpl into @tc, @rn;       
	print '������ ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);
	FETCH  PRIOR from  ScrollExmpl into @tc, @rn;       
	print '���������� ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);
	FETCH  ABSOLUTE 3 from  ScrollExmpl into @tc, @rn;       
	print '������ ������ �� ������ ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);
	FETCH  ABSOLUTE -3 from  ScrollExmpl into @tc, @rn;       
	print '������ ������ �� ����� ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);
	FETCH  RELATIVE 5 from  ScrollExmpl into @tc, @rn;       
	print '����� ������ ������ �� ������� ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);
	FETCH  RELATIVE -5 from  ScrollExmpl into @tc, @rn;       
	print '����� ������ ����� �� ������� ������          : ' +  cast(@tc as varchar(3)) + ' ' + rtrim(@rn);
    CLOSE ScrollExmpl;

--5
go
declare Notes cursor local dynamic
	for select SUBJECT, NOTE from PROGRESS for update;
declare @s char(10), @n int;
	open Notes;
	print '���������� �����: ' + cast(@@cursor_rows as varchar(5));
	fetch Notes into @s, @n;
	update PROGRESS set NOTE = NOTE + 1 where current of Notes;
	close Notes;

--6
go
declare PROGR cursor local for select IDSTUDENT, NOTE from PROGRESS for update;
declare @idstudent int, @note int;  
open PROGR;	  
	fetch PROGR into @idstudent, @note;
	while @@fetch_status=0
		begin
		if @note < 4  
			delete PROGRESS where current of PROGR;
		if @idstudent = 1000 
			update PROGRESS set NOTE += 1 where current of PROGR;
		fetch PROGR into @idstudent, @note;
	end 
close PROGR;
