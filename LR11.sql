use M_UNIVER;

--1
go
exec sp_helpindex 'AUDITORIUM';
exec sp_helpindex 'AUDITORIUM_TYPE';
exec sp_helpindex 'FACULTY';
exec sp_helpindex 'GROUPS';
exec sp_helpindex 'PROFESSION';
exec sp_helpindex 'PROGRESS';
exec sp_helpindex 'PULPIT';
exec sp_helpindex 'STUDENT';
exec sp_helpindex 'SUBJECT';
exec sp_helpindex 'TEACHER';
go

use tempdb;
--2
create table #EXMPL
(
	tint int,
	tfield varchar(100)
);

set nocount on;
declare @i int = 0;
while @i < 1000
begin
	insert #EXMPL(tint, tfield) values (FLOOR(2000*RAND()), REPLICATE('строка', 10));
	set @i = @i + 1;
end;

SELECT * FROM #EXMPL where tint between 1500 and 2500 order by tint;
checkpoint;
DBCC DROPCLEANBUFFERS;
CREATE clustered index #EXPLRE_CL on #EXMPL(tint asc);
go

--3
 create table #EXMPL1
(
	tkey int,
	CC int identity(1,1),
	tf varchar(100)
);

set nocount on;
declare @i int = 0;
while @i < 20000
begin
	insert #EXMPL1(tkey, tf) values (FLOOR(30000*RAND()), REPLICATE('строка', 10));
	set @i = @i + 1;
end;

SELECT count(*)[количество строк] from #EXMPL1;
SELECT * from #EXMPL1;
CREATE index #EX_NONCLU on #EXMPL1(tkey, CC);
SELECT * from  #EXMPL1 where  tkey > 1500 and  CC < 4500;  
SELECT * from  #EXMPL1 order by  tkey, CC
SELECT * from  #EXMPL1 where  tkey = 556 and  CC > 3
go

--4
CREATE  index #EX_TKEY_X on #EXMPL1(tkey) INCLUDE (CC);
SELECT CC from #EXMPL1 where tkey > 15000;
go

--5
SELECT TKEY from  #EXMPL1 where tkey>15000 and  tkey < 20000;
CREATE  index #EX_WHERE on #EXMPL1(tkey) where (tkey>15000 and  tkey < 20000);
go  

--6-----------------------
CREATE   index #EX_TKEY ON #EXMPL1(tkey);

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#EXMPL1'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
			WHERE name is not null; 

INSERT top(10000) #EXMPL1(tkey, tf) select tkey, tf from #EXMPL1;

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#EXMPL1'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
			WHERE name is not null;

ALTER index #EX_TKEY on #EXMPL1 reorganize;

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#EXMLP1'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
			WHERE name is not null;

ALTER index #EX_TKEY on #EXMPL1 rebuild with (online = off);

SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
        OBJECT_ID(N'#EXMPL1'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
			WHERE name is not null;
go

--7
DROP index #EX_TKEY on #EXMPL1;
CREATE index #EX_TKEY on #EXMPL1(tkey) with (fillfactor = 65);
INSERT top(50)percent INTO #EXMPL1(tkey, tf) SELECT tkey, tf  FROM #EXMPL1;
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
       FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),    
       OBJECT_ID(N'#EXMPL1'), NULL, NULL, NULL) ss  JOIN sys.indexes ii 
                                     ON ss.object_id = ii.object_id and ss.index_id = ii.index_id  
										WHERE name is not null;
