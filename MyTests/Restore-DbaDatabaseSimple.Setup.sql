

create database simple_test 
go
alter database simple_test  set recovery simple
go
backup database simple_test 
to disk = 'c:\temp\backups\simple_test\full\simple_test_full_201800404.bak'
with init
go
waitfor delay '00:01:00'
go
select GETDATE() 'full'
-- 2018-04-04 09:18:57.423
go
waitfor delay '00:05:00'
go
backup database simple_test 
to disk = 'c:\temp\backups\simple_test\diff\simple_test_diff_201804040924.bak'
with differential
select GETDATE() '1st_diff'
-- 2018-04-04 09:24:33.953
go

waitfor delay '00:05:00'
go

backup database simple_test 
to disk = 'c:\temp\backups\simple_test\diff\simple_test_diff_201804040929.bak'

with differential
select GETDATE() '2nd_diff'
-- 2018-04-04 09:29:34.037


-- drop database simple_test 

/*
Restore-DbaDatabase -maintenancesolution -path c:\temp\backups\simple_test -server 'moros\sql2008r2' -DestinationFilePrefix 'restoring' -database 'Restored_DbaDatabase' -verbose -enableexception -RestoreTime '2018-03-29 19:47'
*/


go

restore headeronly
from disk = 'c:\temp\backups\simple_test\full\simple_test_full_20180329.bak'

restore headeronly
from disk = 'c:\temp\backups\simple_test\diff\simple_test_diff_20180329.bak'
