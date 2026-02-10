<#
.SYNOPSIS
Windows Activation Management module for PowerShell.

.DESCRIPTION
The FreeActivate module provides comprehensive tools for managing Windows
activation and licensing. It includes functions for retrieving activation status,
validating activation patterns, configuring KMS (Key Management Service) activation,
and setting MAK (Multiple Activation Key) activation.

This module is designed for system administrators and IT professionals who need to
manage Windows licensing in enterprise environments. It provides a consistent,
validated interface for common activation tasks that would typically require
manual use of slmgr.vbs commands.

.PARAMETER None
This module does not accept parameters at the module level.

.INPUTS
None at the module level. See individual functions for specific input requirements.

.OUTPUTS
None at the module level. See individual functions for specific output types.

.EXAMPLE
PS C:\> Import-Module FreeActivate
PS C:\> Get-ActivationStatus

Description: Imports the module and retrieves the current Windows activation status.

.EXAMPLE
PS C:\> Set-KmsActivation -Server "kms.company.local" -Key "XXXXX-YYYYY-ZZZZZ-WWWWW-VVVVV"

Description: Configures Windows to use a KMS server for activation.

.EXAMPLE
PS C:\> Set-MakActivation -Key "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE"

Description: Activates Windows using a Multiple Activation Key (MAK).

.NOTES
Author: Michael Free
Date Created: January 29, 2026
Module Name: FreeActivate

Module Structure:
- Private/: Contains internal helper functions (not exported)
- Public/: Contains exported functions for user access

Exported Functions:
- Get-ActivationStatus: Retrieves Windows activation status
- Set-KmsActivation: Configures KMS-based activation
- Set-MakActivation: Configures MAK-based activation

Prerequisites:
- Windows operating system
- Administrative privileges for activation functions
- slmgr.vbs (included with Windows)
- Internet connectivity for MAK activation

Security Notes:
- Activation functions require elevated privileges
- Product keys should be treated as sensitive information
- Use in production environments with appropriate change controls
#>
foreach ($folder in @('Private', 'Public')) {
  $root = Join-Path -Path $PSScriptRoot -ChildPath $folder
  if (Test-Path -Path $root) {
    Write-Verbose "processing folder $root"
    $files = Get-ChildItem -Path $root -Filter '*.ps1'
    $files | Where-Object { $_.Name -notlike '*.Tests.ps1' } |
      ForEach-Object {
        Write-Verbose "Dot-sourcing $($_.Name)"
        . $_.FullName
      }
  }
}
$exportedFunctions = (Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Filter '*.ps1').BaseName
Export-ModuleMember -Function $exportedFunctions


