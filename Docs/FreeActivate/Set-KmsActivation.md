---
document type: cmdlet
external help file: FreeActivate-Help.xml
HelpUri: ''
Locale: en-US
Module Name: FreeActivate
ms.date: 01/31/2026
PlatyPS schema version: 2024-05-01
title: Set-KmsActivation
---

# Set-KmsActivation

## SYNOPSIS

Configures and activates Windows using a KMS (Key Management Service) server.

## SYNTAX

### __AllParameterSets

```
Set-KmsActivation [-Server] <string> [-Key] <string> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Set-KmsActivation function configures Windows volume licensing by setting a KMS server,
installing a product key, and activating Windows.
It performs comprehensive validation
including network connectivity checks, administrator privilege verification, and parameter
format validation before attempting activation.

## EXAMPLES

### EXAMPLE 1

Set-KmsActivation -Server "kms01.company.com" -Key "XXXXX-YYYYY-ZZZZZ-WWWWW-VVVVV"

Description: Configures Windows to use kms01.company.com as the KMS server with the specified product key.

### EXAMPLE 2

Set-KmsActivation -Server "192.168.1.100" -Key "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE" -Confirm:$false

Description: Configures Windows to use a KMS server at 192.168.1.100 without confirmation prompt.

### EXAMPLE 3

Set-KmsActivation -Server "kms.company.local" -Key "12345-ABCDE-67890-FGHIJ-12345" -WhatIf

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

Specifies the Windows product key for activation.
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
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Server

Specifies the KMS server address.
Must be a valid IPv4 address or FQDN (Fully Qualified Domain Name).
The server must be reachable and have port 1688 open for KMS activation.

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
Returns the activation status from the Get-Activation function after successful configuration.

{{ Fill in the Description }}

## NOTES

Author: Michael Free
Date Created: January 29, 2026
Prerequisites:
- Must be run with administrative privileges
- Requires slmgr.vbs to be available (default Windows component)
- KMS server must be reachable and have port 1688 open
- Server must be a valid IPv4 address or FQDN
- Key must be in valid Windows product key format

What the function does:
1.
Validates administrator privileges
2.
Removes spaces from Server and Key parameters
3.
Validates parameter formats (IP/FQDN for Server, product key format for Key)
4.
Tests network connectivity to KMS server (ICMP and TCP port 1688)
5.
Executes slmgr.vbs commands with ShouldProcess support:
   - /ipk: Installs the product key
   - /skms: Sets the KMS server address
   - /ato: Activates Windows online
6.
Returns activation status using Get-Activation

Security: This function requires elevated privileges and modifies system licensing settings.
Use with caution in production environments.


## RELATED LINKS

{{ Fill in the related links here }}

