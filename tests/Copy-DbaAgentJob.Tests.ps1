$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {
        $paramCount = 10
        $defaultParamCount = 13
        [object[]]$params = (Get-ChildItem function:\Copy-DbaAgentJob).Parameters.Keys
        $knownParameters = 'Source', 'SourceSqlCredential', 'Destination', 'DestinationSqlCredential', 'Job', 'ExcludeJob', 'DisableOnSource', 'DisableOnDestination', 'Force', 'EnableException'
        It "Should contain our specific parameters" {
            ( (Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params -IncludeEqual | Where-Object SideIndicator -eq "==").Count ) | Should Be $paramCount
        }
        It "Should only contain $paramCount parameters" {
            $params.Count - $defaultParamCount | Should Be $paramCount
        }
    }
}

Describe "$commandname Integration Tests" -Tag "IntegrationTests" {
    BeforeAll {
        $null = New-DbaAgentJob -SqlInstance $script:instance2 -Job dbatoolsci_copyjob
        $null = New-DbaAgentJob -SqlInstance $script:instance2 -Job dbatoolsci_copyjob_disabled
        $sourcejobs = Get-DbaAgentJob -SqlInstance $script:instance2
        $destjobs = Get-DbaAgentJob -SqlInstance $script:instance3
    }
    AfterAll {
        $null = Remove-DbaAgentJob -SqlInstance $script:instance2, $script:instance3 -Job dbatoolsci_copyjob, dbatoolsci_copyjob_disabled
    }

    Context "Command copies jobs properly" {
        $results = Copy-DbaAgentJob -Source $script:instance2 -Destination $script:instance3 -Job dbatoolsci_copyjob

        It "returns one success" {
            $results.Name -eq "dbatoolsci_copyjob"
            $results.Status -eq "Successful"
        }

        It "did not copy dbatoolsci_copyjob_disabled" {
            Get-DbaAgentJob -SqlInstance $script:instance3 -Job dbatoolsci_copyjob_disabled | Should -Be $null
        }

        It "disables jobs when requested" {
            (Get-DbaAgentJob -SqlInstance $script:instance2 -Job dbatoolsci_copyjob_disabled).Enabled
            $results = Copy-DbaAgentJob -Source $script:instance2 -Destination $script:instance3 -Job dbatoolsci_copyjob_disabled -DisableOnSource -DisableOnDestination
            (Get-DbaAgentJob -SqlInstance $script:instance2 -Job dbatoolsci_copyjob_disabled).Enabled | Should -Be $false
            (Get-DbaAgentJob -SqlInstance $script:instance3 -Job dbatoolsci_copyjob_disabled).Enabled | Should -Be $false
        }
    }
}