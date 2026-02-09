function Get-ActivationPattern {
  <#
  .SYNOPSIS
  Validates and extracts activation-related patterns including IP addresses, domain names, and Windows product keys.

  .DESCRIPTION
  The Get-ActivationPattern function validates input patterns for IP addresses, fully qualified domain names (FQDNs),
  and Windows product keys. It ensures at least one parameter is provided and returns a custom object containing
  only the validated parameters that were supplied. Each parameter has strict validation patterns to ensure format
  correctness.

  .PARAMETER IpAddress
  Specifies an IPv4 address to validate. Must match standard IPv4 format (e.g., 192.168.1.1).

  .PARAMETER DomainName
  Specifies a fully qualified domain name (FQDN) to validate. Must follow standard domain naming conventions.

  .PARAMETER WindowsKey
  Specifies a Windows product key to validate. Must follow the 5x5 character group format (AAAAA-BBBBB-CCCCC-DDDDD-EEEEE).

  .INPUTS
  None. You cannot pipe input to this function.

  .OUTPUTS
  PSCustomObject
  Returns a custom object containing the validated parameters that were provided.
  The object properties correspond to the parameter names with valid values.

  .EXAMPLE
  PS C:\> Get-ActivationPattern -IpAddress "192.168.1.1"

  Validates the IP address and returns an object with the IpAddress property.

  .EXAMPLE
  PS C:\> Get-ActivationPattern -DomainName "server01.example.com" -WindowsKey "ABCDE-12345-FGHIJ-67890-KLMNO"

  Validates both domain name and Windows key, returning an object with both DomainName and WindowsKey properties.

  .EXAMPLE
  PS C:\> Get-ActivationPattern -WindowsKey "12345-ABCDE-67890-FGHIJ-12345"

  Validates only the Windows product key and returns an object with the WindowsKey property.

  .EXAMPLE
  PS C:\> Get-ActivationPattern -Verbose

  Throws an error because at least one parameter must be provided. Verbose output shows parameter validation steps.

  .NOTES
  Author: Michael Free
  Date Created: January 29, 2026

  Validation Patterns:
  - IpAddress: Standard IPv4 format (0-255.0-255.0-255.0-255)
  - DomainName: Standard FQDN format with labels 1-63 chars, total length 1-255 chars
  - WindowsKey: 5 groups of 5 alphanumeric characters separated by hyphens

  The function requires at least one parameter to be provided.
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $false)]
    [ValidatePattern('^(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$')]
    [string]$IpAddress,

    [Parameter(Mandatory = $false)]
    [ValidatePattern('^(?=.{1,255}$)([a-zA-Z0-9]+(-[a-zA-Z0-9]+)*\.)+[a-zA-Z]{2,}$')]
    [string]$DomainName,

    [Parameter(Mandatory = $false)]
    [ValidatePattern('^[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}-[A-Za-z0-9]{5}$')]
    [string]$WindowsKey
  )

  begin {
    $providedParams = @($IpAddress, $DomainName, $WindowsKey) | Where-Object { -not [string]::IsNullOrEmpty($_) }
    if ($providedParams.Count -eq 0) {
      throw 'At least one parameter must be provided (IpAddress, DomainName, or WindowsKey)'
    }

    Write-Verbose 'Parameters provided:'
    if ($IpAddress) { Write-Verbose "  IP ADDRESS PROVIDED: $IpAddress" }
    if ($DomainName) { Write-Verbose "  FQDN PROVIDED: $DomainName" }
    if ($WindowsKey) { Write-Verbose "  WINDOWS KEY PROVIDED: $WindowsKey" }
  }

  process {
    $validValues = @{}

    if ($IpAddress) {
      $validValues['IpAddress'] = $IpAddress
    }
    if ($DomainName) {
      $validValues['DomainName'] = $DomainName
    }
    if ($WindowsKey) {
      $validValues['WindowsKey'] = $WindowsKey
    }

    return [PSCustomObject]$validValues
  }
}

