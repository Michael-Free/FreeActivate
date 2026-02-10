# FreeActivate PowerShell Module

A PowerShell module for activating Volume Licensed Windows Desktop and Windows Server operating systems from the command line.

## Overview

FreeActivate is a PowerShell module designed to simplify the activation of Windows operating systems using Volume Licensing keys (KMS and MAK). It provides a set of cmdlets to check activation status and perform activation operations.

## Features

- **Get-ActivationStatus**: Check the current activation status of Windows
- **Set-KmsActivation**: Activate Windows using a KMS (Key Management Service) server
- **Set-MakActivation**: Activate Windows using a MAK (Multiple Activation Key)

## Supported Operating Systems

- Windows 10
- Windows 11
- Windows Server 2016
- Windows Server 2019
- Windows Server 2022
- Windows Server 2025

## Installation

### From PowerShell Gallery
```powershell
Install-Module -Name FreeActivate
```

## Import the Module
```powershell
Import-Module -Name FreeActivate
```

## Key Functions

### Check Activation Status

```powershell
Get-ActivationStatus
```

### Activate using Key Management Server

```powershell
Set-KmsActivation -KmsServer "kms.yourdomain.com"
```

### Activate using Multiple Activation Key

```powershell
Set-MakActivation -ProductKey "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
```

## Requirements

- PowerShell 5.1 or higher
- Windows Desktop or Windows Server OS
- Administrative privileges for activation operations

## Module Information

- Version: v0.2.21
- Author: Michael Free
- License: See LICENSE file 
- Project URL: https://github.com/Michael-Free/FreeActivate/

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the terms included in the LICENSE file.

This is using the Free Custom License (FCL v1.0)

## Disclaimer
This module is provided as-is. Use it responsibly and ensure you have proper licensing for the Windows operating systems you are activating for.

