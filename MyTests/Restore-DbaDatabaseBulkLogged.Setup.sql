

create database bulklogged_test 
go
alter database bulklogged_test  set recovery bulk_logged
go
backup database bulklogged_test 
to disk = 'c:\temp\backups\bulklogged_test\full\bulklogged_test_full_20180404.bak'
with init
go
select GETDATE() 'full'
-- 2018-04-04 09:10:32.397
go
waitfor delay '00:05:00'
go
backup database bulklogged_test 
to disk = 'c:\temp\backups\foo\diff\bulklogged_test_diff_20180403091500.bak'
with differential
select GETDATE() '1st_diff'
-- 2018-04-04 09:16:49.633
go
waitfor delay '00:05:00'
go

backup database bulklogged_test 
to disk = 'c:\temp\backups\foo\diff\bulklogged_test_diff_20180404092000.bak'
with differential
select GETDATE() '2nd_diff'
-- 2018-04-04 09:21:49.680

go

-- 
-- drop database bulklogged_test 

restore database bulklogged_test
from disk = 'c:\temp\backups\bulklogged_test\full\bulklogged_test_full_20180404.bak'
with stopat = '2018-04-04 09:17:00'
-- STOPAT when restoring a bulk logged DB works OK.
go

restore headeronly
from disk = 'c:\temp\backups\bulklogged_test\full\bulklogged_test_full_20180404.bak'
-- RecoveryModel = 'BULK-LOGGED'

restore headeronly
from disk = 'c:\temp\backups\bulklogged_test\diff\bulklogged_test_diff_20180403091500.bak'

restore headeronly
from disk = 'c:\temp\backups\bulklogged_test\diff\bulklogged_test_diff_20180404092000.bak'
