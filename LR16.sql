use M_UNIVER;
go

--1
create table TR_AUDIT
(
	ID int identity,
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)
go

create trigger TR_TEACHER_INS on TEACHER after INSERT
as declare @a1 varchar(100), @a2 char(1), @a3 char(20), @in varchar(300);
print 'Insert';
set @a1 = (select [TEACHER_NAME] from inserted);
set @a2 = (select [GENDER] from inserted);
set @a3 = (select [PULPIT] from inserted);
set @in = @a1 + ' ' + @a2 + ' ' + @a3;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER_INS', @in);
return;
go

insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ИИИ', 'Иванов Иван Иванович', 'м', 'ИСиТ');
select * from TR_AUDIT;
go

--2
create trigger TR_TEACHER_DEL on TEACHER after DELETE
as declare @a1 varchar(100), @a2 char(1), @a3 char(20), @in varchar(300);
print 'Delete';
set @a1 = (select [TEACHER_NAME] from deleted);
set @a2 = (select [GENDER] from deleted);
set @a3 = (select [PULPIT] from deleted);
set @in = @a1 + ' ' + @a2 + ' ' + @a3;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER_DEL', @in);
return;
go

delete from TEACHER where TEACHER = 'ИИИ';
select * from TR_AUDIT;
go

--3
create trigger TR_TEACHER_UPD on TEACHER after UPDATE
as declare @a1 varchar(100), @a2 char(1), @a3 char(20), @in varchar(300);
print 'Update';
set @a1 = (select [TEACHER_NAME] from inserted);
set @a2 = (select [GENDER] from inserted);
set @a3 = (select [PULPIT] from inserted);
set @in = @a1 + ' ' + @a2 + ' ' + @a3;
set @a1 = (select [TEACHER_NAME] from deleted);
set @a2 = (select [GENDER] from deleted);
set @a3 = (select [PULPIT] from deleted);
set @in = @in + ' ' + @a1 + ' ' + @a2 + ' ' + @a3;
insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD', 'TR_TEACHER_UPD', @in);
return;
go

update TEACHER set TEACHER = 'ИАИ' where TEACHER_NAME = 'Иванов Иван Иванович';
select * from TR_AUDIT;
go

--4
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE
as declare @a1 varchar(100), @a2 char(1), @a3 char(20), @in varchar(300);
declare @ins int = (select count(*) from inserted),
		@del int = (select count(*) from deleted);
if @ins>0 and @del=0
begin
	print 'Insert';
	set @a1 = (select [TEACHER_NAME] from inserted);
	set @a2 = (select [GENDER] from inserted);
	set @a3 = (select [PULPIT] from inserted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3;
	insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER', @in);
end;
else
if @ins=0 and @del>0
begin
	print 'Delete';
	set @a1 = (select [TEACHER_NAME] from deleted);
	set @a2 = (select [GENDER] from deleted);
	set @a3 = (select [PULPIT] from deleted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3;
	insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER', @in);
	end;
else
if @ins>0 and @del>0
begin
	print 'Update';
	set @a1 = (select [TEACHER_NAME] from inserted);
	set @a2 = (select [GENDER] from inserted);
	set @a3 = (select [PULPIT] from inserted);
	set @in = @a1 + ' ' + @a2 + ' ' + @a3;
	set @a1 = (select [TEACHER_NAME] from deleted);
	set @a2 = (select [GENDER] from deleted);
	set @a3 = (select [PULPIT] from deleted);
	set @in = @in + ' ' + @a1 + ' ' + @a2 + ' ' + @a3;
	insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD', 'TR_TEACHER', @in);
end;
return;
go

insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('ИИИ', 'Иванов Иван Иванович', 'м', 'ИСиТ');
delete from TEACHER where TEACHER = 'ИИИ';
update TEACHER set TEACHER = 'ИАИ' where TEACHER_NAME = 'Иванов Иван Иванович';
select * from TR_AUDIT;
go

--5
update TEACHER set PULPIT = 'f' where TEACHER = 'ИАИ';
select * from TR_AUDIT;
go

--6
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE  
as print 'TR_TEACHER_DEL1';
 return;  
go 

create trigger TR_TEACHER_DEL2 on TEACHER after DELETE 
       as print 'TR_TEACHER_DEL2';
return;  
go  
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE  
       as print 'TR_TEACHER_DEL3';
 return;  
go 

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order = 'Last', @stmttype = 'DELETE';
go
   
select t.name, e.type_desc 
	from sys.triggers  t join  sys.trigger_events e  
		on t.object_id = e.object_id  
				where OBJECT_NAME(t.parent_id) = 'TEACHER' and 
					e.type_desc = 'DELETE';  
go

--7
create trigger TEAHER_TRAN
	on TEACHER after INSERT,DELETE,UPDATE
		as declare @c int = (select count(*) from TEACHER);
if (@c>22)
begin
	raiserror('max count <= 22',10,1);
	rollback;
end;
return;

insert into TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT) values ('fhf', 'Иванов Иван Иванович', 'м', 'ИСиТ');
go

--8
create trigger FACULTY_INSTEAD_OF
	on FACULTY instead of DELETE
		as raiserror('Removal is prohibited',10,1);
return;

delete from FACULTY where FACULTY = 'ТТЛП';

drop trigger TR_TEACHER_INS;
drop trigger TR_TEACHER_DEL;
drop trigger TR_TEACHER_UPD;
drop trigger TR_TEACHER_DEL1;
drop trigger TR_TEACHER_DEL2;
drop trigger TR_TEACHER_DEL3;
drop trigger TR_TEACHER
drop trigger TEAHER_TRAN;
drop trigger FACULTY_INSTEAD_OF;
go

--9
create  trigger DDL_M_UNIVER on database 
                          for DDL_DATABASE_LEVEL_EVENTS  as   
  declare @t varchar(50) =  EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
  declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)'); 
  if @t1 = 'TEACHER' 
  begin
       print 'Тип события: '+@t;
       print 'Имя объекта: '+@t1;
       print 'Тип объекта: '+@t2;
       raiserror( N'операции с таблицей TEACHER запрещены', 16, 1);  
       rollback;    
   end;
go

alter table TEACHER drop column TEACHER_NAME;
