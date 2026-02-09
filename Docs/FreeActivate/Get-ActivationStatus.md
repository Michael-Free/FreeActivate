---
document type: cmdlet
external help file: FreeActivate-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FreeActivate
ms.date: 01/31/2026
PlatyPS schema version: 2024-05-01
title: Get-ActivationStatus
---

# Get-ActivationStatus

## SYNOPSIS

Retrieves Windows activation status using the Software Licensing Management Tool (slmgr.vbs).

## SYNTAX

### __AllParameterSets

```
Get-ActivationStatus
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Get-ActivationStatus function executes the Software Licensing Management Tool (slmgr.vbs)
to retrieve detailed license information for the local Windows installation.
It specifically
extracts the license status from the output and returns it as a custom object.

## EXAMPLES

### EXAMPLE 1

Get-ActivationStatus

LicenseStatus
-------------
Licensed

Description: Retrieves the activation status of the local Windows installation.

### EXAMPLE 2

$status = Get-ActivationStatus
PS C:\> Write-Host "Windows is: $($status.LicenseStatus)"

Windows is: Licensed

Description: Stores the activation status in a variable and displays it.

## PARAMETERS

## INPUTS

### None. This function does not accept pipeline input.

{{ Fill in the Description }}

## OUTPUTS

### PSCustomObject
Returns a custom object with a LicenseStatus property containing the Windows activation status.

{{ Fill in the Description }}

## NOTES

Author: Michael Free
Date Created: January 29, 2026
Prerequisites:
- Must be run with administrative privileges
- Requires slmgr.vbs to be available (default Windows component)
- Only works on Windows systems with Software Licensing service

The function executes: cscript.exe /NoLogo $script:slmgrPath /dlv
Where $script:slmgrPath should be defined elsewhere in the script/module.

Common License Status values:
- Licensed: Product is activated
- Initial grace period: Evaluation period
- Licensed (expired): Activation has expired
- Notification: Grace period expired, notifications active


## RELATED LINKS

{{ Fill in the related links here }}

