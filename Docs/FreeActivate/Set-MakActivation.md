---
document type: cmdlet
external help file: FreeActivate-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FreeActivate
ms.date: 01/31/2026
PlatyPS schema version: 2024-05-01
title: Set-MakActivation
---

# Set-MakActivation

## SYNOPSIS

Activates Windows using a MAK (Multiple Activation Key) for volume licensing.

## SYNTAX

### __AllParameterSets

```
Set-MakActivation [-Key] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Set-MakActivation function installs and activates a Multiple Activation Key (MAK)
for Windows volume licensing.
This method is used for one-time activation directly
with Microsoft's activation servers, as opposed to KMS (Key Management Service)
which requires an on-premises server.
The function validates the key format and
requires administrative privileges.

## EXAMPLES

### EXAMPLE 1

Set-MakActivation -Key "XXXXX-YYYYY-ZZZZZ-WWWWW-VVVVV"

Description: Installs and activates the specified MAK key on the local Windows installation.

### EXAMPLE 2

Set-MakActivation -Key "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE" -Confirm:$false

Description: Activates Windows with the specified MAK key without confirmation prompt.

### EXAMPLE 3

Set-MakActivation -Key "12345-ABCDE-67890-FGHIJ-12345" -WhatIf

Description: Shows what would happen without actually making changes (WhatIf scenario).

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Key

Specifies the Windows Multiple Activation Key (MAK).
Must be in the standard 5x5 format
(AAAAA-BBBBB-CCCCC-DDDDD-EEEEE).
The key will be converted to uppercase automatically.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. This function does not accept pipeline input.

{{ Fill in the Description }}

## OUTPUTS

### PSCustomObject
Returns the activation status from the Get-Activation function after successful activation.

{{ Fill in the Description }}

## NOTES

Author: Michael Free
Date Created: January 29, 2026
Prerequisites:
- Must be run with administrative privileges
- Requires slmgr.vbs to be available (default Windows component)
- Key must be in valid Windows product key format
- Internet connectivity is required for MAK activation
- The MAK key must have available activations

What the function does:
1.
Validates administrator privileges
2.
Removes spaces from the Key parameter
3.
Validates the key format against the Windows key regex pattern
4.
Converts the key to uppercase
5.
Executes slmgr.vbs commands with ShouldProcess support:
   - /ipk: Installs the product key
   - /ato: Activates Windows online via Microsoft servers
6.
Returns activation status using Get-Activation

MAK vs KMS Activation:
- MAK: One-time activation directly with Microsoft, suitable for devices that cannot
  connect to a KMS server regularly
- KMS: Requires connection to a local KMS server every 180 days, suitable for large
  enterprise environments with on-premises infrastructure

Security: This function requires elevated privileges and modifies system licensing settings.
Use with caution in production environments.


## RELATED LINKS

{{ Fill in the related links here }}

