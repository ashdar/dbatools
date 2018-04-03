USE [master]
GO
-- execute sp_helplogins
go
-- create database test_DbaOrphanUser
go
/*
CREATE LOGIN [scully] WITH PASSWORD=N'asdfasdf&&&09232%ABD' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
CREATE LOGIN [mulder] WITH PASSWORD=N'aAsdfasdf&&&09232%ABD' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
*/
GO
USE [test_DbaOrphanUser]
GO
CREATE USER [scully] FOR LOGIN [scully]
go
CREATE USER mulder FOR LOGIN mulder
GO
use master
go
/*
select 'login' description, name, sid
from sys.server_principals sp
where sp.name in ('scully','mulder')
union all
select 'user' description, name, sid
from test_DbaOrphanUser.sys.database_principals dp
where dp.name in ('scully','mulder')

*/

go
-- backup database test_DbaOrphanUser to disk = 'c:\temp\test_DbaOrphanUser.bak' with init
go
drop database test_DbaOrphanUser
go
drop login mulder
go
drop login scully
go
CREATE LOGIN [scully] WITH PASSWORD=N'asdfasdf&&&09232%ABD' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
go
restore database test_DbaOrphanUser from disk = 'c:\temp\test_DbaOrphanUser.bak'
go
-- execute test_DbaOrphanUser.dbo.sp_helpuser 
go
use master;
go
drop database test_DbaOrphanUser 
go