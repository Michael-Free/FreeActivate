# Requires -Version 5.1
# Requires -Modules Pester

Describe 'Basic sanity check' {

    It 'Should always pass' {
        $true | Should -BeTrue
    }

}
