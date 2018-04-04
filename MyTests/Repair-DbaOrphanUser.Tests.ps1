<#
I would like to add this to the sqlcollaborative's fleet of Pester tests, but it
references things I happen to know about my own servers: namely which ones have 
one drive and which one has mulitple drives.

sqlcollaborative supplies DB backup files, which don't have a clue about how 
many drives a server has (regardless of the number of files the DB has).

sqlcollaborative has their own appveyor testing contrivance/scheme, but I 
don't *think* that environment describes any particular physical disk layout 
on the sql servers.

The "appveyor setup" is discussed a bit here: 
https://github.com/sqlcollaborative/dbatools/blob/master/contributing.md

#>
Set-StrictMode -Version Latest
$commandname = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")

# reset for a test
Get-Module dbatools | Remove-Module
Get-ChildItem ..\dbatools.psd1 | import-module

# MOROS has one drive, # ARES has two drives.
# this does not fail with the old version
Describe "Repair-DbaOrphanUser" -Tag $commandname {
    It "should not throw when run against a test database" {
        {Repair-DbaOrphanUser -database 'test_DbaOrphanUser' -SqlInstance 'moros\sql2008r2' -RemoveNotExisting -EnableException -verbose} | Should -Not -Throw
    }
}
 

# this fails with the old version 
 #get-dbadatabasefile -Database master -SqlInstance 'moros\sql2008' | out-null
