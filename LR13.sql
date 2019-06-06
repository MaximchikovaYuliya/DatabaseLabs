use KR1;

go
--1
set nocount on
if  exists (select * from  SYS.OBJECTS where OBJECT_ID= object_id(N'DBO.X') )	            
drop table X;           
declare @c int; 

SET IMPLICIT_TRANSACTIONS  ON 

CREATE table X(K int);              
INSERT X values (1),(2),(3);
set @c = (select count(*) from X);
print 'количество строк в таблице X: ' + cast( @c as varchar(2));
commit;  
                 
SET IMPLICIT_TRANSACTIONS  OFF

go
USE M_UNIVER; 
--2
begin try
	begin tran
		insert AUDITORIUM_TYPE values ('л', 'лаборатория');
		insert AUDITORIUM_TYPE values(NULL, 'лекционная');
	commit tran;
end try
begin catch
	print 'Ошибка: ' + error_message();
	if @@trancount>0 rollback tran;
end catch;

go
--3
declare @point varchar(32);
begin try
	begin tran
		insert AUDITORIUM_TYPE values ('ЛБ', 'лаборатория');
		set @point='p1';save tran @point;
		insert AUDITORIUM_TYPE values(NULL, 'лекционная');
		set @point='p2';save tran @point;
	commit tran;
end try
begin catch
	print 'Ошибка: ' + error_message();
	if @@trancount>0
		begin
			print 'контрольная точка: ' + @point;
			rollback tran @point;
			commit tran
		end;
end catch;

go
--4
set transaction isolation level READ UNCOMMITTED 
	begin transaction 
	-------------------------- t1 ------------------
	select @@SPID, 'update AUDITORIUM'  'результат', 
		AUDITORIUM, AUDITORIUM_NAME from AUDITORIUM  
	    where AUDITORIUM.AUDITORIUM='105-3';
	commit; 
	-------------------------- t2 -----------------
	--- B --	
	begin transaction 
	select @@SPID
	insert AUDITORIUM values ('105-3','ЛК',90,'105-3'); 
	-------------------------- t1 --------------------
	-------------------------- t2 --------------------
	rollback;
go 
--5

begin transaction 
	select count(*) from AUDITORIUM 
	where AUDITORIUM.AUDITORIUM='105-3';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  'update AUDITORIUM'  'результат', count(*)
	from AUDITORIUM where AUDITORIUM.AUDITORIUM='105-3';
	commit; 
	--- B ---
	begin transaction 	  
	-------------------------- t1 --------------------
    update AUDITORIUM set AUDITORIUM.AUDITORIUM='105-3'
		where AUDITORIUM.AUDITORIUM='105-5';
    commit; 
	-------------------------- t2 --------------------	
go
--6

set transaction isolation level REPEATABLE READ 
	begin transaction 
	select AUDITORIUM from AUDITORIUM where AUDITORIUM_NAME = '105-3';
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select  case
          when AUDITORIUM = '105-5' then 'insert  AUDITORIUM'  else ' ' 
	end 'результат', AUDITORIUM from AUDITORIUM  where AUDITORIUM_NAME = '105-3';
	commit; 
	--- B ---	
	begin transaction 	  
	-------------------------- t1 --------------------
    insert AUDITORIUM values ('6005-3','ЛК',90,'6005-3');
    commit; 
	-------------------------- t2 --------------------
go

--7
    set transaction isolation level SERIALIZABLE 
	begin transaction 
	delete AUDITORIUM where AUDITORIUM = '105-5';  
    insert AUDITORIUM values ('105-5','ЛК',90,'105-5');
	select AUDITORIUM from AUDITORIUM a where a.AUDITORIUM_NAME = '105-5';
	-------------------------- t1 -----------------
	select AUDITORIUM from AUDITORIUM a where a.AUDITORIUM_NAME = '105-5';
	-------------------------- t2 ------------------ 
	--rollback
	commit; 	
	--- B ---	
	begin transaction 	  
	delete AUDITORIUM where AUDITORIUM = '105-5';  
    insert AUDITORIUM values ('105-5','ЛК',90,'105-5');
	select AUDITORIUM from AUDITORIUM a where a.AUDITORIUM_NAME = '105-5';
          -------------------------- t1 --------------------
    commit; 
	select AUDITORIUM from AUDITORIUM a where a.AUDITORIUM_NAME = '105-5';
go

--8
use master;
go
alter database GON_UNIVER set allow_snapshot_isolation on
use M_UNIVER
go
	--- A ---
	set transaction isolation level SNAPSHOT 
	begin transaction 
	select AUDITORIUM from AUDITORIUM where AUDITORIUM_NAME = '105-3';
	-------------------------- t1 ------------------  
    insert AUDITORIUM values ('7005-2','ЛК',90,'7005-3');
	--delete AUDITORIUM where AUDITORIUM_NAME = '105-3'
	-------------------------- t2 -----------------
	select  AUDITORIUM from AUDITORIUM  where AUDITORIUM_NAME = '105-3';
	commit; 
	--- B ---	
	go
	begin transaction 	  
	-------------------------- t1 --------------------
    insert AUDITORIUM values ('8005-3','ЛК',90,'8005-3');
    commit;
	-------------------------- t2 -----------------
	--rollback;
go



