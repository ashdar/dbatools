<#
I would like to add this to the sqlcollaborative's fleet of Pester tests, but it
references things I happen to know about my own servers: namely which ones have 
one drive and which one has mulitple drives.

sqlcollaborative supplies DB backup files, which don't have a clue about how 
many drives a server has (regardless of the number of files the DB has).

The "appveyor setup" is discussed a bit here: 
https://github.com/sqlcollaborative/dbatools/blob/master/contributing.md

#>

$commandname = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
$path = split-path $PSScriptRoot  
#. "$PSScriptRoot\constants.ps1"
$path = join-path $path 'Tests'
$path = join-path $path constants.ps1
. $path

# reset for a test
Get-Module dbatools | Remove-Module
Get-ChildItem ..\dbatools.psd1 | import-module


Describe "Read-DbaBackupHeader" -Tag $commandname {
    # It looks like Read-DbaBackupHeader has been added since I looked at this last.
    It "should return a RecoveryModel of 'simple'" {
        (Read-DbaBackupHeader -SqlInstance $script:instance1 -Path 'C:\temp\backups\simple_test\full\simple_test_full_201800404.bak').RecoveryModel | Should -be 'SIMPLE'
    }
}
Describe "Get-DbaBackupInformation" -Tag $commandname {

    It "should Return a RecoveryModel attribute" {
        (Get-DbaBackupInformation -SqlInstance $script:instance1 -Path c:\temp\backups\simple_test).RecoveryModel | Should -Not -BeNullOrEmpty
    }

    It "should Return a RecoveryModel attribute of the correct value" {
        (Get-DbaBackupInformation -SqlInstance $script:instance1 -Path c:\temp\backups\simple_test | Where-Object {$PSItem.Type -eq 'Database'}).RecoveryModel | Should -Be 'SIMPLE'
    }
}
Describe "Get-DbaBackupInformation" -Tag $commandname {
    Get-DbaDatabase -SqlInstance $script:instance1 -NoSystemDb -database 'simple_test' | Remove-DbaDatabase -Confirm:$false
    # I just happen to know that the restoretime I use here is partway betwen the FULL and the DIFF that I took for this test.
    $results = Restore-DbaDatabase -MaintenanceSolution -path c:\temp\backups\simple_test -server $script:instance1 -DestinationFilePrefix 'Restore-DbaDatabaseSimple' -database 'simple_test' -enableexception -WithReplace -RestoreTime '2018-04-04 09:24:00'
    Get-DbaDatabase -SqlInstance $script:instance1 -NoSystemDb -database 'simple_test' | Remove-DbaDatabase -Confirm:$false

    # This needs a more stringent test. This is basically just "did not blow up"
    It "should have a decent result" {
        $results | Should -Not -BeNullOrEmpty
    }


}


# this fails with the old version 
 #get-dbadatabasefile -Database master -SqlInstance 'moros\sql2008' | out-null
