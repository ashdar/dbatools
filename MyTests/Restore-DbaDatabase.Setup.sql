

create database test_Restore_DbaDatabase 
go
alter database test_Restore_DbaDatabase  set recovery simple
go
backup database test_Restore_DbaDatabase 
to disk = 'c:\temp\backups\foo\full\test_Restore_DbaDatabase_full_20180329.bak'
with init
go
waitfor delay '00:01:00'
go
select GETDATE()
-- 2018-03-29 19:47:53.950
go
waitfor delay '00:05:00'
go
backup database test_Restore_DbaDatabase 
to disk = 'c:\temp\backups\foo\diff\test_Restore_DbaDatabase_diff_20180329.bak'
with differential
go
backup database test_Restore_DbaDatabase 
to disk = 'c:\temp\backups\foo\diff\test_Restore_DbaDatabase_diff_20180403.bak'
with differential


-- drop database test_Restore_DbaDatabase 

/*
Restore-DbaDatabase -maintenancesolution -path c:\temp\backups\foo -server 'moros\sql2008r2' -DestinationFilePrefix 'restoring' -database 'Restored_DbaDatabase' -verbose -enableexception -RestoreTime '2018-03-29 19:47'
*/


go

restore headeronly
from disk = 'c:\temp\backups\foo\full\test_Restore_DbaDatabase_full_20180329.bak'

restore headeronly
from disk = 'c:\temp\backups\foo\diff\test_Restore_DbaDatabase_diff_20180329.bak'
