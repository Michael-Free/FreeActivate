# Get-ActivationPattern.Tests.ps1
# Note: No BeforeAll block needed anymore!

Describe 'Get-ActivationPattern Function Tests' {
    Describe 'Parameter Validation' {
        Context 'When no parameters are provided' {
            It 'Should throw an error when no parameters are provided' {
                { Get-ActivationPattern -ErrorAction Stop } | Should -Throw 'At least one parameter must be provided*'
            }

            It 'Should throw with verbose output when no parameters are provided' {
                { Get-ActivationPattern -Verbose -ErrorAction Stop } | Should -Throw 'At least one parameter must be provided*'
            }
        }

        Context 'When invalid patterns are provided' {
            It 'Should throw for invalid IPv4 address' {
                { Get-ActivationPattern -IpAddress '999.999.999.999' -ErrorAction Stop } | Should -Throw
            }

            It 'Should throw for invalid domain name' {
                { Get-ActivationPattern -DomainName 'invalid_domain' -ErrorAction Stop } | Should -Throw
            }

            It 'Should throw for invalid Windows key format' {
                { Get-ActivationPattern -WindowsKey 'ABCDE-12345-INVALID' -ErrorAction Stop } | Should -Throw
            }

            It 'Should throw for Windows key with invalid characters' {
                { Get-ActivationPattern -WindowsKey 'ABCDE-12345-FGHIJ-67890-!@#$%' -ErrorAction Stop } | Should -Throw
            }
        }

        Context 'When valid patterns are provided' {
            It 'Should accept valid IPv4 address' {
                { Get-ActivationPattern -IpAddress '192.168.1.1' } | Should -Not -Throw
            }

            It 'Should accept valid domain name' {
                { Get-ActivationPattern -DomainName 'server01.example.com' } | Should -Not -Throw
            }

            It 'Should accept valid Windows key' {
                { Get-ActivationPattern -WindowsKey 'ABCDE-12345-FGHIJ-67890-KLMNO' } | Should -Not -Throw
            }
        }
    }

    Describe 'Output Validation' {
        Context 'Single parameter outputs' {
            It 'Should return object with only IpAddress when IpAddress provided' {
                $result = Get-ActivationPattern -IpAddress '192.168.1.1'
                $result | Should -Not -Be $null
                $result.IpAddress | Should -Be '192.168.1.1'
                $result.DomainName | Should -Be $null
                $result.WindowsKey | Should -Be $null
            }

            It 'Should return object with only DomainName when DomainName provided' {
                $result = Get-ActivationPattern -DomainName 'server01.example.com'
                $result | Should -Not -Be $null
                $result.DomainName | Should -Be 'server01.example.com'
                $result.IpAddress | Should -Be $null
                $result.WindowsKey | Should -Be $null
            }

            It 'Should return object with only WindowsKey when WindowsKey provided' {
                $result = Get-ActivationPattern -WindowsKey 'ABCDE-12345-FGHIJ-67890-KLMNO'
                $result | Should -Not -Be $null
                $result.WindowsKey | Should -Be 'ABCDE-12345-FGHIJ-67890-KLMNO'
                $result.IpAddress | Should -Be $null
                $result.DomainName | Should -Be $null
            }
        }

        Context 'Multiple parameter outputs' {
            It 'Should return object with all provided parameters' {
                $result = Get-ActivationPattern -IpAddress '192.168.1.1' -DomainName 'server01.example.com' -WindowsKey 'ABCDE-12345-FGHIJ-67890-KLMNO'
                $result | Should -Not -Be $null
                $result.IpAddress | Should -Be '192.168.1.1'
                $result.DomainName | Should -Be 'server01.example.com'
                $result.WindowsKey | Should -Be 'ABCDE-12345-FGHIJ-67890-KLMNO'
            }

            It 'Should return object with IpAddress and DomainName when both provided' {
                $result = Get-ActivationPattern -IpAddress '10.0.0.1' -DomainName 'example.org'
                $result | Should -Not -Be $null
                $result.IpAddress | Should -Be '10.0.0.1'
                $result.DomainName | Should -Be 'example.org'
                $result.WindowsKey | Should -Be $null
            }

            It 'Should return object with IpAddress and WindowsKey when both provided' {
                $result = Get-ActivationPattern -IpAddress '172.16.0.1' -WindowsKey '12345-ABCDE-67890-FGHIJ-54321'
                $result | Should -Not -Be $null
                $result.IpAddress | Should -Be '172.16.0.1'
                $result.WindowsKey | Should -Be '12345-ABCDE-67890-FGHIJ-54321'
                $result.DomainName | Should -Be $null
            }

            It 'Should return object with DomainName and WindowsKey when both provided' {
                $result = Get-ActivationPattern -DomainName 'test.example.net' -WindowsKey 'AAAAA-BBBBB-CCCCC-DDDDD-EEEEE'
                $result | Should -Not -Be $null
                $result.DomainName | Should -Be 'test.example.net'
                $result.WindowsKey | Should -Be 'AAAAA-BBBBB-CCCCC-DDDDD-EEEEE'
                $result.IpAddress | Should -Be $null
            }
        }
    }

    Describe 'Verbose Output' {
        Context 'Verbose message logging' {
            It 'Should log verbose messages for single parameter' {
                $output = Get-ActivationPattern -IpAddress '192.168.1.1' -Verbose 4>&1
                $output | Where-Object { $_ -like '*IP ADDRESS PROVIDED:*' } | Should -Not -BeNullOrEmpty
            }

            It 'Should log verbose messages for multiple parameters' {
                $output = Get-ActivationPattern -IpAddress '192.168.1.1' -DomainName 'example.com' -Verbose 4>&1
                $output | Where-Object { $_ -like '*IP ADDRESS PROVIDED:*' } | Should -Not -BeNullOrEmpty
                $output | Where-Object { $_ -like '*FQDN PROVIDED:*' } | Should -Not -BeNullOrEmpty
            }

            It 'Should log verbose messages for all parameters' {
                $output = Get-ActivationPattern -IpAddress '192.168.1.1' -DomainName 'example.com' -WindowsKey 'ABCDE-12345-FGHIJ-67890-KLMNO' -Verbose 4>&1
                $output | Where-Object { $_ -like '*IP ADDRESS PROVIDED:*' } | Should -Not -BeNullOrEmpty
                $output | Where-Object { $_ -like '*FQDN PROVIDED:*' } | Should -Not -BeNullOrEmpty
                $output | Where-Object { $_ -like '*WINDOWS KEY PROVIDED:*' } | Should -Not -BeNullOrEmpty
            }
        }
    }

    Describe 'Edge Cases and Boundary Testing' {
        Context 'IPv4 address boundaries' {
            It 'Should accept minimum IPv4 address (0.0.0.0)' {
                { Get-ActivationPattern -IpAddress '0.0.0.0' } | Should -Not -Throw
            }

            It 'Should accept maximum IPv4 address (255.255.255.255)' {
                { Get-ActivationPattern -IpAddress '255.255.255.255' } | Should -Not -Throw
            }

            It 'Should reject IPv4 address > 255' {
                { Get-ActivationPattern -IpAddress '256.0.0.0' -ErrorAction Stop } | Should -Throw
            }

            It 'Should reject IPv4 address with leading zeros' {
                { Get-ActivationPattern -IpAddress '001.002.003.004' -ErrorAction Stop } | Should -Throw
            }
        }

        Context 'Domain name boundaries' {
            It 'Should accept single label domain with TLD' {
                { Get-ActivationPattern -DomainName 'example.com' } | Should -Not -Throw
            }

            It 'Should accept multi-label domain' {
                { Get-ActivationPattern -DomainName 'sub1.sub2.example.co.uk' } | Should -Not -Throw
            }

            It 'Should reject domain without TLD' {
                { Get-ActivationPattern -DomainName 'example' -ErrorAction Stop } | Should -Throw
            }

            It 'Should reject domain with invalid characters' {
                { Get-ActivationPattern -DomainName 'ex@mple.com' -ErrorAction Stop } | Should -Throw
            }
        }

        Context 'Windows key boundaries' {
            It 'Should accept Windows key with all numbers' {
                { Get-ActivationPattern -WindowsKey '12345-67890-12345-67890-12345' } | Should -Not -Throw
            }

            It 'Should accept Windows key with all letters' {
                { Get-ActivationPattern -WindowsKey 'ABCDE-FGHIJ-KLMNO-PQRST-UVWXY' } | Should -Not -Throw
            }

            It 'Should accept Windows key with mixed alphanumeric' {
                { Get-ActivationPattern -WindowsKey 'A1B2C-D3E4F-G5H6I-J7K8L-M9N0O' } | Should -Not -Throw
            }

            It 'Should reject Windows key with wrong separator' {
                { Get-ActivationPattern -WindowsKey 'ABCDE_12345_FGHIJ_67890_KLMNO' -ErrorAction Stop } | Should -Throw
            }

            It 'Should reject Windows key with wrong group length' {
                { Get-ActivationPattern -WindowsKey 'ABCD-1234-EFGH-5678-IJKL' -ErrorAction Stop } | Should -Throw
            }
        }
    }

    Describe 'Parameter Combinations' {
        It 'Should work with positional parameters' {
            $result = Get-ActivationPattern -WindowsKey 'AAAAA-BBBBB-CCCCC-DDDDD-EEEEE'
            $result.WindowsKey | Should -Be 'AAAAA-BBBBB-CCCCC-DDDDD-EEEEE'
        }

        It 'Should handle case-insensitive parameters' {
            $result = Get-ActivationPattern -ipaddress '192.168.1.1' -DOMAINNAME 'example.com'
            $result.IpAddress | Should -Be '192.168.1.1'
            $result.DomainName | Should -Be 'example.com'
        }
    }
}